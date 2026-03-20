import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../utils/app_colors.dart';

class RegisterStep2Screen extends StatefulWidget {
  const RegisterStep2Screen({super.key});
  @override
  State<RegisterStep2Screen> createState() => _RegisterStep2ScreenState();
}

class _RegisterStep2ScreenState extends State<RegisterStep2Screen> {
  String _selectedGoal = '';
  final goals = [
    {'icon': '📚', 'title': 'Học cơ bản', 'desc': 'Tôi muốn học từ đầu'},
    {'icon': '💼', 'title': 'Công việc', 'desc': 'Sử dụng trong công việc'},
    {'icon': '❤️', 'title': 'Gia đình', 'desc': 'Giao tiếp với người thân'},
    {'icon': '🎓', 'title': 'Nghiên cứu', 'desc': 'Mục đích học thuật'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop())),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(children: [
          const SizedBox(height: 20),
          const Text('Mục tiêu của bạn?', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Giúp chúng tôi cá nhân hóa trải nghiệm', style: TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 32),
          ...goals.map((g) => _goalCard(g)),
          const Spacer(),
          SizedBox(width: double.infinity, height: 52,
            child: ElevatedButton(
              onPressed: _selectedGoal.isEmpty ? null : () => context.go('/quiz'),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              child: const Text('Tiếp tục', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            )),
          const SizedBox(height: 40),
        ]),
      ),
    );
  }

  Widget _goalCard(Map<String, String> goal) {
    final selected = _selectedGoal == goal['title'];
    return GestureDetector(
      onTap: () => setState(() => _selectedGoal = goal['title']!),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryLight : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: selected ? AppColors.primary : AppColors.divider, width: selected ? 2 : 1),
        ),
        child: Row(children: [
          Text(goal['icon']!, style: const TextStyle(fontSize: 32)),
          const SizedBox(width: 16),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(goal['title']!, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
            Text(goal['desc']!, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
          ])),
          if (selected) const Icon(Icons.check_circle, color: AppColors.primary),
        ]),
      ),
    );
  }
}
