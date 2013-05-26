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
      EventMachine.run do
        EventMachine::WebSocket.run(:host => host, :port => port) do |ws|
          user = User.create ws
          channel = nil

          ws.onopen do
            Application.logger.debug "WebSocket connection open"
            user.assign_uid
          end

          ws.onmessage do |msg|
            Application.logger.debug "#{user.uid}: Recieved message: #{msg}"
            JSON.parse(msg).each do |command|

              if command[0].eql? "sync"
                user.send ([["sync_begin", nil]]).to_json
                messages = channel.get_messages
                messages.each { |msg| user.send msg.text } unless messages.nil?
                user.send ([["sync_end", nil]]).to_json

              elsif ["insert", "delete", "undo"].include? command[0]
                channel.push [command].to_json

              elsif command[0].eql? "join_session"
                channel = Channel.find_or_create command[1][0]
                sid = channel.subscribe {|msg| user.send msg }

                ws.onclose do
                  Application.logger.info "Closed user #{user.uid}"
                  channel.unsubscribe sid
                end

              elsif command[0].eql? "list"
                user.send Channel.all.to_json

              end
            end
          end
          
        end
        puts "Listening..."
      end

    end

  end
end

