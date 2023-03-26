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
    puts "\n To open the help menu (SAVE, LOAD, RESTART) write down 'HELP'"
    puts "  ---------------------------------"
    @board.transpose.reverse.each_with_index do |column, y|
      print "#{8-y} |"
  
      column.each_with_index do |piece, x|
        background_color = (x + y).even? ? "\033[48;5;18m" : "\033[48;5;22m" # Dark blue and dark green background colors
        reset_color = "\033[0m"
        
        if piece.nil?
          print "#{background_color}   #{reset_color}"
        else
          color = piece.color == :white ? :white : :black
          symbol = ChessUnicodePieces::UNICODE_PIECES[piece.type][color]
          print "#{background_color} #{symbol} #{reset_color}"
        end
        print "|"
      end
      puts "\n  ---------------------------------"
    end
    puts "    a   b   c   d   e   f   g   h "
  end  
end
