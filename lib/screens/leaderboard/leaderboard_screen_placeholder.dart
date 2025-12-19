import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tictactoe_fp_tekber/constants/app_colors.dart';
import 'package:tictactoe_fp_tekber/models/user_model.dart';
import 'package:tictactoe_fp_tekber/services/firebase/firestore_service.dart';

final _firestoreServiceProvider = Provider((ref) => FirestoreService());

class LeaderboardScreenPlaceholder extends ConsumerWidget {
  const LeaderboardScreenPlaceholder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firestoreService = ref.watch(_firestoreServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/menu'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.emoji_events),
            onPressed: () {},
            tooltip: 'Top Players',
          ),
        ],
      ),
      body: StreamBuilder<List<UserModel>>(
        stream: firestoreService.streamTopLeaderboard(limit: 50),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppColors.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading leaderboard',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    snapshot.error.toString(),
                    style: const TextStyle(color: AppColors.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          final users = snapshot.data ?? [];

          if (users.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.leaderboard_outlined,
                    size: 80,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No players yet',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Be the first to play and get on the leaderboard!',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Top 3 podium
              if (users.isNotEmpty) _buildPodium(users),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Divider(),
              ),

              // Rest of leaderboard
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: users.length > 3 ? users.length - 3 : 0,
                  itemBuilder: (context, index) {
                    final user = users[index + 3];
                    return _buildLeaderboardTile(user, index + 4);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPodium(List<UserModel> users) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // 2nd place
          if (users.length >= 2)
            _buildPodiumItem(users[1], 2, 80, Colors.grey.shade400),

          const SizedBox(width: 8),

          // 1st place
          if (users.isNotEmpty)
            _buildPodiumItem(users[0], 1, 100, const Color(0xFFFFD700)),

          const SizedBox(width: 8),

          // 3rd place
          if (users.length >= 3)
            _buildPodiumItem(users[2], 3, 60, const Color(0xFFCD7F32)),
        ],
      ),
    );
  }

  Widget _buildPodiumItem(UserModel user, int rank, double height, Color medalColor) {
    return Column(
      children: [
        // Medal icon
        Icon(
          Icons.emoji_events,
          color: medalColor,
          size: rank == 1 ? 40 : 30,
        ),
        const SizedBox(height: 8),
        // Avatar
        CircleAvatar(
          radius: rank == 1 ? 35 : 28,
          backgroundColor: AppColors.primary.withOpacity(0.1),
          child: Text(
            user.username.isNotEmpty ? user.username[0].toUpperCase() : '?',
            style: TextStyle(
              fontSize: rank == 1 ? 28 : 22,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ),
        const SizedBox(height: 8),
        // Username
        SizedBox(
          width: 80,
          child: Text(
            user.username,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: rank == 1 ? 14 : 12,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 4),
        // Score
        Text(
          '${user.highestScore} pts',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
            fontSize: rank == 1 ? 16 : 14,
          ),
        ),
        const SizedBox(height: 8),
        // Podium base
        Container(
          width: rank == 1 ? 90 : 70,
          height: height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                medalColor.withOpacity(0.8),
                medalColor.withOpacity(0.4),
              ],
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          child: Center(
            child: Text(
              '#$rank',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLeaderboardTile(UserModel user, int rank) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 30,
              child: Text(
                '#$rank',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            CircleAvatar(
              backgroundColor: AppColors.primary.withOpacity(0.1),
              child: Text(
                user.username.isNotEmpty ? user.username[0].toUpperCase() : '?',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        title: Text(
          user.username,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '${user.totalGamesPlayed} games • ${user.totalWins} wins',
          style: const TextStyle(fontSize: 12),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${user.highestScore}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: AppColors.primary,
              ),
            ),
            const Text(
              'points',
              style: TextStyle(
                fontSize: 10,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
