import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
class TeacherLessonsScreen extends StatelessWidget {
  const TeacherLessonsScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(backgroundColor: AppColors.primary, foregroundColor: Colors.white, title: const Text('Quản lý bài học')), floatingActionButton: FloatingActionButton(backgroundColor: AppColors.primary, child: const Icon(Icons.add, color: Colors.white), onPressed: (){}), body: ListView.builder(padding: const EdgeInsets.all(16), itemCount: 8, itemBuilder: (c, i) => Card(margin: const EdgeInsets.only(bottom: 8), child: ListTile(leading: CircleAvatar(backgroundColor: AppColors.primaryLight, child: Text('${i+1}')), title: Text('Bài ${i+1}'), subtitle: const Text('Đã xuất bản'), trailing: PopupMenuButton(itemBuilder: (_) => [const PopupMenuItem(child: Text('Sửa')), const PopupMenuItem(child: Text('Xóa'))])))));
}