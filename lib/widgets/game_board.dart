import 'package:flutter/material.dart';
import 'package:tictactoe_fp_tekber/constants/app_colors.dart';

/// Game Board Widget - 3x3 Tic Tac Toe board
class GameBoard extends StatelessWidget {
  final List<List<String>> board;
  final Function(int row, int col) onCellTap;
  final bool enabled;

  const GameBoard({
    Key? key,
    required this.board,
    required this.onCellTap,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: 9,
          itemBuilder: (context, index) {
            final row = index ~/ 3;
            final col = index % 3;
            return _buildCell(row, col);
          },
        ),
      ),
    );
  }

  Widget _buildCell(int row, int col) {
    final value = board[row][col];
    final isEmpty = value.isEmpty;

    return GestureDetector(
      onTap: enabled && isEmpty ? () => onCellTap(row, col) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isEmpty ? AppColors.white : _getCellColor(value),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: value.isNotEmpty
                ? Text(
                    value,
                    key: ValueKey(value),
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: value == 'X' ? AppColors.playerX : AppColors.playerO,
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }

  Color _getCellColor(String value) {
    if (value == 'X') {
      return AppColors.playerX.withOpacity(0.1);
    } else if (value == 'O') {
      return AppColors.playerO.withOpacity(0.1);
    }
    return AppColors.white;
  }
}

/// Difficulty Button Widget
class DifficultyButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const DifficultyButton({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3), width: 2),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: color, size: 20),
          ],
        ),
      ),
    );
  }
}

/// Game Result Dialog Widget
class GameResultDialog extends StatelessWidget {
  final String resultMessage;
  final int pointsEarned;
  final String? difficulty;
  final VoidCallback onPlayAgain;
  final VoidCallback onBackToMenu;

  const GameResultDialog({
    Key? key,
    required this.resultMessage,
    required this.pointsEarned,
    this.difficulty,
    required this.onPlayAgain,
    required this.onBackToMenu,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isWin = resultMessage.contains('Won');
    final isDraw = resultMessage.contains('Draw');

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          // Result icon
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isWin
                  ? AppColors.success.withOpacity(0.1)
                  : isDraw
                      ? AppColors.warning.withOpacity(0.1)
                      : AppColors.error.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isWin
                  ? Icons.emoji_events
                  : isDraw
                      ? Icons.handshake
                      : Icons.sentiment_dissatisfied,
              size: 60,
              color: isWin
                  ? AppColors.success
                  : isDraw
                      ? AppColors.warning
                      : AppColors.error,
            ),
          ),
          const SizedBox(height: 20),
          // Result text
          Text(
            resultMessage,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          // Points earned
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '+$pointsEarned points',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
          if (difficulty != null) ...[
            const SizedBox(height: 8),
            Text(
              'vs $difficulty',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
          const SizedBox(height: 24),
          // Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onBackToMenu,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Menu'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: onPlayAgain,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Play Again',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
