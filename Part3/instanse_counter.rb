module InstanseCounter
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanseMethods
  end

  module ClassMethods
    def instances
      self.counter
    end
  end
  module InstanseMethods
    protected
    attr_accessor :counter

    def register_instance
      self.counter += 1
    end
  end
end