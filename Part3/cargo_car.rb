# frozen_string_literal: true

require_relative 'car'

##
# This is a cargo car
# Inherited from car
class CargoCar < Car
  attr_reader :type

  def initialize(capacity)
    super(capacity)
    @type = 'cargo'
  end

  def fill_tank(lvl)
    @fill ||= 0
    return @fill += lvl if @capacity >= @fill + lvl
  end
end
