# Module Base has essencial class methods
# FEATURES:
# 1.  Adds instances variable to class to store all class objects.
#     Class should be created with method 'create'
# 2.  Adds method 'all' to return the objects array.
module Base
  def self.extended(base)
    class << base
      attr_accessor :instances
    end
    base.instances = Array.new
  end
  def create handshake
    @instances.push self.new handshake
  end
  def all
    @instances
  end
end


