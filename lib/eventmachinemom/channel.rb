require 'eventmachinemom/base'
require 'eventmachinemom/models/session'

module EventMachineMOM
  class Channel < EM::Channel
    extend Base
    extend BaseLogger

    attr_accessor :name
    attr_accessor :mode

    def initialize params
      super()
      @name = params[:name]
      @mode = params[:mode] ||= "normal"
    end

    def get_messages
      Session.where name: @name
    end

    def push *items
      #if @mode == "task"
        #items = items.dup
        #EM.schedule { items.each { |i| @subs.values.sample.call i } }
      #else
        super *items
        items.each { |msg| Session.create name: @name, text: msg, mode: @mode } if !@mode.eql?("normal")
      #end
    end

    def self.find_or_create name, mode = false
      @instances.select {|channel| channel.name.eql?(name)}[0] ||= Channel.create({name: name, mode: mode})
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
      Session.uniq.pluck(:name).each do |session| 
        mode = Session.where(name: session).last.mode
        Channel.create name: session, mode: mode
      end
    end

    initialize_channels
  end
end
