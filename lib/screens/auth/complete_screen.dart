import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../utils/app_colors.dart';

class CompleteScreen extends StatelessWidget {
  const CompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(width: 120, height: 120,
              decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.1), shape: BoxShape.circle),
              child: const Icon(Icons.check_circle, color: AppColors.success, size: 64)),
            const SizedBox(height: 32),
            const Text('Hoàn thành! 🎉', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Text('Chương trình học đã được cá nhân hóa cho bạn', style: TextStyle(color: AppColors.textSecondary, fontSize: 16), textAlign: TextAlign.center),
            const SizedBox(height: 48),
            SizedBox(width: double.infinity, height: 52,
              child: ElevatedButton(
                onPressed: () => context.go('/home'),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: const Text('Bắt đầu học', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              )),
          ]),
        ),
      ),
    );
  }
}
