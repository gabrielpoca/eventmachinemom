module EventMachineMOM
  class WebsocketServer
    extend BaseLogger

    def initialize websocket
      @websocket = websocket
      @user = User.create websocket
      @sid = Hash.new

      @websocket.onopen do
        onopen
      end

      @websocket.onmessage do |raw_msg|
        onmessage raw_msg
      end

      @websocket.onclose do
        WebsocketServer.logger.debug "Connection closed"
      end
    end

    private

    def onopen
      WebsocketServer.logger.debug "websocket: connection open"
      @websocket.send @user.uid.to_json
      subscribe "all" 
    end

    def onmessage raw_msg
      WebsocketServer.logger.debug "websocket message: #{raw_msg}"
      msg = JSON.parse(raw_msg)
      if msg[0][0] == "unsubscribe"
        unsubscribe msg[1]
      elsif msg[0][0] == "subscribe"
        subscribe msg[1], "persistent".eql?(msg[0][1])
      else
        Channel.broadcast msg
        SyncServer.broadcast raw_msg
      end

    end

    def unsubscribe name
      channel = Channel.find_or_create(name)
      channel.unsubscribe @sid[channel.name] unless @sid[channel.name].nil?
    end

    def subscribe name, persistent = false
      channel = Channel.find_or_create(name, persistent)
      channel.get_messages.each do |msg|
        @user.send msg.text
      end if channel.persistent
      @sid[channel.name] = channel.subscribe { |msg| @user.send msg }
    end

  end
end
