module EventMachineMOM
  class Server < ActiveRecord::Base
    attr_accessible :id, :host, :active
    scope :active, where(active: true)
  end
end
