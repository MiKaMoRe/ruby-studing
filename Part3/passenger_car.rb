# frozen_string_literal: true

require_relative 'car'

##
# This is a passenger car
# Inherited from car
class PassengerCar < Car
  attr_reader :type

  def initialize(capacity)
    super(capacity)
    @type = 'passenger'
  end

  def new_passenger
    @fill ||= 0
    @fill += 1
  end
end
