class Logger

  def self.initialize
    class << self
      attr_accessor :log
    end
    self.log = Logger.new STDOUT
    self.log.level = Logger::DEBUG
  end

  initialize
end