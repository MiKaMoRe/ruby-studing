# frozen_string_literal: true

# This is a class for create a station. He is require station name.
class Station
  attr_reader :name, :trains

  def initialize(name)
    @name = name
    @trains = []
  end

  def add_train(train)
    @trains << train
  end

  def trains_typeof(type)
    @trains.select { |train| train.type == type }
  end

  def remove_train(train)
    @trains.delete(train)
  end
end

# This is a class for create a train. He is require number, type of train and how much cars he has.
class Train
  attr_reader :type, :cars, :route, :speed

  def initialize(num, type, cars)
    @num = num
    @type = type
    @cars = cars
    @speed = 0
  end

  def route=(route)
    @route = route
    @route.start.add_train(self)
  end

  def stop
    @speed = 0
  end

  def add_car
    return @cars += 1 unless @speed.zero?
  end

  def remove_car
    return @cars -= 1 unless @speed.zero?
  end

  def current_station
    @route.stations.select { |station| station.trains.include?(self) }[0]
  end

  def route_progress
    @route.stations.index(current_station)
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
end

# This is a class for route. He is require beginning and end station.
class Route
  attr_reader :start

  def initialize(start, stop)
    @start = start
    @stop = stop
    @intermediate = []
  end

  def add_station(station)
    @intermediate << station
  end

  def remove_station(station)
    @intermediate.delete_at(station)
  end

  def stations
    [@start, @intermediate, @stop].flatten
  end
end
