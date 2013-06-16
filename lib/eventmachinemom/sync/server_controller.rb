# handles each connection to the sync server.
# it receives broadcast and update messages.
# it doesn't send messages.

module EventMachineMOM
  module Sync
    class ServerController

      def initialize websocket
        @websocket = websocket

        @websocket.onmessage do |msg|
          onmessage msg
        end

        @websocket.onopen do
          onopen
        end
      end

      private

      def onopen
        Logger.log.debug "sync opened"
      end

      def onmessage msg
        Logger.log.debug "sync received #{msg}"
        if msg.eql? "update"
          SyncServer.update_servers
        else
          Channel.broadcast JSON.parse(msg)
        end
      end

    end
  end
end
