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
        if @board.board[x+1][y+1].nil?
          x += 1
          y +=1
          moves << [x, y]
        else
          if @board.board[x+1][y+1].color != @current_player.color
            x += 1
            y +=1
            moves << [x, y]
          end
          break
        end
      end
    
      # Lower Right Diagonal
      x, y = pos
      until x >= 7 || y <= 0
        if @board.board[x+1][y-1].nil?
          x += 1
          y -= 1
          moves << [x, y]
        else
          if @board.board[x+1][y-1].color != @current_player.color
            x += 1
            y -= 1
            moves << [x, y]
          end
          break
        end
      end
    
      # Lower Left Diagonal
      x, y = pos
      until x <= 0 || y <= 0
        if @board.board[x-1][y-1].nil?
          x -= 1
          y -= 1
          moves << [x, y]
        else
          if @board.board[x-1][y-1].color != @current_player.color
            x -= 1
            y -= 1
            moves << [x, y]
          end
          break
        end
      end
    
      # Upper Left Diagonal
      x, y = pos
      until x <= 0 || y >= 7
        if @board.board[x-1][y+1].nil?
          x -= 1
          y += 1
          moves << [x, y]
        else
          if @board.board[x-1][y+1].color != @current_player.color
            x -= 1
            y += 1
            moves << [x, y]
          end
          break
        end
      end
    
      moves
    end    
  
    def rook_moves(pos)
      moves = []
    
      # Left
      x, y = pos
      until x <= 0
        if @board.board[x-1][y].nil?
          x -= 1
          moves << [x, y]
        else
          if @board.board[x-1][y].color != @current_player.color
            x -= 1
            moves << [x, y]
          end
          break
        end
      end
    
      # Right
      x, y = pos
      until x >= 7
        if @board.board[x+1][y].nil?
          x += 1
          moves << [x, y]
        else
          if @board.board[x+1][y].color != @current_player.color
            x += 1
            moves << [x, y]
          end
          break
        end
      end
    
      # Up
      x, y = pos
      until y >= 7
        if @board.board[x][y+1].nil?
          y += 1
          moves << [x, y]
        else
          if @board.board[x][y+1].color != @current_player.color
            y += 1
            moves << [x, y]
          end
          break
        end
      end
    
      # Down
      x, y = pos
      until y <= 0
        if @board.board[x][y-1].nil?
          y -= 1
          moves << [x, y]
        else
          if @board.board[x][y-1].color != @current_player.color
            y -= 1
            moves << [x, y]
          end
          break
        end
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
      
      moves.select { |x, y| x.between?(0, 7) && y.between?(0, 7) }
    end
  
    def pawn_moves(pos, color)
      moves = []
  
      x, y = pos
      
      if color == :white
        moves << [x, y + 1]
        moves << [x, y + 2] if y == 1 && @board.board[x][y + 1].nil? 
        if x <= 6 && x >=1
          moves << [x + 1, y + 1] if !@board.board[x + 1][y + 1].nil? 
          moves << [x - 1, y + 1] if !@board.board[x - 1][y + 1].nil? 
        end
      else
        moves << [x, y - 1]
        moves << [x, y - 2] if y == 6 && @board.board[x][y - 1].nil?
        if x <= 6 && x >=1
          moves << [x + 1, y - 1] if !@board.board[x + 1][y - 1].nil?
          moves << [x - 1, y - 1] if !@board.board[x - 1][y - 1].nil?
        end
      end
  
      moves
    end
  end
  