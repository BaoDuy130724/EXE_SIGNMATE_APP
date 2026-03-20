import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../utils/app_colors.dart';

class PracticeScreen extends StatefulWidget {
  const PracticeScreen({super.key});
  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}
class _PracticeScreenState extends State<PracticeScreen> {
  int _q = 0; int _correct = 0; final _total = 5;
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
    return Scaffold(backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: AppColors.primary, foregroundColor: Colors.white, title: Text('Câu ${_q+1}/$_total'),
        leading: IconButton(icon: const Icon(Icons.close), onPressed: () => context.go('/home'))),
      body: Padding(padding: const EdgeInsets.all(24), child: Column(children: [
        LinearProgressIndicator(value: (_q+1)/_total, backgroundColor: AppColors.divider, valueColor: const AlwaysStoppedAnimation(AppColors.primary)),
        const SizedBox(height: 32),
        Text(q['sign'] as String, style: const TextStyle(fontSize: 80)),
        const SizedBox(height: 16),
        Text(q['question'] as String, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 32),
        ...(q['options'] as List<String>).asMap().entries.map((e) => Container(
          margin: const EdgeInsets.only(bottom: 12), width: double.infinity,
          child: ElevatedButton(
            onPressed: () => setState(() { if(e.key == q['answer']) _correct++; _q++; }),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: AppColors.textPrimary, padding: const EdgeInsets.all(16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 1),
            child: Text(e.value, style: const TextStyle(fontSize: 16)),
          ))),
      ])));
  }

  Widget _buildResult() => Scaffold(backgroundColor: AppColors.background, body: Center(child: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
    Icon(_correct >= 3 ? Icons.emoji_events : Icons.refresh, size: 80, color: _correct >= 3 ? AppColors.warning : AppColors.primary),
    const SizedBox(height: 24),
    Text('$_correct/$_total câu đúng', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
    const SizedBox(height: 12),
    Text(_correct >= 3 ? 'Tuyệt vời! 🎉' : 'Cố gắng hơn nhé! 💪', style: const TextStyle(fontSize: 18, color: AppColors.textSecondary)),
    const SizedBox(height: 32),
    SizedBox(width: double.infinity, height: 52, child: ElevatedButton(onPressed: () => context.go('/home'), style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: const Text('Về trang chủ'))),
  ]))));
}