# frozen_string_literal: true

require_relative 'instanse_counter'
require_relative 'validation'

##
# This is a station
# He's require name
class Station
  include InstanceCounter
  include Validation

  attr_reader :name, :trains

  validate :name, :presence
  validate :name, :format, /^[a-zа-я ]+$/i

  @@instances = []

  def self.all
    @@instances
  end

  def initialize(name)
    @name = name
    @trains = []
    @@instances.push(self)
    validate!
    register_instance
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

  def each_train(&block)
    case block.parameters.length
    when 1
      @trains.each { |trains| block.call(trains) }
    when 2
      @trains.each_with_index { |trains, index| block.call(trains, index) }
    end
  end
end
