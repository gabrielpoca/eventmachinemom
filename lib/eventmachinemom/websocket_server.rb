module EventMachineMOM
  class WebsocketServer
    extend BaseLogger

    def initialize websocket, log = false
      @log = log
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
      @websocket.send [["user_id"], @user.uid].to_json
      subscribe "all"
    end

    def onmessage raw_msg
      WebsocketServer.logger.debug "websocket message: #{raw_msg}"
      msg = JSON.parse(raw_msg)
      if msg[0][0] == "unsubscribe"
        unsubscribe msg[1]
      elsif msg[0][0] == "subscribe"
        subscribe msg[1], msg[0][1]
      else
        Logger.log_message if @log
        Channel.broadcast msg
        SyncServer.broadcast raw_msg
      end
    end

    def unsubscribe name
      channel = Channel.find_or_create(name)
      channel.unsubscribe @sid[channel.name] unless @sid[channel.name].nil?
    end

    def pop name
      channel = Channel.find_or_create name, false
      channel.pop { |msg| @user.send msg }
    end

    def subscribe name, mode = false
      @user.send channel_exists_message name
      channel = Channel.find_or_create(name, mode)
      if mode.eql? "persistente"
        channel.get_messages.each do |msg|
          @user.send msg.text
        end if channel.mode
        @sid[channel.name] = channel.subscribe { |msg| @user.send msg }
      elsif mode.eql? "task"
        channel.pop { |msg| @user.send msg }
      else
        @sid[channel.name] = channel.subscribe { |msg| @user.send msg }
      end
    end

    private

    def channel_exists_message name
      if Channel.exists? name
        warning = "[[\"#{name}\"],\"Channel already exists! Subscribed.\"]"
      else
        warning ||= "[[\"#{name}\"],\"Subscribed.\"]"
      end
    end

  end
end
