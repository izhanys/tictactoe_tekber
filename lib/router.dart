import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tictactoe_fp_tekber/providers/auth_provider.dart';
import 'package:tictactoe_fp_tekber/screens/auth/login_screen.dart';
import 'package:tictactoe_fp_tekber/screens/auth/register_screen.dart';
import 'package:tictactoe_fp_tekber/screens/game/game_screen_placeholder.dart';
import 'package:tictactoe_fp_tekber/screens/leaderboard/leaderboard_screen_placeholder.dart';
import 'package:tictactoe_fp_tekber/screens/profile/profile_screen_placeholder.dart';
import 'package:tictactoe_fp_tekber/screens/menu/menu_screen.dart';

/// Create GoRouter with authentication guard
GoRouter createRouter(bool isAuthenticated) {
  return GoRouter(
    initialLocation: isAuthenticated ? '/menu' : '/login',
    redirect: (context, state) {
      final loggingIn = state.matchedLocation == '/login' || state.matchedLocation == '/register';

      // If not authenticated and not on login/register, redirect to login
      if (!isAuthenticated && !loggingIn) {
        return '/login';
      }

      // If authenticated and on login/register, redirect to menu
      if (isAuthenticated && loggingIn) {
        return '/menu';
      }

      // No redirect needed
      return null;
    },
    routes: [
      // Auth routes
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),

      // Main app routes
      GoRoute(
        path: '/menu',
        builder: (context, state) => const MenuScreen(),
      ),
      GoRoute(
        path: '/game',
        builder: (context, state) => const GameScreenPlaceholder(),
      ),
      GoRoute(
        path: '/leaderboard',
        builder: (context, state) => const LeaderboardScreenPlaceholder(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreenPlaceholder(),
      ),
    ],
  );
}

// Watch authentication state and create router
final routerProvider = Provider<GoRouter>((ref) {
  final isAuthenticated = ref.watch(isAuthenticatedProvider);
  return createRouter(isAuthenticated);
});
