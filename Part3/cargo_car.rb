# frozen_string_literal: true

require_relative 'car'

##
# This is a cargo car
# Inherited from car
class CargoCar < Car
  attr_reader :type

  def initialize
    @type = 'cargo'
  end
end
