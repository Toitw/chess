# frozen_string_literal: true

class Player
  def initialize(name = nil, color = nil)
    attr_reader :name, :color
    attr_accessor :origin, :destination

    @name = name
    @color = color
    @origin = [] #This will choose the coordinate of the piece that current_player wants to move
    @destination = [] #This will choose the coordinate of the square that current_player wants to move the selected piece
  end
end
