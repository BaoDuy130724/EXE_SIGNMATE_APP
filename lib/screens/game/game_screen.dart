import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../utils/app_colors.dart';
import '../../widgets/common_widgets.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});
  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int _currentQ = 0;
  int _score = 0;
  final int _total = 5;
  bool _answered = false;
  int _selectedAnswer = -1;

  final List<Map<String, dynamic>> _questions = [
    {
      'type': 'match',
      'sign': '👋',
      'question': 'Đây là ký hiệu gì?',
      'options': ['Xin chào', 'Tạm biệt', 'Cảm ơn', 'Xin lỗi'],
      'correct': 0,
    },
    {
      'type': 'match',
      'sign': '🙏',
      'question': 'Chọn đáp án đúng:',
      'options': ['Xin lỗi', 'Cảm ơn', 'Vui lòng', 'Giúp đỡ'],
      'correct': 1,
    },
    {
      'type': 'match',
      'sign': '👍',
      'question': 'Ký hiệu này có nghĩa là?',
      'options': ['Không', 'Có', 'Tốt', 'Đồng ý'],
      'correct': 2,
    },
    {
      'type': 'match',
      'sign': '✌️',
      'question': 'Đây là ký hiệu gì?',
      'options': ['Hai', 'Chiến thắng', 'Hòa bình', 'Số 2'],
      'correct': 3,
    },
    {
      'type': 'match',
      'sign': '🤟',
      'question': 'Ký hiệu này biểu thị:',
      'options': ['Yêu', 'Rock', 'Tôi yêu bạn', 'Xin chào'],
      'correct': 2,
    },
  ];

  @override
  Widget build(BuildContext context) {
    if (_currentQ >= _total) return _buildResult();

    final q = _questions[_currentQ];
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.go('/home'),
        ),
        title: Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: (_currentQ + 1) / _total,
                  minHeight: 6,
                  backgroundColor: Colors.white30,
                  valueColor: const AlwaysStoppedAnimation(Colors.white),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Text('⭐', style: TextStyle(fontSize: 14)),
                  const SizedBox(width: 4),
                  Text(
                    '$_score',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 16),
            // Sign display
            Container(
              width: 120,
              height: 120,
              decoration: const BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(q['sign'], style: const TextStyle(fontSize: 64)),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              q['question'],
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),

            // Options
            ...List.generate(
              (q['options'] as List).length,
              (i) => _answerOption(i, q['options'][i], q['correct']),
            ),

            const Spacer(),

            if (_answered)
              CustomButton(
                text: _currentQ < _total - 1 ? 'Câu tiếp theo' : 'Xem kết quả',
                icon: Icons.arrow_forward_rounded,
                onPressed: () {
                  setState(() {
                    _currentQ++;
                    _answered = false;
                    _selectedAnswer = -1;
                  });
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _answerOption(int index, String text, int correct) {
    Color bgColor = Colors.white;
    Color borderColor = AppColors.divider;
    Color textColor = AppColors.textPrimary;
    IconData? trailingIcon;

    if (_answered) {
      if (index == correct) {
        bgColor = AppColors.successLight;
        borderColor = AppColors.success;
        textColor = AppColors.success;
        trailingIcon = Icons.check_circle;
      } else if (index == _selectedAnswer) {
        bgColor = AppColors.errorLight;
        borderColor = AppColors.error;
        textColor = AppColors.error;
        trailingIcon = Icons.cancel;
      }
    }

    return GestureDetector(
      onTap: _answered
          ? null
          : () {
              setState(() {
                _selectedAnswer = index;
                _answered = true;
                if (index == correct) {
                  _score += 10;
                }
              });
            },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: borderColor.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  String.fromCharCode(65 + index),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                text,
                style: TextStyle(fontSize: 16, color: textColor, fontWeight: FontWeight.w500),
              ),
            ),
            if (trailingIcon != null)
              Icon(trailingIcon, color: textColor),
          ],
        ),
      ),
    );
  }

  Widget _buildResult() {
    final isGood = _score >= 30;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Icon(
                isGood ? Icons.emoji_events_rounded : Icons.refresh_rounded,
                size: 80,
                color: isGood ? AppColors.xpGold : AppColors.primary,
              ),
              const SizedBox(height: 20),
              Text(
                isGood ? 'Tuyệt vời! 🎉' : 'Cố gắng hơn nhé! 💪',
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                '$_score XP kiếm được',
                style: const TextStyle(
                  fontSize: 22,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 24),
              CustomCard(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    StatCard(emoji: '✅', value: '${_score ~/ 10}', label: 'Đúng'),
                    StatCard(emoji: '❌', value: '${_total - _score ~/ 10}', label: 'Sai'),
                    StatCard(emoji: '⭐', value: '+$_score', label: 'XP', valueColor: AppColors.xpGold),
                  ],
                ),
              ),
              const Spacer(),
              CustomButton(
                text: 'Về trang chủ',
                icon: Icons.home_rounded,
                onPressed: () => context.go('/home'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
