import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../utils/app_colors.dart';
class ResultSummaryScreen extends StatelessWidget {
  const ResultSummaryScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(backgroundColor: const Color(0xFFF7FDFF), body: SafeArea(child: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
    const Icon(Icons.emoji_events, color: AppColors.warning, size: 80),
    const SizedBox(height: 24),
    const Text('Kết quả tổng', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
    const SizedBox(height: 32),
    Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      _stat('Đúng', '8', AppColors.success), _stat('Sai', '2', AppColors.error), _stat('XP', '+80', AppColors.primary),
    ]),
    const SizedBox(height: 40),
    SizedBox(width: double.infinity, height: 52, child: ElevatedButton(onPressed: () => context.go('/home'), style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: const Text('Về trang chủ'))),
  ]))));
  static Widget _stat(String l, String v, Color c) => Column(children: [Text(v, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: c)), Text(l, style: const TextStyle(color: AppColors.textSecondary))]);
}