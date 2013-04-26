require 'em-websocket'
require "eventmachinemom/version"
require 'eventmachinemom/user'

module EventMachineMOM
  class Application

    def initialize
      EM.run {
        @server = EM::WebSocket.run(:host => "0.0.0.0", :port => 8080) do |ws|
        ws.onopen { |handshake|
          puts "WebSocket connection open"
          ws.send "Hello Client, you connected to #{handshake.path}"
        }

        ws.onclose { puts "Connection closed" }

        ws.onmessage { |msg|
          puts "Recieved message: #{msg}"
          ws.send "Pong: #{msg}"
        }
        end
      }
    end

    def stop
      @server.stop
    end

  end
end

