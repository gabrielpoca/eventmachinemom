require 'em-websocket-client'

module EventMachineMOM
  class SyncServer
    extend BaseLogger

    attr_accessor :servers
    attr_accessor :server

    def initialize host = '0.0.0.0', port = 3000
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
      @servers.each do |server|
        server.send_msg msg
      end
    end

    private

    def update_servers inform = false
      @servers.each { |server| server.close_connection } unless @servers.nil?
      @servers = Array.new

      Server.where(active: true).select do |server|
        unless server.eql?(@server) || server.nil?
          connection = EventMachine::WebSocketClient.connect(server.host)
          connection.callback do
            SyncServer.logger.info "Connected to server #{server.id}"
            @servers.push connection
            connection.send_msg("update") if inform
          end
        end
      end
    end

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

  end
end
