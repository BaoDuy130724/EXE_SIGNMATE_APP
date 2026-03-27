import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../utils/app_colors.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});
  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _current = 0;
  final _questions = [
    {'q': 'Bạn đã biết ngôn ngữ ký hiệu chưa?', 'options': ['Chưa biết gì', 'Biết một chút', 'Khá tốt']},
    {'q': 'Bạn muốn học bao lâu mỗi ngày?', 'options': ['5 phút', '10 phút', '20 phút', '30+ phút']},
    {'q': 'Bạn muốn học ngôn ngữ ký hiệu nào?', 'options': ['Việt Nam (VSL)', 'Quốc tế (ASL)', 'Cả hai']},
  ];

  @override
  Widget build(BuildContext context) {
    final q = _questions[_current];
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
                          onPressed: () => context.go('/register'),
                        ),
                        Expanded(
                          child: Text(
                            'Câu hỏi ${_current + 1}/${_questions.length}',
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
                          value: (_current + 1) / _questions.length,
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
                  Text(
                    q['q'] as String,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  ...(q['options'] as List<String>).map((o) => Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        if (_current < _questions.length - 1) {
                          setState(() => _current++);
                        } else {
                          context.go('/complete');
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.cardBorder),
                        padding: const EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        backgroundColor: Colors.white,
                      ),
                      child: Text(o, style: const TextStyle(fontSize: 16, color: AppColors.textPrimary)),
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
}
