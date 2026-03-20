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
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(children: [
            LinearProgressIndicator(value: (_current + 1) / _questions.length,
              backgroundColor: AppColors.divider, valueColor: const AlwaysStoppedAnimation(AppColors.primary)),
            const SizedBox(height: 40),
            Text(q['q'] as String, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            const SizedBox(height: 32),
            ...(q['options'] as List<String>).map((o) => Container(
              margin: const EdgeInsets.only(bottom: 12), width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  if (_current < _questions.length - 1) {
                    setState(() => _current++);
                  } else {
                    context.go('/complete');
                  }
                },
                style: OutlinedButton.styleFrom(padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  side: const BorderSide(color: AppColors.divider)),
                child: Text(o, style: const TextStyle(fontSize: 16, color: AppColors.textPrimary)),
              ),
            )),
          ]),
        ),
      ),
    );
  }
}
