import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../utils/app_colors.dart';
class TeacherHomeScreen extends StatelessWidget {
  const TeacherHomeScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(backgroundColor: AppColors.background,
    appBar: AppBar(backgroundColor: AppColors.primary, foregroundColor: Colors.white, title: const Text('Giáo viên'),
      actions: [IconButton(icon: const Icon(Icons.logout), onPressed: () => context.go('/login'))]),
    body: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
      Row(children: [_c('👨‍🎓', '45', 'Học viên'), const SizedBox(width: 12), _c('📚', '12', 'Lớp học')]),
      const SizedBox(height: 12),
      _m(context, Icons.class_, 'Lớp học', '/teacher-class'),
      _m(context, Icons.people, 'Học viên', '/teacher-students'),
      _m(context, Icons.book, 'Bài học', '/teacher-lessons'),
      _m(context, Icons.feedback, 'Nhận xét', '/teacher-feedback'),
    ])));
  static Widget _c(String e, String v, String l) => Expanded(child: Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(e, style: const TextStyle(fontSize: 28)), const SizedBox(height: 8), Text(v, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)), Text(l, style: const TextStyle(color: AppColors.textSecondary))])));
  static Widget _m(BuildContext c, IconData i, String t, String r) => Container(margin: const EdgeInsets.only(bottom: 8),
    child: ListTile(tileColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), leading: Icon(i, color: AppColors.primary), title: Text(t), trailing: const Icon(Icons.chevron_right), onTap: () => c.go(r)));
}