import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/lesson_provider.dart';
import '../../utils/app_colors.dart';

class LessonScreen extends StatelessWidget {
  const LessonScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final lp = context.watch<LessonProvider>();
    final lesson = lp.lessons[lp.currentLesson];
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: AppColors.primary, foregroundColor: Colors.white, title: Text(lesson['title']),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.go('/home'))),
      body: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
        Container(padding: const EdgeInsets.all(24), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: Column(children: [
            Text(lesson['icon'], style: const TextStyle(fontSize: 80)),
            const SizedBox(height: 16),
            const Text('Ký hiệu: Xin chào', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Giơ tay phải lên ngang trán, lòng bàn tay hướng ra ngoài, đưa tay ra phía trước.', style: TextStyle(color: AppColors.textSecondary, fontSize: 14), textAlign: TextAlign.center),
          ])),
        const SizedBox(height: 24),
        Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(16)),
          child: const Row(children: [Icon(Icons.lightbulb, color: AppColors.primary), SizedBox(width: 12),
            Expanded(child: Text('Mẹo: Kết hợp nụ cười khi thực hiện ký hiệu này!', style: TextStyle(color: AppColors.primaryDark, fontSize: 13)))])),
        const Spacer(),
        Row(children: [
          Expanded(child: OutlinedButton(onPressed: () => context.go('/practice'), style: OutlinedButton.styleFrom(padding: const EdgeInsets.all(16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), side: const BorderSide(color: AppColors.primary)), child: const Text('Luyện tập', style: TextStyle(color: AppColors.primary)))),
          const SizedBox(width: 12),
          Expanded(child: ElevatedButton(onPressed: () => context.go('/practice-camera'), style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, padding: const EdgeInsets.all(16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: const Text('Camera AI'))),
        ]),
        const SizedBox(height: 20),
      ])),
    );
  }
}