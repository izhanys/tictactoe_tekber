/// Tic Tac Toe Game Logic
/// Handles board state, win detection, and move validation

class GameLogic {
  /// 3x3 board represented as List<List<String>>
  /// Empty = '', Player = 'X', AI = 'O'
  late List<List<String>> board;

  /// Current player turn ('X' or 'O')
  String currentPlayer = 'X';

  /// Winner of the game (null if no winner yet)
  String? winner;

  /// Whether the game is over
  bool isGameOver = false;

  /// Initialize/Reset the board
  GameLogic() {
    initializeBoard();
  }

  /// Initialize empty 3x3 board
  void initializeBoard() {
    board = List.generate(3, (_) => List.generate(3, (_) => ''));
    currentPlayer = 'X';
    winner = null;
    isGameOver = false;
  }

  /// Reset the game
  void reset() {
    initializeBoard();
  }

  /// Check if a move is valid
  bool isValidMove(int row, int col) {
    if (row < 0 || row > 2 || col < 0 || col > 2) return false;
    if (isGameOver) return false;
    return board[row][col].isEmpty;
  }

  /// Make a move on the board
  /// Returns true if move was successful
  bool makeMove(int row, int col, String player) {
    if (!isValidMove(row, col)) return false;

    board[row][col] = player;

    // Check for winner after move
    final gameWinner = checkWinner();
    if (gameWinner != null) {
      winner = gameWinner;
      isGameOver = true;
    } else if (isBoardFull()) {
      isGameOver = true;
    }

    // Switch player
    currentPlayer = currentPlayer == 'X' ? 'O' : 'X';

    return true;
  }

  /// Check if there's a winner
  /// Returns 'X', 'O', or null
  String? checkWinner() {
    // Check rows
    for (int i = 0; i < 3; i++) {
      if (board[i][0].isNotEmpty &&
          board[i][0] == board[i][1] &&
          board[i][1] == board[i][2]) {
        return board[i][0];
      }
    }

    // Check columns
    for (int i = 0; i < 3; i++) {
      if (board[0][i].isNotEmpty &&
          board[0][i] == board[1][i] &&
          board[1][i] == board[2][i]) {
        return board[0][i];
      }
    }

    // Check diagonals
    if (board[0][0].isNotEmpty &&
        board[0][0] == board[1][1] &&
        board[1][1] == board[2][2]) {
      return board[0][0];
    }

    if (board[0][2].isNotEmpty &&
        board[0][2] == board[1][1] &&
        board[1][1] == board[2][0]) {
      return board[0][2];
    }

    return null;
  }

  /// Check if board is full (draw condition)
  bool isBoardFull() {
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (board[i][j].isEmpty) return false;
      }
    }
    return true;
  }

  /// Get all empty cells
  List<List<int>> getEmptyCells() {
    List<List<int>> emptyCells = [];
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (board[i][j].isEmpty) {
          emptyCells.add([i, j]);
        }
      }
    }
    return emptyCells;
  }

  /// Get a copy of the current board
  List<List<String>> getBoardCopy() {
    return List.generate(3, (i) => List.generate(3, (j) => board[i][j]));
  }

  /// Get result string for player ('win', 'draw', 'loss')
  String getResultString(String playerSymbol) {
    if (winner == null) return 'draw';
    return winner == playerSymbol ? 'win' : 'loss';
  }

  /// Check if game is a draw
  bool isDraw() {
    return isGameOver && winner == null;
  }
}
