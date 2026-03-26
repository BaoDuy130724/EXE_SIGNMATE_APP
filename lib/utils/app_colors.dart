import 'package:flutter/material.dart';

class AppColors {
  // Primary
  static const Color primary = Color(0xFF9B69FE);
  static const Color primaryDark = Color(0xFF8A38F5);
  static const Color primaryLight = Color(0xFFEDE8FF);
  static const Color secondary = Color(0xFFA785FF);

  // Backgrounds
  static const Color background = Color(0xFFF5F5F5);
  static const Color backgroundLight = Color(0xFFFBF6F6);
  static const Color surface = Colors.white;
  static const Color cardBg = Colors.white;
  static const Color divider = Color(0xFFE5E7EB);

  // Text
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textLight = Color(0xFF9CA3AF);

  // Status
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFFD1FAE5);
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFEE2E2);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFFDBEAFE);

  // Gamification
  static const Color xpGold = Color(0xFFFFD700);
  static const Color streakOrange = Color(0xFFFF6B35);
  static const Color levelPurple = Color(0xFF7C3AED);

  // Plan badges
  static const Color planFree = Color(0xFF6B7280);
  static const Color planBasic = Color(0xFF3B82F6);
  static const Color planPro = Color(0xFFFFD700);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF9B69FE), Color(0xFF8A38F5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient premiumGradient = LinearGradient(
    colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF10B981), Color(0xFF059669)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient streakGradient = LinearGradient(
    colors: [Color(0xFFFF6B35), Color(0xFFFF4500)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
