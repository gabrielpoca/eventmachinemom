module EventMachineMOM
  class SyncServer
    extend SyncBase

    def initialize host, port
      @server = Server.create host: "ws://#{host}:#{port}", active: 1
      @servers = Hash.new

      EventMachine::WebSocket.run(host: host, port: port) do |ws|
        Sync::ServerController.new ws
      end

      update_servers true
    end

    def broadcast msg
      @servers.values.each do |server|
        server.send_msg msg
      end
    end

    def update_servers inform = false
      Logger.log.debug "updating servers list"
      Server.active.each do |server|
        if @servers.keys.include? server.id
          next
        end

        if @server.host.eql?(server.host)
          if !@server.id.eql?(server.id)
            server.update_attributes!(active: false)
            @servers.delete server.id
            Logger.log.info "removing old entry from current host"
          end
          next
        end

        Sync::ClientController.new server, @servers, inform
      end
    end

  end
end
