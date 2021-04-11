# frozen_string_literal: true

require_relative 'train'

##
# This is a passenger train
# Inherited from train
class PassengerTrain < Train
  def add_car(car)
    return @cars << car if car.instance_of? PassengerCar
  end
end
