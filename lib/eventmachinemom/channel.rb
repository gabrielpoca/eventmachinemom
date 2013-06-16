require 'eventmachinemom/base'
require 'eventmachinemom/models/session'

module EventMachineMOM
  class Channel < EM::Channel
    extend Base
    extend BaseLogger

    attr_accessor :name
    attr_accessor :persistent

    def initialize params
      super()
      @name = params[:name]
      @persistent = params[:persistent] ||= false
    end

    def get_messages
      Session.where name: @name
    end

    def push *items
      super *items
      items.each { |msg| Session.create name: @name, text: msg } if @persistent
    end

    def self.find_or_create name, persistent = false
      @instances.select {|channel| channel.name.eql?(name)}[0] ||= Channel.create({name: name, persistent: persistent})
    end

    def self.broadcast msg
      begin
        msg[0].each do |name|
          Channel.find_or_create(name).push("[[\"#{name}\"],\"#{msg[1]}\"]")
        end
      rescue Exception => e
        Channel.logger.error "Channel: #{e}"
      end
    end

    def self.exists? name
      @instances.each do |channel|
        return true if channel.name.eql? name
      end
      false
    end

    def self.initialize_channels
      Session.uniq.pluck(:name).each { |session| Channel.create name: session, persistent: true }
    end

    initialize_channels

  end
end
