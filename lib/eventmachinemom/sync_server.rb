module EventMachineMOM
  class SyncServer
    extend BaseLogger

    def initialize host = '0.0.0.0', port = 3000
        EventMachine::WebSocket.run(host: host, port: port) do |ws|
          ws.onmessage do |msg| 
            SyncServer.logger.info "SyncServer: received message #{msg}"
            Channel.broadcast JSON.parse(msg)
          end
          ws.onopen do |msg|
            SyncServer.logger.info "SyncServer: connection opened"
          end
        end
    end

  end
end
