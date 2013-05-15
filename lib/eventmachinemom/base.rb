# Module Base has essencial class methods
# FEATURES:
# 1.  Adds instances variable to class to store all class objects.
#     Class should be created with method 'create'
# 2.  Adds method 'all' to return the objects array.
module Base
  def self.extended(base)
    class << base
      attr_accessor :instances
      attr_accessor :id
    end
    base.instances = Array.new
    base.id = 0
  end

  def create websocket
    user = self.new websocket
    @instances.push user
    user
  end

  def all
    @instances
  end

  def get_id
    @id += 1
  end
end


