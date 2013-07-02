require 'active_record'

module EventMachineMOM 
  class Session < ActiveRecord::Base
    attr_accessible :id, :name, :text, :sent, :mode

    def self.set_next_task name
      session = nil
      self.transaction do
        binding.pry
        session = self.where(name: name, sent: false).last
        session.sent = true
        sessin.save!
        binding.pry
      end
    end
  end
end
