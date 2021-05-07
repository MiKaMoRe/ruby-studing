# frozen_string_literal: true

module Validation
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    attr_accessor :validates

    def validate(name, type, param = nil)
      @validates ||= []
      @validates << { 'name' => name, 'type' => type, 'param' => param }
    end
  end

  module InstanceMethods
    protected

    def validate!
      return if self.class.validates.nil?

      self.class.validates.each do |validate|
        name = instance_variable_get("@#{validate['name']}".to_sym)
        param = instance_variable_get("@#{validate['param']}".to_sym)
        type = validate['type']
        case type
        when :format
          validate_format(name, param)
        when :presence
          validate_presence(name)
        when :type
          validate_type(name)
        else
          raise 'Undefined type for validate'
        end
      end
    end
    def validate_format(name, param)
      raise 'Incorrect format' if name !~ param
    end
    def validate_presence(name)
      raise 'Value cant be empty' if name.nil?
    end
    def validate_type(name, param)
      raise 'Different class' if name.class != param
    end

    def valid?
      validate!
      true
    rescue StandardError
      false
    end
  end
end
