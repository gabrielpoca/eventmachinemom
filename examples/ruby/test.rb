require 'em-websocket'
require 'em-websocket-client'
require "json"

@hosts = [ 'ws://0.0.0.0:8080',
  'ws://0.0.0.0:8081',
  'ws://0.0.0.0:8082' ]

@clients = 100
@messages = 15000

@results = Hash.new

Signal.trap("TERM") do
  puts @results.inspect
  exit
end

Signal.trap("INT") do
  puts @results.inspect
  exit
end

EM.run do
  @hosts.collect do |host| 
    @clients.times do 
      connection = EventMachine::WebSocketClient.connect(host) 
      @results[host] = 0
      connection.callback do
        puts "connection established to #{host}"
        @messages.times { |i| connection.send_msg [["all"], "#{i} message"].to_json }
      end
      connection.stream do |msg|
        @results[host] += 1
      end
    end
  end
end
