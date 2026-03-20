import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../utils/app_colors.dart';
class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(backgroundColor: AppColors.background,
    appBar: AppBar(backgroundColor: AppColors.primaryDark, foregroundColor: Colors.white, title: const Text('Admin Dashboard'),
      actions: [IconButton(icon: const Icon(Icons.logout), onPressed: () => context.go('/login'))]),
    body: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
      Row(children: [_card('👥', '1,234', 'Tổng users'), const SizedBox(width: 12), _card('📚', '48', 'Bài học')]),
      const SizedBox(height: 12),
      Row(children: [_card('⭐', '156', 'Premium'), const SizedBox(width: 12), _card('📈', '89%', 'Retention')]),
      const SizedBox(height: 24),
      _menu(context, Icons.assessment, 'Báo cáo', '/admin-reports'),
      _menu(context, Icons.people, 'Quản lý users', '/admin-home'),
      _menu(context, Icons.school, 'Quản lý bài học', '/admin-home'),
    ])));
  static Widget _card(String e, String v, String l) => Expanded(child: Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(e, style: const TextStyle(fontSize: 28)), const SizedBox(height: 8), Text(v, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)), Text(l, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13))])));
  static Widget _menu(BuildContext c, IconData i, String t, String r) => Container(margin: const EdgeInsets.only(bottom: 8),
    child: ListTile(tileColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), leading: Icon(i, color: AppColors.primary), title: Text(t), trailing: const Icon(Icons.chevron_right), onTap: () => c.go(r)));
}