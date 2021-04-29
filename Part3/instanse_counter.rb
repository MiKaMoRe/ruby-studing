# frozen_string_literal: true

module InstanseCounter
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanseMethods
  end

  module ClassMethods
    attr_accessor :counter

    def instances
      @counter ||= 0
    end
  end

  module InstanseMethods
    protected

    def register_instance
      self.class.counter ||= 0
      self.class.counter += 1
    end
  end
end
