import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/center_provider.dart';
import '../../utils/app_colors.dart';

class CenterClassDetailScreen extends StatefulWidget {
  const CenterClassDetailScreen({super.key});

  @override
  State<CenterClassDetailScreen> createState() => _CenterClassDetailScreenState();
}

class _CenterClassDetailScreenState extends State<CenterClassDetailScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final center = context.watch<CenterProvider>();
    final cls = center.selectedClass;

    final filteredStudents = cls.students.where((s) {
      if (_searchQuery.isEmpty) return true;
      return s.name.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: Text(cls.name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.go('/center-classes'),
        ),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (v) => setState(() => _searchQuery = v),
              decoration: InputDecoration(
                hintText: 'Tìm học viên...',
                hintStyle: const TextStyle(color: AppColors.textLight),
                prefixIcon: const Icon(Icons.search, color: AppColors.textLight),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),

          // Student list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filteredStudents.length,
              itemBuilder: (context, index) {
                final student = filteredStudents[index];
                return _studentCard(student);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _studentCard(CenterStudent student) {
    final accuracyColor = student.accuracy >= 70
        ? AppColors.success
        : student.accuracy >= 50
            ? AppColors.warning
            : AppColors.error;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name row
          Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.primaryLight,
                child: Text(
                  student.name.isNotEmpty ? student.name[0].toUpperCase() : 'U',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        student.name,
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                      ),
                    ),
                    if (student.isOnline)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.success,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Tags row
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              // Accuracy badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: accuracyColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${student.accuracy}%\nChính xác',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600, height: 1.3),
                ),
              ),
              // Topic pills
              ...student.topics.map((topic) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$topic\nCo.bản',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.primaryDark, fontSize: 10, height: 1.3),
                ),
              )),
              // Weekly practice
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.warningLight,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${student.weeklyPractice}x/ tuần\nTrun.ch',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.warning, fontSize: 10, fontWeight: FontWeight.w500, height: 1.3),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
