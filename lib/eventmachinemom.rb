require 'em-websocket'
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
      @thread = Thread.new do
        EventMachine.run do
          @server = EventMachine::WebSocket.run(:host => "0.0.0.0", :port => 8080) do |ws|
            ws.onopen do |handshake|
              User.create handshake
              Application.logger.debug "WebSocket connection open"
              ws.send "Hello Client, you connected to #{handshake.path}"
            end

            ws.onclose do
              Application.logger.debug "Connection closed"
            end

            ws.onmessage do |msg|
              Application.logger.debug "Recieved message: #{msg}"
              ws.send "Pong: #{msg}"
            end
          end
        end
      end
    end

    def stop
      @server.stop
      @thrad.kill
    end

  end
end

