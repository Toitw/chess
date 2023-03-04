module ChessPieceMoves
    KNIGHT_MOVES = [
      [-2, 1],
      [-1, 2],
      [1, 2],
      [2, 1],
      [2, -1],
      [1, -2],
      [-1, -2],
      [-2, -1]
    ]
  
    def bishop_moves(pos)
      moves = []
  
      # Upper Right Diagonal
      x, y = pos
      until x >= 7 || y >= 7
        x += 1
        y += 1
        moves << [x, y]
      end
  
      # Lower Right Diagonal
      x, y = pos
      until x >= 7 || y <= 0
        x += 1
        y -= 1
        moves << [x, y]
      end
  
      # Lower Left Diagonal
      x, y = pos
      until x <= 0 || y <= 0
        x -= 1
        y -= 1
        moves << [x, y]
      end
  
      # Upper Left Diagonal
      x, y = pos
      until x <= 0 || y >= 7
        x -= 1
        y += 1
        moves << [x, y]
      end
  
      moves
    end
  
    def rook_moves(pos)
      moves = []
  
      # Right
      x, y = pos
      until x >= 7
        x += 1
        moves << [x, y]
      end
  
      # Up
      x, y = pos
      until y >= 7
        y += 1
        moves << [x, y]
      end
  
      # Left
      x, y = pos
      until x <= 0
        x -= 1
        moves << [x, y]
      end
  
      # Down
      x, y = pos
      until y <= 0
        y -= 1
        moves << [x, y]
      end
  
      moves
    end
  
    def queen_moves(pos)
      bishop_moves(pos) + rook_moves(pos)
    end
  
    def king_moves(pos)
      moves = []
  
      x, y = pos
  
      moves << [x + 1, y]
      moves << [x + 1, y + 1]
      moves << [x, y + 1]
      moves << [x - 1, y + 1]
      moves << [x - 1, y]
      moves << [x - 1, y - 1]
      moves << [x, y - 1]
      moves << [x + 1, y - 1]
  
      moves
    end
  
    def pawn_moves(pos, color)
      moves = []
  
      x, y = pos
  
      if color == :white
        moves << [x, y + 1]
        moves << [x, y + 2] if y == 1
      else
        moves << [x, y - 1]
        moves << [x, y - 2] if y == 6
      end
  
      moves
    end
  end
  