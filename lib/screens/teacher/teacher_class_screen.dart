import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
class TeacherClassScreen extends StatelessWidget {
  const TeacherClassScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(backgroundColor: AppColors.primary, foregroundColor: Colors.white, title: const Text('Lớp học')), body: ListView.builder(padding: const EdgeInsets.all(16), itemCount: 5, itemBuilder: (c, i) => Card(margin: const EdgeInsets.only(bottom: 12), child: ListTile(leading: CircleAvatar(backgroundColor: AppColors.primaryLight, child: Text('${i+1}')), title: Text('Lớp ${i+1} - Cơ bản'), subtitle: Text('${10+i*3} học viên'), trailing: const Icon(Icons.chevron_right)))));
}