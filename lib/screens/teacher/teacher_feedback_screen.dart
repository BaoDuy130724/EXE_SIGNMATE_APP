import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/teacher_provider.dart';
import '../../services/teacher_service.dart';
import '../../utils/app_colors.dart';

class TeacherFeedbackScreen extends StatefulWidget {
  const TeacherFeedbackScreen({super.key});

  @override
  State<TeacherFeedbackScreen> createState() => _TeacherFeedbackScreenState();
}

class _TeacherFeedbackScreenState extends State<TeacherFeedbackScreen> {
  final TeacherService _teacherService = TeacherService();
  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TeacherProvider>().loadStudents();
    });
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final teacher = context.watch<TeacherProvider>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: const Text('Nhận xét học viên'),
      ),
      body: teacher.isLoading
          ? const Center(child: CircularProgressIndicator())
          : teacher.students.isEmpty
              ? const Center(child: Text('Chưa có học viên nào', style: TextStyle(color: AppColors.textSecondary)))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: teacher.students.length,
                  itemBuilder: (c, i) {
                    final student = teacher.students[i];
                    final name = student['fullName']?.toString() ?? 'Học viên';
                    final studentId = student['studentId']?.toString() ?? '';
                    _controllers.putIfAbsent(studentId, () => TextEditingController());
                    
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: AppColors.primaryLight,
                                  radius: 20,
                                  child: Text(
                                    name.isNotEmpty ? name[0].toUpperCase() : 'U',
                                    style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(child: Text(name, style: const TextStyle(fontWeight: FontWeight.bold))),
                              ],
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: _controllers[studentId],
                              maxLines: 2,
                              decoration: const InputDecoration(
                                hintText: 'Nhập nhận xét...',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton(
                                onPressed: () async {
                                  final content = _controllers[studentId]?.text.trim() ?? '';
                                  if (content.isEmpty) return;
                                  try {
                                    await _teacherService.addComment(studentId, content);
                                    _controllers[studentId]?.clear();
                                    if (mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Đã gửi nhận xét!'), backgroundColor: AppColors.success),
                                      );
                                    }
                                  } catch (e) {
                                    if (mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Lỗi: $e'), backgroundColor: Colors.red),
                                      );
                                    }
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text('Gửi'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}