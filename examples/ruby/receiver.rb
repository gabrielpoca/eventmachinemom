require 'em-websocket'
require 'em-websocket-client'
require 'json'
require 'pry'
require 'pry-debugger'
require 'csv'
require 'yaml'

# run with argument 1, 2 or 3.
@host = ['ws://0.0.0.0:8080', 'ws://0.0.0.0:8081', 'ws://0.0.0.0:8082'][ARGV[0].to_i - 1]
@receives = Hash.new
@messages = 1000

@logs = !ARGV[1].nil?
@label = ARGV[1]

Signal.trap("INT") do
  if @logs
    raise "Lost messages, got #{@receives.size} of #{@messages}" if @receives.size != @messages
    raise 'No sends.yml file found' unless File.exists?('sends.yml')

    sends = YAML::load( File.read('sends.yml') )
    5.times {|x| sends.delete(x); @receives.delete(x)}

    times = Array.new
    @receives.each_key do |k| 
      times.push (@receives[k].to_f*1000).to_i - (sends[k].to_f*1000).to_i
    end
    print "latency: #{times.inject(:+) / times.size}"
    #value = 0
    #@receives.values.each {|v| value += (v.to_f*1000).to_i}
    #value = value/@receives.size

    #CSV.open("receives.csv", "a") do |csv|
      #csv << [@label, value]
    #end

    File.delete 'sends.yml'
  end
  exit
end

puts "connecting to #{@host}"
EM.run do
  connection = EventMachine::WebSocketClient.connect(@host)
  connection.callback do
    puts "connection established to #{@host}. Receiving..."
  end
  connection.stream do |msg|
    @receives[JSON.parse(msg)[1]] = Time.now
  end
end
