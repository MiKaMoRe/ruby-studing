# frozen_string_literal: true

require_relative 'train'

##
# This is a cargo train
# Inherited from train
class CargoTrain < Train
  def add_car(car)
    return @car << car if car.instance_of? CargoCar
  end
end
