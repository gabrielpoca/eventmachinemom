module EventMachineMOM
  class Server < ActiveRecord::Base
    attr_accessible :id, :host, :active
  end
end
