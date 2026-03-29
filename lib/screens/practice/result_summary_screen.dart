import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/lesson_provider.dart';
import '../../utils/app_colors.dart';
import '../../widgets/common_widgets.dart';

class ResultSummaryScreen extends StatelessWidget {
  const ResultSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final lesson = context.watch<LessonProvider>();

    final int correct = lesson.correctAnswers;
    final int wrong = lesson.totalQuestions - lesson.correctAnswers;
    final int total = lesson.totalQuestions;
    final double accuracy = total > 0 ? (correct / total * 100) : 0;
    final int xpEarned = correct * 10;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: const Text('Kết quả tổng'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 8),

            // Trophy icon
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: AppColors.warningLight,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.warning.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Icon(Icons.emoji_events, color: AppColors.warning, size: 48),
            ),
            const SizedBox(height: 16),
            const Text(
              'Hoàn thành bài học!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            // Accuracy gauge
            CustomCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text('Độ chính xác', style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
                  const SizedBox(height: 12),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 120,
                        height: 120,
                        child: CircularProgressIndicator(
                          value: accuracy / 100,
                          strokeWidth: 12,
                          backgroundColor: AppColors.divider,
                          valueColor: AlwaysStoppedAnimation(
                            accuracy >= 70 ? AppColors.success : AppColors.warning,
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            '${accuracy.toInt()}%',
                            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            accuracy >= 80 ? 'Xuất sắc!' : (accuracy >= 60 ? 'Khá tốt' : 'Cần cố gắng'),
                            style: TextStyle(
                              fontSize: 12,
                              color: accuracy >= 70 ? AppColors.success : AppColors.warning,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Stats row
            CustomCard(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _statItem('✅', '$correct', 'Đúng', AppColors.success),
                  Container(width: 1, height: 40, color: AppColors.divider),
                  _statItem('❌', '$wrong', 'Sai', AppColors.error),
                  Container(width: 1, height: 40, color: AppColors.divider),
                  _statItem('📝', '$total', 'Tổng câu', AppColors.info),
                  Container(width: 1, height: 40, color: AppColors.divider),
                  _statItem('⭐', '+$xpEarned', 'XP', AppColors.xpGold),
                ],
              ),
            ),

            // Mistakes breakdown
            if (wrong > 0)
              CustomCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.warning_amber_rounded, color: AppColors.warning, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Cần ôn lại',
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (lesson.mistakes.isEmpty)
                      _mistakeItem('Cần chú ý hơn các động tác sai', wrong)
                    else
                      ...lesson.mistakes.map((m) => Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: _mistakeItem(m, 1))),
                  ],
                ),
              ),

            // XP Badge
            CustomCard(
              gradient: AppColors.primaryGradient,
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('⭐', style: TextStyle(fontSize: 28)),
                  const SizedBox(width: 10),
                  Text(
                    '+$xpEarned XP',
                    style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  if (auth.streak > 0) ...[
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '🔥 ${auth.streak} streak',
                        style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Action buttons — UC-07: Next lesson + Replay; UC-22: Gamification trigger
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'Chơi lại',
                    icon: Icons.refresh,
                    isOutlined: true,
                    onPressed: () {
                      lesson.reset();
                      context.go('/practice-camera');
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomButton(
                    text: 'Chơi game 🎮',
                    icon: Icons.sports_esports,
                    backgroundColor: AppColors.streakOrange,
                    onPressed: () => context.go('/game'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                text: 'Bài tiếp theo',
                icon: Icons.arrow_forward_rounded,
                onPressed: () => context.go('/lesson'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statItem(String emoji, String value, String label, Color color) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 20)),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
        ),
        Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
      ],
    );
  }

  Widget _mistakeItem(String desc, int count) {
    return Row(
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: const BoxDecoration(color: AppColors.warning, shape: BoxShape.circle),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(desc, style: const TextStyle(fontSize: 13)),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.warningLight,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '${count}x',
            style: const TextStyle(color: AppColors.warning, fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}