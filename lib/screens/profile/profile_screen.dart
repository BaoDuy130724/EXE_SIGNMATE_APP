import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/app_colors.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/bottom_nav_bar.dart';

import '../../services/dashboard_service.dart';
import '../../models/progress_stats_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final DashboardService _dashboardService = DashboardService();
  Future<ProgressStatsModel>? _progressFuture;

  @override
  void initState() {
    super.initState();
    _progressFuture = _dashboardService.getProgressStats();
  }

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
      body: FutureBuilder<ProgressStatsModel>(
        future: _progressFuture,
        builder: (context, snapshot) {
          final stats = snapshot.data;
          final averageAccuracy = stats?.overallAccuracy.toInt() ?? auth.practiceAccuracy;

          return SingleChildScrollView(
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
                      Expanded(
                        child: Center(
                          child: SizedBox(
                            width: 100,
                            height: 100,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: CircularProgressIndicator(
                                    value: averageAccuracy / 100,
                                    strokeWidth: 8,
                                    backgroundColor: AppColors.divider,
                                    valueColor: AlwaysStoppedAnimation(
                                      averageAccuracy >= 70 ? AppColors.success : AppColors.warning,
                                    ),
                                  ),
                                ),
                                Text(
                                  '$averageAccuracy%',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Weekly Stats — UC-09 plan gating
            if (auth.isPremium) ...[
              CustomCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('Thống kê tuần này', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        if (auth.isPro) ...[
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.warningLight,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text('PRO', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.warning)),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: stats?.accuracyByTopic.isNotEmpty == true
                        ? stats!.accuracyByTopic.entries.take(7).map((e) {
                            String name = e.key.length > 3 ? e.key.substring(0, 3).toUpperCase() : e.key.toUpperCase();
                            return _barDay(name, e.value / 100);
                          }).toList()
                        : [
                            _barDay('C1', 0),
                            _barDay('C2', 0),
                            _barDay('C3', 0),
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
                    ...((stats?.weakTopics ?? []).isEmpty
                        ? [const Text('Chưa có dữ liệu. Hãy tham gia thêm bài học!', style: TextStyle(color: AppColors.textSecondary, fontSize: 13))]
                        : stats!.weakTopics.take(3).map((topic) {
                            final acc = stats.accuracyByTopic[topic] ?? 50;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: _weakTopic(topic, acc, '📚'),
                            );
                          }).toList()),
                  ],
                ),
              ),
            ] else ...[
              // Free plan — locked
              CustomCard(
                color: AppColors.warningLight,
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Icon(Icons.lock_outline, color: AppColors.warning, size: 32),
                    const SizedBox(height: 8),
                    const Text(
                      'Nâng cấp để xem thống kê chi tiết',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Biểu đồ tuần, chủ đề yếu, và phân tích nâng cao',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => context.go('/premium'),
                        icon: const Icon(Icons.star, size: 18),
                        label: const Text('Nâng cấp ngay'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.warning,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Menu
            CustomCard(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Column(
                children: [
                  _menuItem(Icons.workspace_premium, 'Nâng cấp Premium', () => context.go('/premium'), color: AppColors.xpGold),
                  const Divider(height: 1, indent: 56),
                  _menuItem(Icons.settings, 'Cài đặt', () {}),
                  const Divider(height: 1, indent: 56),
                  _menuItem(Icons.lock_reset, 'Đổi mật khẩu', () => context.go('/change-password')),
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
      );
        },
      ),
    bottomNavigationBar: const AppBottomNavBar(currentIndex: 3),
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