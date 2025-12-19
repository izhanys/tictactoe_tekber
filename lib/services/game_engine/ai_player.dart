import 'dart:math';
import 'game_logic.dart';

/// AI Difficulty levels
enum AIDifficulty { easy, medium, hard }

/// AI Player for Tic Tac Toe
/// Supports 3 difficulty levels: Easy, Medium, Hard
class AIPlayer {
  final AIDifficulty difficulty;
  final String aiSymbol;
  final String playerSymbol;
  final Random _random = Random();

  AIPlayer({
    required this.difficulty,
    this.aiSymbol = 'O',
    this.playerSymbol = 'X',
  });

  /// Get the next move for AI based on difficulty
  List<int>? getNextMove(GameLogic gameLogic) {
    final emptyCells = gameLogic.getEmptyCells();
    if (emptyCells.isEmpty) return null;

    switch (difficulty) {
      case AIDifficulty.easy:
        return _getEasyMove(emptyCells);
      case AIDifficulty.medium:
        return _getMediumMove(gameLogic, emptyCells);
      case AIDifficulty.hard:
        return _getHardMove(gameLogic);
    }
  }

  /// Easy: Random move
  List<int> _getEasyMove(List<List<int>> emptyCells) {
    return emptyCells[_random.nextInt(emptyCells.length)];
  }

  /// Medium: Win if possible, block if needed, prefer center, else random
  List<int> _getMediumMove(GameLogic gameLogic, List<List<int>> emptyCells) {
    // 1. Try to win
    final winningMove = _findWinningMove(gameLogic, aiSymbol);
    if (winningMove != null) return winningMove;

    // 2. Block player from winning
    final blockingMove = _findWinningMove(gameLogic, playerSymbol);
    if (blockingMove != null) return blockingMove;

    // 3. Take center if available
    if (gameLogic.board[1][1].isEmpty) return [1, 1];

    // 4. Take a corner if available
    final corners = [
      [0, 0],
      [0, 2],
      [2, 0],
      [2, 2]
    ];
    final availableCorners =
        corners.where((c) => gameLogic.board[c[0]][c[1]].isEmpty).toList();
    if (availableCorners.isNotEmpty) {
      return availableCorners[_random.nextInt(availableCorners.length)];
    }

    // 5. Random move
    return _getEasyMove(emptyCells);
  }

  /// Find a winning move for the given player
  List<int>? _findWinningMove(GameLogic gameLogic, String symbol) {
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (gameLogic.board[i][j].isEmpty) {
          // Try the move
          gameLogic.board[i][j] = symbol;
          final winner = gameLogic.checkWinner();
          // Undo the move
          gameLogic.board[i][j] = '';

          if (winner == symbol) {
            return [i, j];
          }
        }
      }
    }
    return null;
  }

  /// Hard: Minimax algorithm with alpha-beta pruning (unbeatable)
  List<int> _getHardMove(GameLogic gameLogic) {
    int bestScore = -1000;
    List<int> bestMove = [0, 0];

    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (gameLogic.board[i][j].isEmpty) {
          // Try the move
          gameLogic.board[i][j] = aiSymbol;

          // Calculate score using minimax
          int score = _minimax(gameLogic, 0, false, -1000, 1000);

          // Undo the move
          gameLogic.board[i][j] = '';

          // Update best move
          if (score > bestScore) {
            bestScore = score;
            bestMove = [i, j];
          }
        }
      }
    }

    return bestMove;
  }

  /// Minimax algorithm with alpha-beta pruning
  int _minimax(
      GameLogic gameLogic, int depth, bool isMaximizing, int alpha, int beta) {
    // Check terminal states
    final winner = gameLogic.checkWinner();
    if (winner == aiSymbol) return 10 - depth;
    if (winner == playerSymbol) return depth - 10;
    if (gameLogic.isBoardFull()) return 0;

    if (isMaximizing) {
      int bestScore = -1000;
      for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
          if (gameLogic.board[i][j].isEmpty) {
            gameLogic.board[i][j] = aiSymbol;
            int score = _minimax(gameLogic, depth + 1, false, alpha, beta);
            gameLogic.board[i][j] = '';
            bestScore = max(score, bestScore);
            alpha = max(alpha, score);
            if (beta <= alpha) break;
          }
        }
      }
      return bestScore;
    } else {
      int bestScore = 1000;
      for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
          if (gameLogic.board[i][j].isEmpty) {
            gameLogic.board[i][j] = playerSymbol;
            int score = _minimax(gameLogic, depth + 1, true, alpha, beta);
            gameLogic.board[i][j] = '';
            bestScore = min(score, bestScore);
            beta = min(beta, score);
            if (beta <= alpha) break;
          }
        }
      }
      return bestScore;
    }
  }

  /// Get difficulty name for display
  String getDifficultyName() {
    switch (difficulty) {
      case AIDifficulty.easy:
        return 'AI Easy';
      case AIDifficulty.medium:
        return 'AI Medium';
      case AIDifficulty.hard:
        return 'AI Hard';
    }
  }
}
