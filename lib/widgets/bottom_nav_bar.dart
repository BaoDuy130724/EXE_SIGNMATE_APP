import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../utils/app_colors.dart';

class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const AppBottomNavBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF3EEFF),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(context, 0, Icons.home_rounded, Icons.home_outlined, 'Trang chủ', '/home'),
              _buildNavItem(context, 1, Icons.menu_book_rounded, Icons.menu_book_outlined, 'Bài học', '/lesson'),
              _buildNavItem(context, 2, Icons.camera_alt_rounded, Icons.camera_alt_outlined, 'Luyện tập', '/practice-camera'),
              _buildNavItem(context, 3, Icons.bar_chart_rounded, Icons.bar_chart_outlined, 'Tiến độ', '/profile'),
              _buildNavItem(context, 4, Icons.workspace_premium_rounded, Icons.workspace_premium_outlined, 'Premium', '/premium'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    int index,
    IconData activeIcon,
    IconData inactiveIcon,
    String label,
    String route,
  ) {
    final isActive = currentIndex == index;
    return GestureDetector(
      onTap: () {
        if (!isActive) context.go(route);
      },
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : inactiveIcon,
              color: isActive ? AppColors.primary : AppColors.textLight,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                color: isActive ? AppColors.primary : AppColors.textLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
