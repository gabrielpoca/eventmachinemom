module Base
  def self.extended(base)
    class << base
      attr_accessor :instances
    end
    base.instances = Array.new
  end

  def create object
    instance = self.new object
    @instances.push instance
    instance
  end

  def all
    @instances
  end

end


