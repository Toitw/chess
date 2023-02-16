# frozen_string_literal: true

class Player
  def initialize(name)
    attr_reader :name
    attr_accessor :origin, :destination

    @name = name
    @origin = [] #This will choose the coordinate of the piece that current_player wants to move
    @destination = [] #This will choose the coordinate of the square that current_player wants to move the selected piece
  end
end
