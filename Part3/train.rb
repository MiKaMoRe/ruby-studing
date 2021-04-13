# frozen_string_literal: true

##
# This is a rout
# He's require number
# Метод route_progress используется только для исравной работы других методов этого класса
class Train
  attr_reader :cars, :route, :speed, :number

  def initialize(number)
    @number = number
    @cars = []
    @speed = 0
  end

  def route=(route)
    @route = route
    @route.start.add_train(self)
  end

  def stop
    @speed = 0
  end

  def add_car(car)
    @cars << car if car.type == @type
  end

  def remove_car
    @cars.pop
  end

  def show_cars
    @cars.each_with_index { |car, index| puts "#{index}.  #{car}" }
  end

  def current_station
    @route.stations.select { |station| station.trains.include?(self) }[0]
  end

  def move_next
    return if route_progress == @route.stations.length - 1

    @route.stations[route_progress + 1].add_train(self)
    current_station.remove_train(self)
  end

  def move_prev
    return if route_progress.zero?

    route_progress = self.route_progress
    current_station.remove_train(self)
    @route.stations[route_progress - 1].add_train(self)
  end

  def next_station
    return if route_progress == @route.stations.length - 1

    @route.stations[route_progress + 1]
  end

  def prev_station
    return if route_progress.zero?

    @route.stations[route_progress - 1]
  end

  def passenger?
    instance_of? PassengerTrain
  end

  def cargo?
    instance_of? CargoTrain
  end

  protected

  def route_progress
    @route.stations.index(current_station)
  end
end
