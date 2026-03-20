import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../utils/app_colors.dart';
class ResultCorrectScreen extends StatelessWidget {
  const ResultCorrectScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(backgroundColor: const Color(0xFFF7FDFF), body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
    const Icon(Icons.check_circle, color: AppColors.success, size: 100),
    const SizedBox(height: 24),
    const Text('Chính xác! 🎉', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.success)),
    const SizedBox(height: 12),
    const Text('+10 XP', style: TextStyle(fontSize: 20, color: AppColors.primary, fontWeight: FontWeight.w600)),
    const SizedBox(height: 40),
    ElevatedButton(onPressed: () => context.go('/practice'), style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: const Text('Tiếp tục')),
  ])));
}