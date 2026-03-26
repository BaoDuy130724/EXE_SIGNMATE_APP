import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/lesson_provider.dart';
import '../../utils/app_colors.dart';
import '../../widgets/common_widgets.dart';

class LessonDetailScreen extends StatelessWidget {
  const LessonDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lp = context.watch<LessonProvider>();
    final lesson = lp.lessons[lp.currentLesson];
    final progress = lesson['completed'] / lesson['lessons'];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppColors.primary,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () => context.go('/lesson'),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      Text(lesson['icon'], style: const TextStyle(fontSize: 72)),
                      const SizedBox(height: 8),
                      Text(
                        lesson['title'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Progress Card
                CustomCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Tiến độ',
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                          ),
                          Text(
                            '${(progress * 100).toInt()}%',
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 8,
                          backgroundColor: AppColors.divider,
                          valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${lesson['completed']}/${lesson['lessons']} bài đã hoàn thành',
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                      ),
                    ],
                  ),
                ),

                // Sample Video Placeholder
                CustomCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      Container(
                        height: 180,
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.play_circle_fill, size: 56, color: Colors.white.withValues(alpha: 0.7)),
                              const SizedBox(height: 8),
                              Text(
                                'Video mẫu',
                                style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ký hiệu: ${lesson['title']}',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Xem video mẫu để học cách thực hiện ký hiệu này. Hãy chú ý đến tư thế tay, hướng bàn tay, và chuyển động.',
                              style: TextStyle(color: AppColors.textSecondary, fontSize: 14, height: 1.5),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Tips
                CustomCard(
                  color: AppColors.infoLight,
                  padding: const EdgeInsets.all(16),
                  child: const Row(
                    children: [
                      Icon(Icons.lightbulb_rounded, color: AppColors.info, size: 24),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Mẹo: Kết hợp biểu cảm khuôn mặt khi thực hiện ký hiệu để truyền đạt ý nghĩa tốt hơn!',
                          style: TextStyle(color: AppColors.info, fontSize: 13, height: 1.4),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        text: 'Kiểm tra',
                        icon: Icons.quiz_rounded,
                        isOutlined: true,
                        onPressed: () => context.go('/practice'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomButton(
                        text: 'Camera AI',
                        icon: Icons.camera_alt_rounded,
                        onPressed: () => context.go('/practice-camera'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
