require_relative 'base'

module EventMachineMOM
  class User
    extend Base
    attr_accessor :handshake

    def initialize handshake
      @handshake = handshake
    end

    def ==(other)
      return other.handshake.eql? @handshake
    end
  end
end
