require 'base'
require 'baselogger'

module EventMachineMOM 
  class Channel < EM::Channel
    extend Base
    extend BaseLogger

    attr_accessor :users
    
    def initialize
      super
      @users = Array.new
    end

    def add_user user
      @users.push user
    end

    def contains? user
      @users.include? user
    end

  end
end
