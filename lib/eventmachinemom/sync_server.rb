require 'em-websocket-client'

module EventMachineMOM
  class SyncServer
    extend SyncBase
    extend BaseLogger

    attr_accessor :servers
    attr_accessor :server

    def initialize host = '0.0.0.0', port = 3000
      @servers = Hash.new
      @server = Server.create host: "ws://#{host}:#{port}", active: 1

      EventMachine::WebSocket.run(host: host, port: port) do |ws|
        SyncServerController.new ws
      end

      update_servers true
    end

    def broadcast msg
      @servers.values.each do |server|
        server.send_msg msg
      end
    end
    
    def update_servers inform = false
      Server.active.each do |server|
        if @servers.keys.include? server.id
          next
        end

        if @server.host.eql?(server.host) 
          if !@server.id.eql?(server.id)
            server.update_attributes!(active: false)
            @servers.delete server.id
          end
          next
        end

        SyncClientController.new server, @servers
      end
    end

  end
end
