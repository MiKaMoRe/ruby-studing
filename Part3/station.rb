# frozen_string_literal: true

##
# This is a station
# He's require name
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
