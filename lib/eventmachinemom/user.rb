require 'eventmachinemom/base'

module EventMachineMOM
  class User
    extend Base
    extend BaseLogger

    attr_accessor :websocket
    attr_accessor :uid

    def initialize websocket
      @websocket = websocket
      @uid = Database.get_next_user_id
    end

    def send data
      @websocket.send data
    end

  end
end
