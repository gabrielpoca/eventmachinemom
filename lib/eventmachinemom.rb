require 'em-websocket'
require 'json'
require 'pry'
require 'pry-debugger'
require 'logger'
require 'sqlite3'

require 'eventmachinemom/version'
require 'eventmachinemom/user'
require 'eventmachinemom/channel'
require 'eventmachinemom/baselogger'
require 'eventmachinemom/database'
require 'eventmachinemom/session'

module EventMachineMOM
  class Application
    extend BaseLogger

    def initialize host = '0.0.0.0', port = 8080

      @channel = Channel.new

      EventMachine.run do
        @server = EventMachine::WebSocket.run(:host => host, :port => port) do |ws|
          user = User.create ws

          ws.onopen do
            Application.logger.debug "WebSocket connection open"
            user.assign_uid

            sid = @channel.subscribe do |msg| 
              user.send msg
            end

            ws.onclose do
              @channel.unsubscribe sid
            end
          end

          ws.onmessage do |msg|
            Application.logger.debug "#{user.uid}: Recieved message: #{msg}"
            JSON.parse(msg).each do |command|
              if command[0].eql? "sync"
                user.send ([["sync_begin", nil]]).to_json
                @channel.log.each { |msg| user.send msg }
                user.send ([["sync_end", nil]]).to_json
              elsif command[0].eql? "insert" || "delete" || "undo"
                @channel.push [command].to_json
              end
            end
          end

        end
      end
    end

  end
end

