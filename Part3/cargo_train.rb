# frozen_string_literal: true

require_relative 'train'

##
# This is a cargo train
# Inherited from train
class CargoTrain < Train
  attr_reader :type

  def initialize(number)
    super(number)
    @type = 'cargo'
  end
end
