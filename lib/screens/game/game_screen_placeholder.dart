import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tictactoe_fp_tekber/providers/auth_provider.dart';
import 'package:tictactoe_fp_tekber/providers/game_provider.dart';
import 'package:tictactoe_fp_tekber/services/game_engine/ai_player.dart';
import 'package:tictactoe_fp_tekber/constants/app_colors.dart';
import 'package:tictactoe_fp_tekber/widgets/game_board.dart';

class GameScreenPlaceholder extends ConsumerStatefulWidget {
  const GameScreenPlaceholder({Key? key}) : super(key: key);

  @override
  ConsumerState<GameScreenPlaceholder> createState() => _GameScreenPlaceholderState();
}

class _GameScreenPlaceholderState extends ConsumerState<GameScreenPlaceholder> {
  bool _resultSaved = false;

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameProvider);
    final authState = ref.watch(authProvider);

    // Show result dialog when game is finished
    if (gameState.status == GameStatus.finished && !_resultSaved) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showResultDialog(context, gameState, authState);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tic Tac Toe'),
        leading: gameState.status != GameStatus.selectingDifficulty
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  ref.read(gameProvider.notifier).resetToMenu();
                },
              )
            : null,
        actions: [
          if (gameState.status == GameStatus.playing)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                ref.read(gameProvider.notifier).playAgain();
              },
              tooltip: 'Restart',
            ),
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () => context.go('/menu'),
            tooltip: 'Menu',
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _buildContent(gameState),
        ),
      ),
    );
  }

  Widget _buildContent(GameState gameState) {
    switch (gameState.status) {
      case GameStatus.selectingDifficulty:
        return _buildDifficultySelection();
      case GameStatus.playing:
      case GameStatus.finished:
        return _buildGameBoard(gameState);
    }
  }

  Widget _buildDifficultySelection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.psychology,
          size: 80,
          color: AppColors.primary,
        ),
        const SizedBox(height: 24),
        const Text(
          'Select Difficulty',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Choose your opponent',
          style: TextStyle(
            fontSize: 16,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 40),
        DifficultyButton(
          title: 'Easy',
          subtitle: 'Random moves - Perfect for beginners',
          icon: Icons.sentiment_satisfied,
          color: AppColors.secondary,
          onTap: () => _startGame(AIDifficulty.easy),
        ),
        const SizedBox(height: 16),
        DifficultyButton(
          title: 'Medium',
          subtitle: 'Strategic moves - A fair challenge',
          icon: Icons.psychology_alt,
          color: AppColors.warning,
          onTap: () => _startGame(AIDifficulty.medium),
        ),
        const SizedBox(height: 16),
        DifficultyButton(
          title: 'Hard',
          subtitle: 'Minimax AI - Nearly unbeatable',
          icon: Icons.smart_toy,
          color: AppColors.error,
          onTap: () => _startGame(AIDifficulty.hard),
        ),
      ],
    );
  }

  Widget _buildGameBoard(GameState gameState) {
    return Column(
      children: [
        // Difficulty badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: _getDifficultyColor(gameState.difficulty).withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            gameState.aiPlayer?.getDifficultyName() ?? 'AI',
            style: TextStyle(
              color: _getDifficultyColor(gameState.difficulty),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Turn indicator
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: gameState.isPlayerTurn
                ? AppColors.playerX.withOpacity(0.1)
                : AppColors.playerO.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!gameState.isPlayerTurn && gameState.status == GameStatus.playing)
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              if (!gameState.isPlayerTurn && gameState.status == GameStatus.playing)
                const SizedBox(width: 12),
              Text(
                gameState.status == GameStatus.finished
                    ? (gameState.resultMessage ?? 'Game Over')
                    : (gameState.isPlayerTurn ? 'Your Turn (X)' : 'AI Thinking...'),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: gameState.isPlayerTurn ? AppColors.playerX : AppColors.playerO,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Game board
        Expanded(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 350, maxHeight: 350),
              child: GameBoard(
                board: gameState.board,
                onCellTap: (row, col) {
                  ref.read(gameProvider.notifier).playerMove(row, col);
                },
                enabled: gameState.isPlayerTurn && gameState.status == GameStatus.playing,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Score info
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildScoreCard('You', 'X', AppColors.playerX),
            const SizedBox(width: 32),
            _buildScoreCard('AI', 'O', AppColors.playerO),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildScoreCard(String label, String symbol, Color color) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color, width: 2),
          ),
          child: Center(
            child: Text(
              symbol,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  void _startGame(AIDifficulty difficulty) {
    _resultSaved = false;
    ref.read(gameProvider.notifier).startGame(difficulty);
  }

  Color _getDifficultyColor(AIDifficulty? difficulty) {
    switch (difficulty) {
      case AIDifficulty.easy:
        return AppColors.secondary;
      case AIDifficulty.medium:
        return AppColors.warning;
      case AIDifficulty.hard:
        return AppColors.error;
      default:
        return AppColors.primary;
    }
  }

  void _showResultDialog(BuildContext context, GameState gameState, AsyncValue authState) {
    if (_resultSaved) return;
    _resultSaved = true;

    // Auto-save result to Firebase and refresh user data
    authState.maybeWhen(
      data: (user) async {
        if (user != null) {
          await ref.read(gameProvider.notifier).saveGameResult(user);
          // Refresh user data after save
          await ref.read(authProvider.notifier).refreshUser();
        }
      },
      orElse: () {},
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => GameResultDialog(
        resultMessage: gameState.resultMessage ?? 'Game Over',
        pointsEarned: gameState.pointsEarned ?? 0,
        difficulty: gameState.aiPlayer?.getDifficultyName(),
        onPlayAgain: () {
          Navigator.of(dialogContext).pop();
          _resultSaved = false;
          ref.read(gameProvider.notifier).playAgain();
        },
        onBackToMenu: () {
          Navigator.of(dialogContext).pop();
          ref.read(gameProvider.notifier).resetToMenu();
          context.go('/menu');
        },
      ),
    );
  }
}
