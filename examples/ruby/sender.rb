require 'em-websocket'
require 'em-websocket-client'
require 'json'
require 'pry'
require 'pry-debugger'
require 'csv'

# run with argument 1, 2 or 3.
@host = ['ws://192.168.1.10:8080', 'ws://0.0.0.0:8081', 'ws://0.0.0.0:8082'][ARGV[0].to_i - 1]
@messages = 1000

@logs = !ARGV[1].nil?
@label = ARGV[1]

@sends = Hash.new

Signal.trap("INT") do
  if @logs
    value = 0
    @sends.values.each {|v| value += (v.to_f*1000).to_i}
    value = value/@sends.size
    CSV.open("sends.csv", "a") do |csv|
      csv << [@label, value]
    end
  end
  exit
end

puts "connecting to #{@host}"
EM.run do
  connection = EventMachine::WebSocketClient.connect(@host)
  connection.callback do
    puts "connection established to #{@host}. Sending..."
    @messages.times do |i|
      @sends[i.to_s] = Time.now
      connection.send_msg [["all"], i].to_json
    end
  end
end
