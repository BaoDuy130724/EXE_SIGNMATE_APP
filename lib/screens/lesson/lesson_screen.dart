import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/lesson_provider.dart';
import '../../utils/app_colors.dart';
import '../../widgets/bottom_nav_bar.dart';

class LessonScreen extends StatefulWidget {
  const LessonScreen({super.key});
  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  // Color map per lesson category
  static const Map<String, Color> _categoryColors = {
    'Cơ bản': Color(0xFF34A853),      // Green
    'Gia đình': Color(0xFFFF9800),    // Orange  
    'Ăn uống': Color(0xFF7C3AED),     // Purple
    'Giao tiếp': Color(0xFF3B82F6),   // Blue
    'Số đếm': Color(0xFF34A853),      // Green
  };

  Color _getColor(Map<String, dynamic> lesson) {
    final title = lesson['title'] as String? ?? '';
    final topic = lesson['topic'] as String? ?? '';
    // Try to match by title first, then by topic
    for (final key in _categoryColors.keys) {
      if (title.toLowerCase().contains(key.toLowerCase()) || 
          topic.toLowerCase().contains(key.toLowerCase())) {
        return _categoryColors[key]!;
      }
    }
    return _categoryColors['Cơ bản']!; // Default green
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final lp = context.watch<LessonProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ── Gradient Header with Search ──
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
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Xin chào',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white.withValues(alpha: 0.85),
                                  ),
                                ),
                                Text(
                                  auth.userName.isEmpty ? 'Bạn' : auth.userName,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.menu, color: Colors.white, size: 28),
                            onPressed: () {},
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // ── Search Bar ──
                      Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 16),
                            Icon(Icons.search, color: Colors.white.withValues(alpha: 0.8), size: 22),
                            const SizedBox(width: 10),
                            Text(
                              'Tìm kiếm bài học...',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.7),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── Lesson Cards ──
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index >= lp.lessons.length) return null;
                  final lesson = lp.lessons[index];
                  final color = _getColor(lesson);
                  final progress = lesson['completed'] / lesson['lessons'];
                  return _lessonCard(context, lesson, index, lp, color, progress);
                },
                childCount: lp.lessons.length,
              ),
            ),
          ),

          // Bottom spacing
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 1),
    );
  }

  Widget _lessonCard(
    BuildContext context,
    Map<String, dynamic> lesson,
    int index,
    LessonProvider lp,
    Color categoryColor,
    double progress,
  ) {
    return GestureDetector(
      onTap: () {
        lp.startLesson(index);
        context.go('/lesson-detail');
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: categoryColor.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: categoryColor.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            // ── Book Icon ──
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: categoryColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.menu_book_rounded, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 14),
            // ── Content ──
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lesson['title'],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: categoryColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        lesson['level'] ?? 'Cơ bản',
                        style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                      ),
                      const SizedBox(width: 10),
                      Icon(Icons.access_time, size: 14, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        '${lesson['duration'] ?? lesson['lessons'] * 10} phút',
                        style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // ── Progress Bar ──
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 5,
                      backgroundColor: categoryColor.withValues(alpha: 0.15),
                      valueColor: AlwaysStoppedAnimation(categoryColor),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            // ── Chevron ──
            Icon(Icons.chevron_right, color: categoryColor, size: 24),
          ],
        ),
      ),
    );
  }
}