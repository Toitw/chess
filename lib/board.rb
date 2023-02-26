# frozen_string_literal: true

require_relative "chessInitialPositions"
require_relative "piece"
require_relative "visual"

class Board
  include ChessInitialPositions

  attr_accessor :board

  def initialize
    @board = Array.new(8) { Array.new(8, nil) }
    set_up_pieces
    display_board
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
    puts "  ---------------------------------"
    @board.transpose.reverse.each_with_index do |column, y|
      print "#{8-y} |"

      column.each do |piece|
        if piece.nil?
          print "   "
        else
          color = piece.color == :white ? :white : :black
          symbol = ChessUnicodePieces::UNICODE_PIECES[piece.type][color]
          print " #{symbol} "
        end
        print "|"
      end
      puts "\n  ---------------------------------"
    end
    puts "    a   b   c   d   e   f   g   h "
  end
end
