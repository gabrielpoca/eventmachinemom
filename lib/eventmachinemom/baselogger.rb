require 'logger'

module BaseLogger
  def self.extended(base)
    class << base
      attr_accessor :logger
    end
    base.logger = Logger.new STDOUT
    #base.logger.level = Logger::WARN
    base.logger.level = Logger::DEBUG
  end
  def logger_level level
    @logger.level = level
  end
end
