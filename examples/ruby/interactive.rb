require 'em-websocket'
require 'em-websocket-client'
require 'json'
require 'pry'
require 'pry-debugger'
require 'readline'

# run with argument 1, 2 or 3.
@host = ['ws://0.0.0.0:8080', 'ws://0.0.0.0:8081', 'ws://0.0.0.0:8082'][ARGV[0].to_i - 1]

puts "connecting to #{@host}"
EM.run do
  connection = EventMachine::WebSocketClient.connect(@host)
  connection.stream do |msg|
    puts "received: #{msg}"
  end
  connection.callback do
    puts "connection established to #{@host}."
    Thread.new do
      while message = Readline.readline("> ", true) do
        puts "sending: #{message} \n"
        connection.send_msg message
      end
    end
  end
end
