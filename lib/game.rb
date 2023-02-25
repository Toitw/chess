# frozen_string_literal: true

require_relative "board"
require_relative "piece"
require_relative "player"
require_relative "visual"

class Game
    attr_reader :board
    def initialize
        @board = Board.new
    end


end
