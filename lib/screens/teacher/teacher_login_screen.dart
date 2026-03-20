import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../utils/app_colors.dart';
class TeacherLoginScreen extends StatelessWidget {
  const TeacherLoginScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(backgroundColor: AppColors.backgroundLight, body: Center(child: ElevatedButton(onPressed: () => context.go('/teacher-home'), child: const Text('Teacher Login'))));
}