class Logger

  def self.initialize
    class << base
      attr_accessor :log
    end
    base.log = Logger.new STDOUT
    base.log.level = Logger::DEBUG
  end

  initialize
end