require 'csv'

class Logger

  def self.initialize
    class << self
      attr_accessor :log
      attr_accessor :messages
    end
    self.messages = Array.new
    self.log = Logger.new STDOUT
    self.log.level = Logger::DEBUG
  end

  def self.log_message
    @messages.push Time.now
  end

  def self.dump_log_message file
    CSV.open("log/#{file}.csv", "wb") do |csv|
      @messages.each do |value|
        csv << [(value.to_f*1000).to_i]
      end
    end unless @messages.empty?
  end

  initialize
end