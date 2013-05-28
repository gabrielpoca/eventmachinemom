require 'em-websocket'
require 'em-websocket-client'
require 'json'
require 'logger'
require 'pry'
require 'pry-debugger'


require 'eventmachinemom/version'
require 'eventmachinemom/user'
require 'eventmachinemom/baselogger'
require 'eventmachinemom/database'
require 'eventmachinemom/models/session'
require 'eventmachinemom/models/server'
require 'eventmachinemom/channel'
require 'eventmachinemom/sync_server'

module EventMachineMOM
  class Application
    extend BaseLogger

    def initialize host = '0.0.0.0', port = 8080, sync_port = 3000
      EventMachine.run do

        sync = SyncServer.new host, sync_port
        puts "Listing sync..."

        EventMachine::WebSocket.run(:host => host, :port => port) do |ws|
          user = User.create ws
          sid = Hash.new

          ws.onopen do
            Application.logger.debug "WebSocket connection open"
          end

          ws.onmessage do |msg|
            Application.logger.debug "Recieved message: #{msg}"
            msg = JSON.parse(msg)
            if msg[0][0] == "unsubscribe"
              channel = Channel.find_or_create(msg[1])
              unless sid[channel.name].nil?
                channel.unsubscribe sid[channel.name]
              end
            elsif msg[0][0] == "subscribe"
              channel = Channel.find_or_create(msg[1])
              sid[channel.name] = channel.subscribe { |msg| user.send msg }
            else # push to channel and send to other brokers
              Channel.broadcast msg
            end
          end

          ws.onclose do
            Application.logger.debug "Connection closed"
          end
        end
        puts "Listening client..."



      end
    end

  end
end

