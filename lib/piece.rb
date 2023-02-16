# frozen_string_literal: true

class Piece
  def initialize(type, value, moves, initial_position, actual_position = initial_position, special_move = [])
    attr_reader :type, :value
    attr_accessor :moves, :initial_position, :actual_position, :special_move

    @type = type
    @value = value
    @moves = moves
    @initial_position = initial_position
    @actual_position = actual_position
    @special_move = special_move # Pawns for example cannot eat straight, it has to be diagonally
  end
end
