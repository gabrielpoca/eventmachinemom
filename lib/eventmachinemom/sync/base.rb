
module SyncBase
  def self.extended(base)
    class << base
      attr_accessor :server
    end
  end

  def create host, port
    @server = self.new host, port
  end

  def broadcast message
    @server.broadcast message
  end

  def update_servers
    @server.update_servers
  end
end
