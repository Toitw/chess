module ChessInitialPositions
    INITIAL_POSITIONS = {
      rook:   { white: [[0, 0], [7, 0]], black: [[0, 7], [7, 7]] },
      knight: { white: [[0, 1], [7, 1]], black: [[0, 6], [7, 6]] },
      bishop: { white: [[0, 2], [7, 2]], black: [[0, 5], [7, 5]] },
      queen:  { white: [[0, 3]], black: [[7, 3]] },
      king:   { white: [[0, 4]], black: [[7, 4]] },
      pawn:   { white: (0..7).map { |i| [i, 1] }, black: (0..7).map { |i| [i, 6] } }
    }
end
  