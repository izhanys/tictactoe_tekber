import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictactoe_fp_tekber/models/game_result_model.dart';
import 'package:tictactoe_fp_tekber/models/user_model.dart';
import 'package:tictactoe_fp_tekber/services/firebase/firestore_service.dart';
import 'package:tictactoe_fp_tekber/services/game_engine/ai_player.dart';
import 'package:tictactoe_fp_tekber/services/game_engine/game_logic.dart';

/// Game status enum
enum GameStatus { selectingDifficulty, playing, finished }

/// Game state class
class GameState {
  final GameLogic gameLogic;
  final AIPlayer? aiPlayer;
  final AIDifficulty? difficulty;
  final GameStatus status;
  final String playerSymbol;
  final String aiSymbol;
  final bool isPlayerTurn;
  final String? resultMessage;
  final int? pointsEarned;
  final bool isSaving;

  GameState({
    required this.gameLogic,
    this.aiPlayer,
    this.difficulty,
    this.status = GameStatus.selectingDifficulty,
    this.playerSymbol = 'X',
    this.aiSymbol = 'O',
    this.isPlayerTurn = true,
    this.resultMessage,
    this.pointsEarned,
    this.isSaving = false,
  });

  /// Get current board
  List<List<String>> get board => gameLogic.board;

  /// Create initial state
  factory GameState.initial() {
    return GameState(
      gameLogic: GameLogic(),
      status: GameStatus.selectingDifficulty,
    );
  }

  /// Copy with method
  GameState copyWith({
    GameLogic? gameLogic,
    AIPlayer? aiPlayer,
    AIDifficulty? difficulty,
    GameStatus? status,
    String? playerSymbol,
    String? aiSymbol,
    bool? isPlayerTurn,
    String? resultMessage,
    int? pointsEarned,
    bool? isSaving,
  }) {
    return GameState(
      gameLogic: gameLogic ?? this.gameLogic,
      aiPlayer: aiPlayer ?? this.aiPlayer,
      difficulty: difficulty ?? this.difficulty,
      status: status ?? this.status,
      playerSymbol: playerSymbol ?? this.playerSymbol,
      aiSymbol: aiSymbol ?? this.aiSymbol,
      isPlayerTurn: isPlayerTurn ?? this.isPlayerTurn,
      resultMessage: resultMessage ?? this.resultMessage,
      pointsEarned: pointsEarned ?? this.pointsEarned,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}

/// Game Notifier - manages game state
class GameNotifier extends StateNotifier<GameState> {
  final FirestoreService _firestoreService;

  GameNotifier(this._firestoreService) : super(GameState.initial());

  /// Start a new game with selected difficulty
  void startGame(AIDifficulty difficulty) {
    final gameLogic = GameLogic();
    final aiPlayer = AIPlayer(difficulty: difficulty);

    state = GameState(
      gameLogic: gameLogic,
      aiPlayer: aiPlayer,
      difficulty: difficulty,
      status: GameStatus.playing,
      isPlayerTurn: true,
    );
  }

  /// Player makes a move
  Future<void> playerMove(int row, int col) async {
    if (state.status != GameStatus.playing) return;
    if (!state.isPlayerTurn) return;
    if (!state.gameLogic.isValidMove(row, col)) return;

    // Make player move
    state.gameLogic.makeMove(row, col, state.playerSymbol);

    // Check if game is over after player move
    if (state.gameLogic.isGameOver) {
      _handleGameOver();
      return;
    }

    // Switch to AI turn
    state = state.copyWith(isPlayerTurn: false);

    // AI makes move after short delay
    await Future.delayed(const Duration(milliseconds: 500));
    await _aiMove();
  }

  /// AI makes a move
  Future<void> _aiMove() async {
    if (state.status != GameStatus.playing) return;
    if (state.aiPlayer == null) return;

    final move = state.aiPlayer!.getNextMove(state.gameLogic);
    if (move == null) return;

    // Make AI move
    state.gameLogic.makeMove(move[0], move[1], state.aiSymbol);

    // Check if game is over after AI move
    if (state.gameLogic.isGameOver) {
      _handleGameOver();
      return;
    }

    // Switch back to player turn
    state = state.copyWith(isPlayerTurn: true);
  }

  /// Handle game over - calculate result and prepare for save
  void _handleGameOver() {
    final result = state.gameLogic.getResultString(state.playerSymbol);
    int points = 0;
    String message = '';

    switch (result) {
      case 'win':
        points = 10;
        message = '🎉 You Won!';
        break;
      case 'draw':
        points = 5;
        message = '🤝 It\'s a Draw!';
        break;
      case 'loss':
        points = 0;
        message = '😔 You Lost!';
        break;
    }

    state = state.copyWith(
      status: GameStatus.finished,
      isPlayerTurn: false,
      resultMessage: message,
      pointsEarned: points,
    );
  }

  /// Save game result to Firebase
  Future<bool> saveGameResult(UserModel user) async {
    if (state.status != GameStatus.finished || state.difficulty == null) {
      return false;
    }

    state = state.copyWith(isSaving: true);

    final result = state.gameLogic.getResultString(state.playerSymbol);
    final points = state.pointsEarned ?? 0;
    final opponent = state.aiPlayer?.getDifficultyName() ?? 'AI';

    // Create game result
    final gameResult = GameResultModel(
      userId: user.uid,
      result: result,
      pointsEarned: points,
      opponent: opponent,
      gameDate: DateTime.now(),
    );

    try {
      // Save game result
      await _firestoreService.saveGameResult(gameResult);

      // Calculate new stats - accumulate score
      final newGamesPlayed = user.totalGamesPlayed + 1;
      final newWins = user.totalWins + (result == 'win' ? 1 : 0);
      final newTotalScore = user.highestScore + points;

      // Update user stats
      await _firestoreService.updateUserStats(
        uid: user.uid,
        gamesPlayed: newGamesPlayed,
        wins: newWins,
        highestScore: newTotalScore,
      );

      state = state.copyWith(isSaving: false);
      return true;
    } catch (e) {
      print('Error saving game result: $e');
      state = state.copyWith(isSaving: false);
      return false;
    }
  }

  /// Reset to difficulty selection
  void resetToMenu() {
    state = GameState.initial();
  }

  /// Play again with same difficulty
  void playAgain() {
    if (state.difficulty != null) {
      startGame(state.difficulty!);
    } else {
      resetToMenu();
    }
  }
}

/// Firestore service provider
final firestoreServiceProvider = Provider((ref) => FirestoreService());

/// Game provider
final gameProvider = StateNotifierProvider<GameNotifier, GameState>((ref) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return GameNotifier(firestoreService);
});
