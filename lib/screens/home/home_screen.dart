import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/lesson_provider.dart';
import '../../utils/app_colors.dart';
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
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                      child: Column(
                        children: [
                          // ── Profile Row ──
                          Row(
                            children: [
                              // Avatar
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: AppColors.secondary.withValues(alpha: 0.5),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    auth.userName.isNotEmpty ? auth.userName[0].toUpperCase() : 'S',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              // Greeting
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Xin chào',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white.withValues(alpha: 0.85),
                                      ),
                                    ),
                                    Text(
                                      auth.userName.isEmpty ? 'Bạn' : auth.userName,
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Hamburger menu
                              IconButton(
                                icon: const Icon(Icons.menu, color: Colors.white, size: 28),
                                onPressed: () {},
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // ── Stat Cards Row ──
                          Row(
                            children: [
                              Expanded(
                                child: _statCard(
                                  icon: Icons.gps_fixed,
                                  label: 'Độ chính xác',
                                  value: '${summary?.averageAccuracy.toInt() ?? auth.practiceAccuracy}%',
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _statCard(
                                  icon: Icons.local_fire_department_rounded,
                                  label: 'Giữ chuỗi',
                                  value: '${summary?.currentStreak ?? auth.streak} ngày',
                                  iconColor: AppColors.accentOrange,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // ── Content Section ──
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // ── Continue Lesson Card ──
                    if (lessons.lessons.isNotEmpty)
                      _continueCard(context, lessons),

                    const SizedBox(height: 20),

                    // ── Section Title ──
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Bài học gợi ý',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => context.go('/lesson'),
                          child: Row(
                            children: [
                              Text(
                                'xem thêm',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.accentOrange,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(Icons.chevron_right, size: 18, color: AppColors.accentOrange),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // ── Lesson Cards ──
                    ...lessons.lessons.asMap().entries.take(4).map(
                      (e) => _lessonCard(context, e.value, e.key, lessons),
                    ),

                    const SizedBox(height: 100),
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

  // ── Stat Card (inside gradient) ──
  Widget _statCard({
    required IconData icon,
    required String label,
    required String value,
    Color? iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor ?? Colors.white, size: 24),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Continue Lesson Card ──
  Widget _continueCard(BuildContext context, LessonProvider lp) {
    final lesson = lp.lessons.first;
    return GestureDetector(
      onTap: () {
        lp.startLesson(0);
        context.go('/lesson');
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.accentOrange.withValues(alpha: 0.5), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: AppColors.accentOrange.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Orange play icon
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.accentOrange.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.play_arrow_rounded, color: AppColors.accentOrange, size: 30),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tiếp tục bài học',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.accentOrange,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${lesson['title']} - Bài ${lesson['completed'] + 1}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: lesson['completed'] / lesson['lessons'],
                      minHeight: 5,
                      backgroundColor: AppColors.divider,
                      valueColor: const AlwaysStoppedAnimation(AppColors.accentOrange),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right, color: AppColors.accentOrange),
          ],
        ),
      ),
    );
  }

  // ── Lesson Card ──
  Widget _lessonCard(BuildContext context, Map<String, dynamic> lesson, int index, LessonProvider lp) {
    return GestureDetector(
      onTap: () {
        lp.startLesson(index);
        context.go('/lesson');
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Row(
          children: [
            // Purple play icon
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.play_arrow_rounded, color: AppColors.primary, size: 28),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lesson['title'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        'Cơ bản',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.access_time, size: 14, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        '${lesson['lessons'] * 10} phút',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}