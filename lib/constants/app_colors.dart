import 'package:flutter/material.dart';

class AppColors {
  // Primary colors
  static const Color primary = Color(0xFF6366F1);
  static const Color primaryLight = Color(0xFF818CF8);
  static const Color primaryDark = Color(0xFF4F46E5);

  // Secondary colors
  static const Color secondary = Color(0xFF10B981);
  static const Color secondaryLight = Color(0xFF34D399);
  static const Color secondaryDark = Color(0xFF059669);

  // Status colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Background colors
  static const Color background = Color(0xFFF9FAFB);
  static const Color darkBackground = Color(0xFF111827);

  // Input colors
  static const Color inputBackground = Color(0xFFFFFFFF);
  static const Color darkInputBackground = Color(0xFF1F2937);
  static const Color borderColor = Color(0xFFE5E7EB);
  static const Color darkBorderColor = Color(0xFF374151);

  // Text colors
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color hintColor = Color(0xFF9CA3AF);

  // Game colors
  static const Color playerX = Color(0xFF3B82F6);
  static const Color playerO = Color(0xFFEF4444);
  static const Color winColor = Color(0xFF10B981);

  // Other
  static const Color divider = Color(0xFFE5E7EB);
  static const Color overlay = Color(0xFF000000);
  static const Color transparent = Color(0x00000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  // Gradients
  static const List<Color> primaryGradient = [primary, primaryLight];
  static const List<Color> successGradient = [success, secondaryLight];
}
