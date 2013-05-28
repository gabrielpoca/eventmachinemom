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

    def push *items
      super *items
      #items.each { |msg| Session.create name: @name, text: msg }
    end

    def get_messages
      Session.where name: @name
    end

    def self.find_or_create name
      @instances.select {|channel| channel.name.eql?(name)}[0] ||= Channel.create(name)
    end

    def self.broadcast msg
      begin
        if msg[0][0].eql? "all"
          User.all.each do |user|
            user.send msg[1]
          end
        else
          msg[0].each do |name|
            Channel.find_or_create(name).push(msg[1])
          end
        end
      rescue Exception => e
        Channel.logger.error "Channel: #{e}"
      end
    end

    #def self.initialize_channels
    #Session.uniq.pluck(:name).each { |session| Channel.create session }
    #end

    #initialize_channels

  end
end
