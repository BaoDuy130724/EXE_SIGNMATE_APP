import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/app_colors.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/bottom_nav_bar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Tiến độ & Hồ sơ'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(icon: const Icon(Icons.settings_outlined), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile header
            CustomCard(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: AppColors.primaryLight,
                    child: Text(
                      auth.userName.isNotEmpty ? auth.userName[0].toUpperCase() : 'U',
                      style: const TextStyle(
                        fontSize: 32,
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    auth.userName.isEmpty ? 'User' : auth.userName,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  PlanBadge(plan: auth.plan),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      StatCard(emoji: '🔥', value: '${auth.streak}', label: 'Streak'),
                      Container(width: 1, height: 40, color: AppColors.divider),
                      StatCard(emoji: '⭐', value: '${auth.totalXp}', label: 'XP', valueColor: AppColors.xpGold),
                      Container(width: 1, height: 40, color: AppColors.divider),
                      StatCard(emoji: '📚', value: '${auth.lessonsCompleted}', label: 'Bài học'),
                    ],
                  ),
                ],
              ),
            ),

            // Accuracy Card
            CustomCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Độ chính xác tổng thể', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      SizedBox(
                        width: 70,
                        height: 70,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CircularProgressIndicator(
                              value: auth.practiceAccuracy / 100,
                              strokeWidth: 8,
                              backgroundColor: AppColors.divider,
                              valueColor: AlwaysStoppedAnimation(
                                auth.practiceAccuracy >= 70 ? AppColors.success : AppColors.warning,
                              ),
                            ),
                            Text(
                              '${auth.practiceAccuracy}%',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _accuracyRow('Bảng chữ cái', 0.9),
                            const SizedBox(height: 6),
                            _accuracyRow('Số đếm', 0.7),
                            const SizedBox(height: 6),
                            _accuracyRow('Chào hỏi', 0.6),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Weekly Stats
            CustomCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Thống kê tuần này', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _barDay('T2', 0.8),
                      _barDay('T3', 0.6),
                      _barDay('T4', 1.0),
                      _barDay('T5', 0.4),
                      _barDay('T6', 0.7),
                      _barDay('T7', 0.3),
                      _barDay('CN', 0.0),
                    ],
                  ),
                ],
              ),
            ),

            // Weak Topics
            CustomCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Chủ đề chưa tốt', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 12),
                  _weakTopic('Cảm xúc', 45, '😊'),
                  const SizedBox(height: 8),
                  _weakTopic('Gia đình', 55, '👨‍👩‍👧'),
                  const SizedBox(height: 8),
                  _weakTopic('Thức ăn', 60, '🍔'),
                ],
              ),
            ),

            // Menu
            CustomCard(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Column(
                children: [
                  _menuItem(Icons.workspace_premium, 'Nâng cấp Premium', () => context.go('/premium'), color: AppColors.xpGold),
                  const Divider(height: 1, indent: 56),
                  _menuItem(Icons.settings, 'Cài đặt', () {}),
                  const Divider(height: 1, indent: 56),
                  _menuItem(Icons.help_outline, 'Trợ giúp', () {}),
                  const Divider(height: 1, indent: 56),
                  _menuItem(Icons.info_outline, 'Về ứng dụng', () {}),
                  const Divider(height: 1, indent: 56),
                  _menuItem(Icons.logout, 'Đăng xuất', () {
                    auth.logout();
                    context.go('/login');
                  }, color: AppColors.error),
                ],
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 3),
    );
  }

  Widget _accuracyRow(String topic, double value) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(topic, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        ),
        Expanded(
          flex: 3,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: value,
              minHeight: 6,
              backgroundColor: AppColors.divider,
              valueColor: AlwaysStoppedAnimation(
                value >= 0.7 ? AppColors.success : (value >= 0.5 ? AppColors.warning : AppColors.error),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text('${(value * 100).toInt()}%', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _barDay(String day, double value) {
    return Column(
      children: [
        Container(
          width: 28,
          height: 70,
          decoration: BoxDecoration(
            color: AppColors.divider,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: 28,
              height: 70 * value,
              decoration: BoxDecoration(
                gradient: value > 0 ? AppColors.primaryGradient : null,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(day, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
      ],
    );
  }

  Widget _weakTopic(String name, int percent, String emoji) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 20)),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
              const SizedBox(height: 4),
              ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: LinearProgressIndicator(
                  value: percent / 100,
                  minHeight: 5,
                  backgroundColor: AppColors.divider,
                  valueColor: AlwaysStoppedAnimation(
                    percent >= 70 ? AppColors.success : (percent >= 50 ? AppColors.warning : AppColors.error),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text('$percent%', style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 13,
          color: percent >= 70 ? AppColors.success : (percent >= 50 ? AppColors.warning : AppColors.error),
        )),
      ],
    );
  }

  Widget _menuItem(IconData icon, String title, VoidCallback onTap, {Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color ?? AppColors.textSecondary),
      title: Text(title, style: TextStyle(color: color)),
      trailing: const Icon(Icons.chevron_right, color: AppColors.textLight, size: 20),
      onTap: onTap,
    );
  }
}