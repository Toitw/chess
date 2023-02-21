# frozen_string_literal: true

class Piece
  attr_accessor :type, :color
  
  def initialize(type, color)
    @type = type
    @color = color
  end
end
