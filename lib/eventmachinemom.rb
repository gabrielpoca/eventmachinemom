require 'em-websocket'
require 'json'
require 'pry'
require 'pry-debugger'
require 'logger'
require "eventmachinemom/version"
require 'eventmachinemom/user'
require 'eventmachinemom/channel'
require 'eventmachinemom/baselogger'

module EventMachineMOM
  class Application
    extend BaseLogger

    def initialize
      @channel = EM::Channel.new

      EventMachine.run do
        @server = EventMachine::WebSocket.run(:host => "0.0.0.0", :port => 8080) do |ws|
          ws.onopen do |handshake|
            User.create handshake
            Application.logger.debug "WebSocket connection open"
            ws.send ([["assign_uid", ["1"]]]).to_json
          end

          ws.onclose do
            Application.logger.debug "Connection closed"
          end

          ws.onmessage do |msg|
            Application.logger.debug "Recieved message: #{msg}"
            JSON.parse(msg).each do |command|
              if command[0].eql? "sync"
                ws.send ([["sync_begin", nil]]).to_json
                ws.send ([["sync_end", nil]]).to_json
              elsif command[0].eql? "insert" || "delete" || "undo"

              end
            end
          end
        end
      end
    end

  end
end

