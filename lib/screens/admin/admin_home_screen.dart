import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../utils/app_colors.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => context.go('/login'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // UC-19: Stats row 1
            Row(
              children: [
                _statCard('👥', '1,234', 'Tổng users', AppColors.primary),
                const SizedBox(width: 12),
                _statCard('💰', '12.5M', 'Doanh thu', AppColors.success),
              ],
            ),
            const SizedBox(height: 12),
            // Stats row 2
            Row(
              children: [
                _statCard('🏢', '8', 'Trung tâm', AppColors.info),
                const SizedBox(width: 12),
                _statCard('📈', '89%', 'Conversion', AppColors.streakOrange),
              ],
            ),
            const SizedBox(height: 12),
            // Stats row 3
            Row(
              children: [
                _statCard('⭐', '156', 'Premium', AppColors.xpGold),
                const SizedBox(width: 12),
                _statCard('📊', '78%', 'Retention', AppColors.levelPurple),
              ],
            ),

            const SizedBox(height: 24),
            const Text(
              'Quản lý hệ thống',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // UC-20: CRUD menus
            _menuItem(context, Icons.assessment, 'Báo cáo thống kê', '/admin-reports'),
            _menuItem(context, Icons.people, 'Quản lý Users', '/admin-reports'),
            _menuItem(context, Icons.business, 'Quản lý Centers', '/admin-reports'),
            _menuItem(context, Icons.card_membership, 'Quản lý Plans', '/admin-reports'),
            _menuItem(context, Icons.school, 'Quản lý Bài học', '/admin-reports'),
            _menuItem(context, Icons.content_paste, 'Quản lý Content', '/admin-reports'),
          ],
        ),
      ),
    );
  }

  Widget _statCard(String emoji, String value, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(emoji, style: const TextStyle(fontSize: 24)),
                const Spacer(),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuItem(BuildContext context, IconData icon, String title, String route) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        tileColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        leading: Icon(icon, color: AppColors.primary),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.go(route),
      ),
    );
  }
}