
module EventMachineMOM
  class SyncServerController
    extend BaseLogger

    def initialize websocket
      @websocket = websocket

      @websocket.onmessage do |msg| 
        onmessage msg
      end

      @websocket.onopen do
        onopen msg
      end

    end

    def broadcast msg
      @servers.values.each do |server|
        server.send_msg msg
      end
    end

    private

    def onopen
      SyncServer.logger.info "sync: connection opened"
    end

    def onmessage msg
      SyncServer.logger.info "sync: received message #{msg}"
      if msg.eql? "update"
        update_servers
      else
        Channel.broadcast JSON.parse(msg)
      end
    end

  end
end
