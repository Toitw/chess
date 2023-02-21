# frozen_string_literal: true

require_relative "chessInitialPositions"
require_relative "piece"

class Board
  include ChessInitialPositions

  attr_accessor :board

  def initialize

    @board = Array.new(8) { Array.new(8, nil) }
  end

  def set_up_pieces
    INITIAL_POSITIONS.each do |type, positions|
      positions.each do |color, coordinate|
        coordinate.each do |column, row|
          @board[column][row] = Piece.new(type, color)
        end
      end
    end
  end
end
