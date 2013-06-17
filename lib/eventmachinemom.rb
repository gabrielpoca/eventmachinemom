require 'em-websocket'
require 'em-websocket-client'
require 'json'
require 'logger'
require 'pry'
require 'pry-debugger'

require 'eventmachinemom/util/logger'
require 'eventmachinemom/util/baselogger'

require 'eventmachinemom/version'
require 'eventmachinemom/user'
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

    def initialize host, port, sync_port, log = false
      EventMachine.run do

        SyncServer.create host, sync_port
        Logger.log.debug "sync listening"

        EventMachine::WebSocket.run(:host => host, :port => port) do |ws|
          WebsocketServer.new ws, log
        end
        Logger.log.debug "websocket listening"

      end
    end

  end
end

