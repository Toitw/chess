# frozen_string_literal: true

class Board
  def initialize
    attr_accessor :board

    @board = [1, 2, 3, 4, 5, 6, 7, 8].repeated_permutation(2).to_a
  end
end
