# frozen_string_literal: true

require_relative 'car'

##
# This is a passenger car
# Inherited from car
class PassengerCar < Car
  attr_reader :type

  def initialize
    @type = 'passenger'
  end
end
