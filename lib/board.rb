# frozen_string_literal: true

require_relative "chessInitialPositions"
require_relative "piece"
require_relative "visual"

class Board
  include ChessInitialPositions
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

  def display_board
    puts "    0   1   2   3   4   5   6   7 "
    puts "  ---------------------------------"
    @board.each_with_index do |row, y|
      print "#{y} |"

      row.each_with_index do |piece, x|
        if piece.nil?
          print "   "
        else
          color = piece.color == :white ? :white : :black
          symbol = UNICODE_PIECES[piece.type][color]
          print " #{symbol} "
        end
        print "|"
      end
      puts "\n  ---------------------------------"
    end
  end
end
