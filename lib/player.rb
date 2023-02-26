# frozen_string_literal: true

class Player
  attr_accessor :origin, :destination, :name, :color
  def initialize(name, color = nil)
    @name = name
    @color = color
    @origin = [] #This will choose the coordinate of the piece that current_player wants to move
    @destination = [] #This will choose the coordinate of the square that current_player wants to move the selected piece
  end
end
