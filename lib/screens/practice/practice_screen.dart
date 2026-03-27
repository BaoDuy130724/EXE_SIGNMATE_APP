import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../utils/app_colors.dart';

class PracticeScreen extends StatefulWidget {
  const PracticeScreen({super.key});
  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  int _q = 0;
  int _correct = 0;
  final _total = 5;
  final _questions = [
    {'sign': '👋', 'question': 'Đây là ký hiệu gì?', 'options': ['Xin chào', 'Tạm biệt', 'Cảm ơn', 'Xin lỗi'], 'answer': 0},
    {'sign': '🙏', 'question': 'Đây là ký hiệu gì?', 'options': ['Xin lỗi', 'Cảm ơn', 'Vui lòng', 'Giúp đỡ'], 'answer': 1},
    {'sign': '👍', 'question': 'Đây là ký hiệu gì?', 'options': ['Không', 'Có', 'Tốt', 'Đồng ý'], 'answer': 2},
    {'sign': '✌️', 'question': 'Đây là ký hiệu gì?', 'options': ['Hai', 'Chiến thắng', 'Hòa bình', 'Số 2'], 'answer': 3},
    {'sign': '🤟', 'question': 'Đây là ký hiệu gì?', 'options': ['Yêu', 'Rock', 'Tôi yêu bạn', 'Xin chào'], 'answer': 2},
  ];

  @override
  Widget build(BuildContext context) {
    if (_q >= _total) return _buildResult();
    final q = _questions[_q];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // ── Gradient Header ──
          Container(
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
                padding: const EdgeInsets.fromLTRB(8, 8, 16, 20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () => context.go('/home'),
                        ),
                        Expanded(
                          child: Text(
                            'Câu ${_q + 1}/$_total',
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: (_q + 1) / _total,
                          minHeight: 6,
                          backgroundColor: Colors.white.withValues(alpha: 0.2),
                          valueColor: const AlwaysStoppedAnimation(Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Question Content ──
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Spacer(),
                  Text(q['sign'] as String, style: const TextStyle(fontSize: 80)),
                  const SizedBox(height: 20),
                  Text(
                    q['question'] as String,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 32),
                  ...(q['options'] as List<String>).asMap().entries.map((e) => Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => setState(() {
                        if (e.key == q['answer']) _correct++;
                        _q++;
                      }),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.cardBorder),
                        padding: const EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        backgroundColor: Colors.white,
                      ),
                      child: Text(e.value, style: const TextStyle(fontSize: 16, color: AppColors.textPrimary)),
                    ),
                  )),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResult() {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              Icon(
                _correct >= 3 ? Icons.emoji_events : Icons.refresh,
                size: 80,
                color: _correct >= 3 ? AppColors.accentOrange : Colors.white,
              ),
              const SizedBox(height: 24),
              Text(
                '$_correct/$_total câu đúng',
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 12),
              Text(
                _correct >= 3 ? 'Tuyệt vời! 🎉' : 'Cố gắng hơn nhé! 💪',
                style: TextStyle(fontSize: 18, color: Colors.white.withValues(alpha: 0.85)),
              ),
              const Spacer(flex: 2),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () => context.go('/home'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                      elevation: 0,
                    ),
                    child: const Text('Về trang chủ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                ),
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}