# frozen_string_literal: true

##
# This is a car
class Car
  attr_reader :capacity

  def initialize(capacity)
    @capacity = capacity
  end

  def filling_lvl
    @fill ||= 0
  end

  def free_lvl
    @fill ||= 0
    @capacity - @fill
  end

  protected

  attr_writer :capacity, :fill
end
