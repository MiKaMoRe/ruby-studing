# frozen_string_literal: true

require_relative 'company'
require_relative 'instanse_counter'
require_relative 'accessors'
require_relative 'validation'

##
# This is a rout
# He's require number
# Метод route_progress используется только для исравной работы других методов этого класса
class Train
  include InstanceCounter
  include Accessors
  include Company
  include Validation

  attr_reader :cars, :route, :speed, :number

  validate :number, :presence
  validate :number, :format, /(^[a-zа-я0-9]{3}$|^[a-zа-я0-9]{3}-[a-zа-я0-9]{2}$)/i

  @@instances = []

  def self.find(num)
    @@instances.find { |train| train.number == num }
  end

  def initialize(number)
    @number = number.to_s
    @cars = []
    @speed = 0
    @@instances.push(self)
    validate!
    register_instance
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

  def each_car(&block)
    case block.parameters.length
    when 1
      @cars.each { |car| block.call(car) }
    when 2
      @cars.each_with_index { |car, index| block.call(car, index) }
    end
  end

  protected

  def route_progress
    @route.stations.index(current_station)
  end
end
