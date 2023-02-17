# frozen_string_literal: true

require_relative "board"
require_relative "piece"
require_relative "player"

class Game
    def initialize
        @board = Board.new.board
    end
end
