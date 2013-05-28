require 'active_record'

module EventMachineMOM 
  class Session < ActiveRecord::Base
    attr_accessible :id, :name, :text
  end
end
