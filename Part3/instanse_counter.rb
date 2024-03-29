# frozen_string_literal: true

module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    attr_accessor :counter

    def instances
      @counter ||= 0
    end
  end

  module InstanceMethods
    protected

    def register_instance
      self.class.counter ||= 0
      self.class.counter += 1
    end
  end
end
