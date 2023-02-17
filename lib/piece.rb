# frozen_string_literal: true

class Piece
  def initialize(type, color)
    attr_reader :type, :color

    @type = type
    @color = color
  end
end
