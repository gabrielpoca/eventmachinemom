require 'eventmachinemom/base'
require 'eventmachinemom/baselogger'

module EventMachineMOM 
  class Channel < EM::Channel
    extend Base
    extend BaseLogger

    attr_accessor :users
    attr_accessor :log
    
    def initialize
      super
      @users = Array.new
      @log = Array.new
    end

    def push *items
      super *items
      @log.concat items
    end

    def add_user user
      @users.push user
    end

    def contains? user
      @users.include? user
    end

  end
end
