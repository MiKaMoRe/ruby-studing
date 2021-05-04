# frozen_string_literal: true

require_relative 'instanse_counter'

##
# This is a station
# He's require name
class Station
  include InstanseCounter

  attr_reader :name, :trains

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

  protected

  def validate!
    raise 'Station name cant be nil' if @name.nil?
    raise 'Station name can contain only any word characters and whitespaces' if @name !~ /[a-zа-я ]/i
  end
end
