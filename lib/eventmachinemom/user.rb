require_relative 'base'
require_relative 'baselogger'

module EventMachineMOM
  class User
    extend Base
    extend BaseLogger

    attr_accessor :handshake

    def initialize handshake
      @handshake = handshake
      User.logger.debug handshake
    end

    def send data
      User.logger.debug data  
    end

    def ==(other)
      return other.handshake.eql? @handshake
    end
    
  end
end
