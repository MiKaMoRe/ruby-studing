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
        case validate['type']
        when :format
          eval("raise 'Incorrect format' if @#{validate['name']} !~ validate['param']")
        when :presence
          eval("raise 'Value cant be empty' if @#{validate['name']}.nil?")
        when :type
          eval("raise 'Different class' if @#{validate['name']}.class != validate['param']")
        else
          raise 'Undefined type for validate'
        end
      end
    end

    def valid?
      validate!
      true
    rescue StandardError
      false
    end
  end
end
