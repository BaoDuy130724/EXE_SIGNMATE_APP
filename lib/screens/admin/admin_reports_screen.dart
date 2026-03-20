import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
class AdminReportsScreen extends StatelessWidget {
  const AdminReportsScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(backgroundColor: AppColors.background,
    appBar: AppBar(backgroundColor: AppColors.primaryDark, foregroundColor: Colors.white, title: const Text('Báo cáo')),
    body: const Center(child: Text('Báo cáo thống kê', style: TextStyle(fontSize: 18))));
}