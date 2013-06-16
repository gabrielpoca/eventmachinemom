# handles each connection to other servers
# it is used to send messages.

module EventMachineMOM
  module Sync
    class ClientController

      def initialize server, servers_pool, inform
        @server = server
        @inform = inform
        @servers_pool = servers_pool
        @connection = EventMachine::WebSocketClient.connect(@server.host)

        @connection.callback do
          callback
        end

        @connection.disconnect do |message|
          disconnect message
        end
      end

      private

      def callback
        @servers_pool[@server.id] = @connection
        @connection.send_msg("update") if @inform
      end

      def disconnect message
        @server.update_attributes!(active: false)
        @servers_pool.delete @server.id
      end
    end
  end
end
