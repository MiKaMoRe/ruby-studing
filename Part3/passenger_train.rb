# frozen_string_literal: true

require_relative 'train'

##
# This is a passenger train
# Inherited from train
class PassengerTrain < Train
  attr_reader :type

  def initialize(number)
    super(number)
    @type = 'passenger'
  end
end
