require 'eventmachinemom/base'
require 'eventmachinemom/baselogger'

module EventMachineMOM
  class User 
    extend Base
    extend BaseLogger

    attr_accessor :websocket
    attr_accessor :uid

    def initialize websocket
      @websocket = websocket
      @uid = self.class.get_id
    end

    def send data
      @websocket.send data  
    end

  end
end
