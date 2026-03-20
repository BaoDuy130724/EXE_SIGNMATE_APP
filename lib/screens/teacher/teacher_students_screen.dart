import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
class TeacherStudentsScreen extends StatelessWidget {
  const TeacherStudentsScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(backgroundColor: AppColors.primary, foregroundColor: Colors.white, title: const Text('Học viên')), body: ListView.builder(padding: const EdgeInsets.all(16), itemCount: 10, itemBuilder: (c, i) => Card(margin: const EdgeInsets.only(bottom: 8), child: ListTile(leading: CircleAvatar(backgroundColor: AppColors.primaryLight, child: Text('H${i+1}')), title: Text('Học viên ${i+1}'), subtitle: Text('Tiến độ: ${50+i*5}%'), trailing: Text('${100+i*50} XP', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold))))));
}