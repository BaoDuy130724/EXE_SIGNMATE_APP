import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/lesson_provider.dart';
import '../../utils/app_colors.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/bottom_nav_bar.dart';

import '../../services/dashboard_service.dart';
import '../../models/dashboard_summary_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DashboardService _dashboardService = DashboardService();
  Future<DashboardSummaryModel>? _summaryFuture;

  @override
  void initState() {
    super.initState();
    _summaryFuture = _dashboardService.getSummary();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final lessons = context.watch<LessonProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: FutureBuilder<DashboardSummaryModel>(
        future: _summaryFuture,
        builder: (context, snapshot) {
          final summary = snapshot.data;
          
          return CustomScrollView(
            slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 140,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.primary,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 22,
                              backgroundColor: Colors.white24,
                              child: Text(
                                auth.userName.isNotEmpty ? auth.userName[0].toUpperCase() : 'U',
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Xin chào, ${auth.userName.isEmpty ? "Bạn" : auth.userName}! 👋',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Row(
                                    children: [
                                      StreakWidget(streak: summary?.currentStreak ?? auth.streak, compact: true),
                                      const SizedBox(width: 8),
                                      PlanBadge(plan: auth.plan),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.notifications_outlined, color: Colors.white),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Content
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Stats Row
                Row(
                  children: [
                    Expanded(
                      child: CustomCard(
                        onTap: () => context.go('/profile'),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            const Text('🎯', style: TextStyle(fontSize: 28)),
                            const SizedBox(height: 6),
                            Text(
                              '${summary?.averageAccuracy.toInt() ?? auth.practiceAccuracy}%',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            const Text(
                              'Chính xác',
                              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: CustomCard(
                        onTap: () => context.go('/profile'),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            const Text('⭐', style: TextStyle(fontSize: 28)),
                            const SizedBox(height: 6),
                            Text(
                              '${auth.totalXp}',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: AppColors.xpGold,
                              ),
                            ),
                            const Text(
                              'Tổng XP',
                              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: CustomCard(
                        onTap: () => context.go('/profile'),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            const Text('📚', style: TextStyle(fontSize: 28)),
                            const SizedBox(height: 6),
                            Text(
                              '${auth.lessonsCompleted}',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: AppColors.success,
                              ),
                            ),
                            const Text(
                              'Bài học',
                              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Quick Actions
                Row(
                  children: [
                    _quickAction(context, '📹', 'Camera AI', '/practice-camera', AppColors.primaryLight),
                    const SizedBox(width: 10),
                    _quickAction(context, '📝', 'Kiểm tra', '/practice', AppColors.successLight),
                    const SizedBox(width: 10),
                    _quickAction(context, '🏆', 'Nâng cấp', '/premium', AppColors.warningLight),
                  ],
                ),

                const SizedBox(height: 20),

                // Continue Learning Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Tiếp tục học',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () => context.go('/lesson'),
                      child: const Text('Xem tất cả', style: TextStyle(color: AppColors.primary)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Lesson cards
                ...lessons.lessons.asMap().entries.take(4).map(
                  (e) => _lessonCard(context, e.value, e.key, lessons),
                ),

                const SizedBox(height: 100), // Space for bottom nav
              ]),
            ),
          ),
            ],
          );
        },
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 0),
    );
  }

  Widget _quickAction(BuildContext context, String emoji, String label, String route, Color bgColor) {
    return Expanded(
      child: GestureDetector(
        onTap: () => context.go(route),
        child: CustomCard(
          margin: EdgeInsets.zero,
          padding: const EdgeInsets.symmetric(vertical: 16),
          color: bgColor,
          child: Column(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 28)),
              const SizedBox(height: 6),
              Text(
                label,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _lessonCard(BuildContext context, Map<String, dynamic> lesson, int index, LessonProvider lp) {
    final progress = lesson['completed'] / lesson['lessons'];
    return CustomCard(
      onTap: () {
        lp.startLesson(index);
        context.go('/lesson');
      },
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(child: Text(lesson['icon'], style: const TextStyle(fontSize: 26))),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lesson['title'],
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  '${lesson['completed']}/${lesson['lessons']} bài',
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 5,
                    backgroundColor: AppColors.divider,
                    valueColor: AlwaysStoppedAnimation(
                      progress >= 1.0 ? AppColors.success : AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            progress >= 1.0 ? Icons.check_circle : Icons.chevron_right,
            color: progress >= 1.0 ? AppColors.success : AppColors.textLight,
          ),
        ],
      ),
    );
  }
}