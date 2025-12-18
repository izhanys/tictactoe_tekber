import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tictactoe_fp_tekber/providers/auth_provider.dart';
import 'package:tictactoe_fp_tekber/constants/app_colors.dart';

class GameScreenPlaceholder extends ConsumerWidget {
  const GameScreenPlaceholder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tic Tac Toe'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => context.push('/profile'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(authProvider.notifier).logout();
              if (context.mounted) {
                context.go('/login');
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Game Screen',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 24),
            authState.maybeWhen(
              data: (user) => user != null
                  ? Column(
                      children: [
                        Text(
                          'Welcome, ${user.username}!',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Email: ${user.email}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    )
                  : const Text('No user logged in'),
              orElse: () => const CircularProgressIndicator(),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => context.push('/leaderboard'),
              child: const Text('View Leaderboard'),
            ),
          ],
        ),
      ),
    );
  }
}
