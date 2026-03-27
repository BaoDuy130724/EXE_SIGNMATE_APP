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

  // Data from backend (passed via GoRouter extra)
  bool isCorrect = true;
  int accuracy = 0;
  String feedback = '';
  String? geminiFeedback;
  List<Map<String, dynamic>> feedbacks = [];

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
  void didChangeDependencies() {
    super.didChangeDependencies();
    final extra = GoRouterState.of(context).extra;
    if (extra is Map<String, dynamic>) {
      final score = (extra['overallScore'] ?? 0.0);
      accuracy = ((score is double ? score : (score as num).toDouble()) * 100).round();
      isCorrect = accuracy >= 70;
      geminiFeedback = extra['geminiFeedback'] as String?;

      final rawFeedbacks = extra['feedbacks'];
      if (rawFeedbacks is List) {
        feedbacks = rawFeedbacks.cast<Map<String, dynamic>>();
        // Build basic feedback from DTW scores
        final weakest = feedbacks.isNotEmpty
            ? (feedbacks.reduce((a, b) =>
                (a['score'] as num) < (b['score'] as num) ? a : b))
            : null;
        if (weakest != null) {
          feedback = weakest['message'] ?? '';
        }
      }
    }
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
                  if (plan != 'free' && feedback.isNotEmpty)
                    Text(
                      feedback,
                      style: const TextStyle(fontSize: 14, height: 1.4),
                      textAlign: TextAlign.center,
                    ),
                ],
              ),
            ),

            // DTW score breakdown (Basic + Pro)
            if (plan != 'free' && feedbacks.isNotEmpty)
              CustomCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.analytics_outlined, color: AppColors.primary, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Điểm chi tiết',
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ...feedbacks.map((fb) {
                      final score = ((fb['score'] as num?) ?? 0).toDouble();
                      final type = fb['type'] ?? '';
                      final label = _getTypeLabel(type);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 120,
                              child: Text(label, style: const TextStyle(fontSize: 13)),
                            ),
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: score,
                                  backgroundColor: AppColors.divider,
                                  valueColor: AlwaysStoppedAnimation(
                                    score >= 0.7 ? AppColors.success :
                                    score >= 0.5 ? AppColors.warning : AppColors.error,
                                  ),
                                  minHeight: 8,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${(score * 100).round()}%',
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),

            // UC-06 + UC-21: Plan-based detail gating
            if (!isCorrect) ...[
              // Pro only: Gemini AI detailed feedback
              if (plan == 'pro' && geminiFeedback != null && geminiFeedback!.isNotEmpty)
                CustomCard(
                  color: const Color(0xFFF0F7FF),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.auto_awesome, color: AppColors.primary, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Phản hồi AI Coach',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        geminiFeedback!,
                        style: const TextStyle(fontSize: 14, height: 1.6),
                      ),
                    ],
                  ),
                ),

              // Pro without Gemini feedback: show DTW-based errors
              if (plan == 'pro' && (geminiFeedback == null || geminiFeedback!.isEmpty))
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
                      ...feedbacks
                          .where((fb) => ((fb['score'] as num?) ?? 1).toDouble() < 0.7)
                          .map((fb) => Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: _errorItem(
                                  _getTypeIcon(fb['type'] ?? ''),
                                  fb['message'] ?? '',
                                ),
                              )),
                    ],
                  ),
                ),

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
                                  : 'Nâng cấp Pro để nhận phản hồi AI Coach cá nhân hóa',
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

  String _getTypeLabel(String type) {
    switch (type.toLowerCase()) {
      case 'handshape': return '✋ Hình dạng tay';
      case 'movement': return '👋 Chuyển động';
      case 'location': return '📍 Vị trí';
      case 'palmorientation': return '🤚 Hướng lòng bàn tay';
      default: return type;
    }
  }

  String _getTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'handshape': return '✋ Tư thế tay';
      case 'movement': return '👋 Chuyển động';
      case 'location': return '📍 Vị trí tay';
      case 'palmorientation': return '🤚 Hướng bàn tay';
      default: return type;
    }
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
