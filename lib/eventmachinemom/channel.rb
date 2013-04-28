require_relative 'base'

module EventMachineMOM
  class Channel
    extend Base

    attr_accessor :users
    
    def initialize
      @users = Array.new
    end

    def add_user user
      @users.push user
    end

    def contains? user
      @users.include? user
    end

    def broadcast data
      @users.each {|user| user.send data}
    end

  end
end
