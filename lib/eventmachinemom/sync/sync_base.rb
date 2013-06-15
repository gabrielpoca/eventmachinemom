module SyncBase
  def self.extended(base)
    class << base
      attr_accessor :server
    end
  end

  def create host, port
    @server = SyncServer.new host, port
  end

  def broadcast message
    @server.broadcast message
  end
end
