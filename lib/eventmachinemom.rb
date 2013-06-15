require 'em-websocket'
require 'em-websocket-client'
require 'json'
require 'logger'
require 'pry'
require 'pry-debugger'

require 'util/logger'

require 'eventmachinemom/version'
require 'eventmachinemom/user'
require 'eventmachinemom/baselogger'
require 'eventmachinemom/database'
require 'eventmachinemom/models/session'
require 'eventmachinemom/models/server'
require 'eventmachinemom/channel'

require 'eventmachinemom/sync/base'
require 'eventmachinemom/sync/client_controller'
require 'eventmachinemom/sync/server_controller'
require 'eventmachinemom/sync/sync_server'

require 'eventmachinemom/websocket_server'

module EventMachineMOM
  class Application
    extend BaseLogger

    def initialize host = '0.0.0.0', port = 8080, sync_port = 3000
      EventMachine.run do

        SyncServer.create host, sync_port
        Logger.log.debug "sync listening"

        EventMachine::WebSocket.run(:host => host, :port => port) do |ws|
          WebsocketServer.new ws
        end
        Logger.log.debug "websocket listening"

      end
    end

  end
end

