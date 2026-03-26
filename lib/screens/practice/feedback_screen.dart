import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/app_colors.dart';
import '../../widgets/common_widgets.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});
  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  // Mock feedback data
  final bool isCorrect = true;
  final int accuracy = 85;
  final String feedback = 'Tư thế tay tốt! Hãy giữ các ngón tay mở rộng hơn một chút.';
  final String handShapeNote = 'Ngón cái hơi gập, cần duỗi thẳng hơn';
  final String angleNote = 'Góc bàn tay hơi nghiêng, cần thẳng hơn';
  final String suggestion = 'Thử giữ cổ tay thẳng và ngón tay mở rộng tự nhiên';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final plan = auth.plan; // 'free', 'basic', 'pro'

    return Scaffold(
      backgroundColor: isCorrect ? const Color(0xFFF0FDF4) : const Color(0xFFFEF2F2),
      appBar: AppBar(
        backgroundColor: isCorrect ? AppColors.success : AppColors.error,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.go('/home'),
        ),
        title: Text(isCorrect ? 'Kết quả' : 'Thử lại'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 16),
            // Result icon
            ScaleTransition(
              scale: _scale,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: (isCorrect ? AppColors.success : AppColors.error).withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded,
                  size: 64,
                  color: isCorrect ? AppColors.success : AppColors.error,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              isCorrect ? 'Chính xác! 🎉' : 'Chưa chính xác 😅',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: isCorrect ? AppColors.success : AppColors.error,
              ),
            ),
            const SizedBox(height: 20),

            // Accuracy gauge — always visible
            CustomCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    'Độ chính xác',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: CircularProgressIndicator(
                          value: accuracy / 100,
                          strokeWidth: 10,
                          backgroundColor: AppColors.divider,
                          valueColor: AlwaysStoppedAnimation(
                            accuracy >= 70 ? AppColors.success : AppColors.warning,
                          ),
                        ),
                      ),
                      Text(
                        '$accuracy%',
                        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Basic/Pro: show feedback text
                  if (plan != 'free')
                    Text(
                      feedback,
                      style: const TextStyle(fontSize: 14, height: 1.4),
                      textAlign: TextAlign.center,
                    ),
                ],
              ),
            ),

            // UC-06 + UC-21: Plan-based detail gating
            if (!isCorrect) ...[
              // Pro only: Detailed error breakdown
              if (plan == 'pro') ...[
                CustomCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.error_outline, color: AppColors.error, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Chi tiết lỗi',
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _errorItem('✋ Tư thế tay', handShapeNote),
                      const SizedBox(height: 10),
                      _errorItem('📐 Góc bàn tay', angleNote),
                    ],
                  ),
                ),
                CustomCard(
                  color: AppColors.infoLight,
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.tips_and_updates, color: AppColors.info),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Gợi ý',
                              style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.info),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              suggestion,
                              style: const TextStyle(color: AppColors.info, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              // Free/Basic: show upgrade prompt for detailed feedback
              if (plan != 'pro')
                CustomCard(
                  color: AppColors.warningLight,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.lock_outline, color: AppColors.warning, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              plan == 'free'
                                  ? 'Nâng cấp để xem phản hồi chi tiết'
                                  : 'Nâng cấp Pro để xem lỗi chi tiết (hand shape, angle)',
                              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: CustomButton(
                          text: '🔓 Nâng cấp ngay',
                          icon: Icons.star,
                          backgroundColor: AppColors.warning,
                          onPressed: () => context.go('/premium'),
                        ),
                      ),
                    ],
                  ),
                ),
            ],

            // XP earned
            if (isCorrect)
              const CustomCard(
                gradient: AppColors.primaryGradient,
                padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('⭐', style: TextStyle(fontSize: 24)),
                    SizedBox(width: 8),
                    Text(
                      '+10 XP',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 20),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'Thử lại',
                    icon: Icons.refresh,
                    isOutlined: true,
                    onPressed: () => context.go('/practice-camera'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomButton(
                    text: 'Tiếp tục',
                    icon: Icons.arrow_forward_rounded,
                    onPressed: () => context.go('/result-summary'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _errorItem(String title, String desc) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 6,
          height: 6,
          margin: const EdgeInsets.only(top: 6),
          decoration: const BoxDecoration(
            color: AppColors.error,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
              Text(desc, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
            ],
          ),
        ),
      ],
    );
  }
}
