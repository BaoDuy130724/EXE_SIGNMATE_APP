import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../utils/app_colors.dart';
class ResultWrongScreen extends StatelessWidget {
  const ResultWrongScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(backgroundColor: AppColors.background, body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
    const Icon(Icons.close, color: AppColors.error, size: 100),
    const SizedBox(height: 24),
    const Text('Chưa đúng 😅', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.error)),
    const SizedBox(height: 12),
    const Text('Đáp án đúng: Xin chào', style: TextStyle(fontSize: 16, color: AppColors.textSecondary)),
    const SizedBox(height: 40),
    ElevatedButton(onPressed: () => context.go('/practice'), style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: const Text('Tiếp tục')),
  ])));
}