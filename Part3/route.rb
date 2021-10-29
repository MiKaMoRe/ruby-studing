# frozen_string_literal: true

require_relative 'instanse_counter'
require_relative 'validation'

##
# This is a rout
# He's require start and end station objects
class Route
  include InstanceCounter
  include Validation

  attr_reader :start, :stop

  validate :start, :type, Station
  validate :stop, :type, Station

  def initialize(start, stop)
    @start = start
    @stop = stop
    @intermediate = []
    validate!
    register_instance
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

  protected

  def validate!
    raise 'Route can only contain an instance of Station class' if !(@start.is_a? Station) || !(@stop.is_a? Station)
  end
end
