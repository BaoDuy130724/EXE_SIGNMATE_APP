import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/app_colors.dart';
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
      body: FutureBuilder<ProgressStatsModel>(
        future: _progressFuture,
        builder: (context, snapshot) {
          final stats = snapshot.data;
          final averageAccuracy = stats?.overallAccuracy.toInt() ?? auth.practiceAccuracy;

          return CustomScrollView(
            slivers: [
              // ── Gradient Header ──
              SliverToBoxAdapter(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(28),
                      bottomRight: Radius.circular(28),
                    ),
                  ),
                  child: SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                      child: Column(
                        children: [
                          // Profile Row
                          Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: AppColors.secondary.withValues(alpha: 0.5),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    auth.userName.isNotEmpty ? auth.userName[0].toUpperCase() : 'S',
                                    style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Xin chào', style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: 0.85))),
                                    Text(
                                      auth.userName.isEmpty ? 'Bạn' : auth.userName,
                                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.settings_outlined, color: Colors.white, size: 26),
                                onPressed: () {},
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          // Stats Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _headerStat('🔥', '${auth.streak}', 'Streak'),
                              Container(width: 1, height: 36, color: Colors.white.withValues(alpha: 0.3)),
                              _headerStat('⭐', '${auth.totalXp}', 'XP'),
                              Container(width: 1, height: 36, color: Colors.white.withValues(alpha: 0.3)),
                              _headerStat('📚', '${auth.lessonsCompleted}', 'Bài học'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // ── Content ──
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // ── Accuracy Card ──
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.cardBorder),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Độ chính xác tổng thể', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 16),
                          Center(
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
                                      backgroundColor: AppColors.cardBorder,
                                      valueColor: AlwaysStoppedAnimation(
                                        averageAccuracy >= 70 ? AppColors.success : AppColors.accentOrange,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '$averageAccuracy%',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: AppColors.primary),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // ── Weekly Stats ──
                    if (auth.isPremium)
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.cardBorder),
                        ),
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
                                      color: AppColors.accentOrange.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text('PRO', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.accentOrange)),
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
                                  : [_barDay('C1', 0), _barDay('C2', 0), _barDay('C3', 0)],
                            ),
                          ],
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.accentOrange.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.accentOrange.withValues(alpha: 0.3)),
                        ),
                        child: Column(
                          children: [
                            const Icon(Icons.lock_outline, color: AppColors.accentOrange, size: 32),
                            const SizedBox(height: 8),
                            const Text('Nâng cấp để xem thống kê chi tiết', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14), textAlign: TextAlign.center),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              height: 44,
                              child: ElevatedButton(
                                onPressed: () => context.go('/premium'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.accentOrange,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                                  elevation: 0,
                                ),
                                child: const Text('Nâng cấp ngay', style: TextStyle(fontWeight: FontWeight.w600)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 14),

                    // ── Menu ──
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.cardBorder),
                      ),
                      child: Column(
                        children: [
                          _menuItem(Icons.workspace_premium, 'Nâng cấp Premium', () => context.go('/premium'), color: AppColors.accentOrange),
                          Divider(height: 1, indent: 56, color: AppColors.cardBorder),
                          _menuItem(Icons.settings, 'Cài đặt', () {}),
                          Divider(height: 1, indent: 56, color: AppColors.cardBorder),
                          _menuItem(Icons.lock_reset, 'Đổi mật khẩu', () => context.go('/change-password')),
                          Divider(height: 1, indent: 56, color: AppColors.cardBorder),
                          _menuItem(Icons.help_outline, 'Trợ giúp', () {}),
                          Divider(height: 1, indent: 56, color: AppColors.cardBorder),
                          _menuItem(Icons.logout, 'Đăng xuất', () {
                            auth.logout();
                            context.go('/login');
                          }, color: AppColors.error),
                        ],
                      ),
                    ),
                    const SizedBox(height: 100),
                  ]),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 3),
    );
  }

  Widget _headerStat(String emoji, String value, String label) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 20)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.8))),
      ],
    );
  }

  Widget _barDay(String day, double value) {
    return Column(
      children: [
        Container(
          width: 28,
          height: 70,
          decoration: BoxDecoration(color: AppColors.cardBorder, borderRadius: BorderRadius.circular(6)),
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

  Widget _menuItem(IconData icon, String title, VoidCallback onTap, {Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color ?? AppColors.textSecondary),
      title: Text(title, style: TextStyle(color: color)),
      trailing: const Icon(Icons.chevron_right, color: AppColors.textLight, size: 20),
      onTap: onTap,
    );
  }
}