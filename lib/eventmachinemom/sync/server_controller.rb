module EventMachineMOM
  module Sync
    class ServerController
      extend BaseLogger

      def initialize websocket
        @websocket = websocket

        @websocket.onmessage do |msg|
          onmessage msg
        end

        @websocket.onopen do
          onopen
        end
      end

      def broadcast msg
        @servers.values.each do |server|
          server.send_msg msg
        end
      end

      private

      def onopen
        ServerController.logger.info "sync: connection opened"
      end

      def onmessage msg
        ServerController.logger.info "sync: received message #{msg}"
        if msg.eql? "update"
          SyncServer.update_servers
        else
          Channel.broadcast JSON.parse(msg)
        end
      end

    end
  end
end
