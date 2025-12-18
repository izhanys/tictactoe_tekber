import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tictactoe_fp_tekber/providers/auth_provider.dart';

class ProfileScreenPlaceholder extends ConsumerWidget {
  const ProfileScreenPlaceholder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/game'),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Profile Screen',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 24),
            authState.maybeWhen(
              data: (user) => user != null
                  ? Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          child: Text(user.username[0].toUpperCase()),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          user.username,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(user.email),
                        const SizedBox(height: 24),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                _StatRow(
                                  label: 'Games Played',
                                  value: user.totalGamesPlayed.toString(),
                                ),
                                const Divider(),
                                _StatRow(
                                  label: 'Wins',
                                  value: user.totalWins.toString(),
                                ),
                                const Divider(),
                                _StatRow(
                                  label: 'Highest Score',
                                  value: user.highestScore.toString(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  : const Text('No user logged in'),
              orElse: () => const CircularProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;

  const _StatRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        Text(value, style: Theme.of(context).textTheme.titleMedium),
      ],
    );
  }
}
