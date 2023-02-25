module ChessInitialPositions
  INITIAL_POSITIONS = {
    rook: {
      white: [[0, 0], [7, 0]], #whites are the blacks
      black: [[0, 7], [7, 7]]
    },
    knight: {
      white: [[1, 0], [6, 0]],
      black: [[1, 7], [6, 7]]
    },
    bishop: {
      white: [[2, 0], [5, 0]],
      black: [[2, 7], [5, 7]]
    },
    queen: {
      white: [[3, 0]],
      black: [[3, 7]]
    },
    king: {
      white: [[4, 0]],
      black: [[4, 7]]
    },
    pawn: {
      white: [
        [0, 1], [1, 1], [2, 1], [3, 1],
        [4, 1], [5, 1], [6, 1], [7, 1]
      ],
      black: [
        [0, 6], [1, 6], [2, 6], [3, 6],
        [4, 6], [5, 6], [6, 6], [7, 6]
      ]
    }
  }
end




  