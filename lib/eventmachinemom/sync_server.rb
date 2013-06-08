require 'em-websocket-client'

module EventMachineMOM
  class SyncServer
    extend BaseLogger

    attr_accessor :servers
    attr_accessor :server

    def initialize host = '0.0.0.0', port = 3000
      @servers = Hash.new
      @server = Server.create host: "ws://#{host}:#{port}", active: 1

      EventMachine::WebSocket.run(host: host, port: port) do |ws|
        ws.onmessage do |msg| 
          onmessage msg
        end
        ws.onopen do |msg|
          onopen msg
        end
      end

      update_servers true
    end

    def broadcast msg
      @servers.values.each do |server|
        server.send_msg msg
      end
    end

    private

    def onopen msg
      SyncServer.logger.info "SyncServer: connection opened"
    end

    def onmessage msg
      SyncServer.logger.info "SyncServer: received message #{msg}"
      if msg.eql? "update"
        update_servers
      else
        Channel.broadcast JSON.parse(msg)
      end
    end


    def update_servers inform = false
      Server.active.each do |server|
        if @servers.keys.include? server.id
          next
        end

        if @server.host.eql?(server.host) 
          if !@server.id.eql?(server.id)
            SyncServer.logger.info "Old entry in database id: #{server.id} host: #{server.host}, removing..."
            server.update_attributes!(active: false)
            @servers.delete server.id
          end
          next
        end

        connection = EventMachine::WebSocketClient.connect(server.host)
        connection.callback do
          SyncServer.logger.info "Connected to server #{server.id}: #{server.host}"
          @servers[server.id] = connection
          connection.send_msg("update") if inform
        end

        connection.errback do |error|
          SyncServer.logger.info "error from server #{server.id}"
        end

        connection.disconnect do |error|
          SyncServer.logger.info "server #{server.id} disconnected"
          server.update_attributes!(active: false)
          @servers.delete server.id
        end
      end
    end

  end
end
