# frozen_string_literal: true

##
# This is a rout
# He's require start and end station objects
class Route
  attr_reader :start, :stop

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
