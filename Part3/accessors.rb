# frozen_string_literal: true

module Accessors
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def attr_accessor_with_history(*name)
      name.each do |var_name|
        variable = "@#{var_name}".to_sym
        define_method(var_name) { instance_variable_get(variable) }
        define_method("#{var_name}_history".to_sym) { instance_variable_get("#{variable}_history".to_sym) }
        define_method("#{var_name}=".to_sym) do |value|
          eval("#{variable}_history ||= []")
          eval("#{variable}_history << value")
          instance_variable_set(variable, value)
        end
      end
    end

    def strong_attr_accessor(*name)
      name.each do |var_name|
        variable = "@#{var_name}".to_sym
        define_method(var_name) { instance_variable_get(variable) }
        define_method("#{var_name}_set".to_sym) do |value, attr_class|
          if value.instance_of?(attr_class)
            instance_variable_set(variable, value)
          else
            raise 'Different class'
          end
        end
      end
    end
  end
end
