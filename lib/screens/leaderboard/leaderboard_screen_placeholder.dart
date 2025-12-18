import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LeaderboardScreenPlaceholder extends StatelessWidget {
  const LeaderboardScreenPlaceholder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/game'),
        ),
      ),
      body: Center(
        child: Text(
          'Leaderboard Screen',
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
    );
  }
}
