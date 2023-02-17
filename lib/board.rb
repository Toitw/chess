# frozen_string_literal: true

class Board
  def initialize
    attr_accessor :board

    @board = Array.new(8) { Array.new(8, 0) }
  end
end
