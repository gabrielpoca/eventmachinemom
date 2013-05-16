require 'eventmachinemom/base'
require 'eventmachinemom/baselogger'
require 'eventmachinemom/session'

module EventMachineMOM 
  class Channel < EM::Channel
    extend Base
    extend BaseLogger

    attr_accessor :users
    attr_accessor :name
    
    def initialize name
      super()
      @users = Array.new
      @name = name
    end

    def push *items
      super *items
      items.each { |msg| Session.create name: @name, text: msg }
    end

    def add_user user
      @users.push user
    end

    def contains? user
      @users.include? user
    end

    def get_messages
      Session.where name: @name
    end

    def self.find_or_create name
      @instances.select {|channel| channel.name.eql?(name)}[0] ||= Channel.new(name)
    end

  end
end
