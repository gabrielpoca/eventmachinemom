require 'eventmachinemom/base'
require 'eventmachinemom/baselogger'
require 'eventmachinemom/session'

module EventMachineMOM 
  class Channel < EM::Channel
    extend Base
    extend BaseLogger

    attr_accessor :name
    
    def initialize name
      super()
      @name = name
    end

    #def push *items
      #super *items
      #items.each { |msg| Session.create name: @name, text: msg }
    #end

    def get_messages
      Session.where name: @name
    end

    def self.find_or_create name
      @instances.select {|channel| channel.name.eql?(name)}[0] ||= Channel.create(name)
    end

  end
end
