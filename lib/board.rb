# frozen_string_literal: true

require_relative "chessInitialPositions"

class Board
  include ChessInitialPositions

  attr_accessor :board

  def initialize

    @board = Array.new(8) { Array.new(8, 0) }
  end
end
