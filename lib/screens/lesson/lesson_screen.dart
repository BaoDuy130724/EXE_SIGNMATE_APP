import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/lesson_provider.dart';
import '../../utils/app_colors.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/bottom_nav_bar.dart';

class LessonScreen extends StatefulWidget {
  const LessonScreen({super.key});
  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  String _selectedTopic = 'Tất cả';
  String _selectedLevel = 'Tất cả';
  String _selectedDuration = 'Tất cả';

  final topics = ['Tất cả', 'Ngôn ngữ', 'Giao tiếp', 'Từ vựng'];
  final levels = ['Tất cả', 'Cơ bản', 'Trung cấp', 'Nâng cao'];
  final durations = ['Tất cả', '≤10 phút', '11-15 phút'];

  List<Map<String, dynamic>> _filterLessons(List<Map<String, dynamic>> all) {
    return all.where((l) {
      if (_selectedTopic != 'Tất cả' && l['topic'] != _selectedTopic) return false;
      if (_selectedLevel != 'Tất cả' && l['level'] != _selectedLevel) return false;
      if (_selectedDuration != 'Tất cả') {
        final d = l['duration'] as int;
        if (_selectedDuration == '≤10 phút' && d > 10) return false;
        if (_selectedDuration == '11-15 phút' && (d <= 10 || d > 15)) return false;
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final lp = context.watch<LessonProvider>();
    final filtered = _filterLessons(lp.lessons);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Thư viện bài học'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Filters
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Topic filter
                _filterRow('Chủ đề', topics, _selectedTopic, (v) => setState(() => _selectedTopic = v)),
                const SizedBox(height: 8),
                // Level filter
                _filterRow('Cấp độ', levels, _selectedLevel, (v) => setState(() => _selectedLevel = v)),
                const SizedBox(height: 8),
                // Duration filter
                _filterRow('Thời lượng', durations, _selectedDuration, (v) => setState(() => _selectedDuration = v)),
              ],
            ),
          ),

          // Result count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text(
                  '${filtered.length} bài học',
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                ),
                const Spacer(),
                if (_selectedTopic != 'Tất cả' || _selectedLevel != 'Tất cả' || _selectedDuration != 'Tất cả')
                  GestureDetector(
                    onTap: () => setState(() {
                      _selectedTopic = 'Tất cả';
                      _selectedLevel = 'Tất cả';
                      _selectedDuration = 'Tất cả';
                    }),
                    child: const Text('Xóa bộ lọc', style: TextStyle(color: AppColors.primary, fontSize: 13)),
                  ),
              ],
            ),
          ),

          // Lessons list
          Expanded(
            child: filtered.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('📭', style: TextStyle(fontSize: 48)),
                        SizedBox(height: 8),
                        Text('Không có bài học phù hợp', style: TextStyle(color: AppColors.textSecondary)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final lesson = filtered[index];
                      final originalIndex = lp.lessons.indexOf(lesson);
                      final total = (lesson['lessons'] ?? 0) as int;
                      final progress = total > 0 ? (lesson['completed'] ?? 0) / total : 0.0;

                      return CustomCard(
                        onTap: () {
                          lp.startLesson(originalIndex);
                          context.go('/lesson-detail');
                        },
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: AppColors.primaryLight,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Center(
                                child: lesson['icon'].toString().contains('assets/')
                                    ? Image.asset(
                                        lesson['icon'], 
                                        height: 32, 
                                        width: 32, 
                                        fit: BoxFit.contain,
                                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.menu_book, size: 32, color: AppColors.primary)
                                      )
                                    : Text(lesson['icon'], style: const TextStyle(fontSize: 32)),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          lesson['title'],
                                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: progress > 0
                                              ? AppColors.primaryLight
                                              : AppColors.divider.withValues(alpha: 0.5),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          progress >= 1.0 ? '✅ Xong' : '${(progress * 100).toInt()}%',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: progress > 0 ? AppColors.primary : AppColors.textLight,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      _tag(lesson['level'], AppColors.primaryLight, AppColors.primaryDark),
                                      const SizedBox(width: 6),
                                      _tag('${lesson['duration']} phút', AppColors.warningLight, AppColors.warning),
                                      const SizedBox(width: 6),
                                      _tag(lesson['topic'], AppColors.infoLight, AppColors.info),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: LinearProgressIndicator(
                                      value: progress,
                                      minHeight: 5,
                                      backgroundColor: AppColors.divider,
                                      valueColor: AlwaysStoppedAnimation(
                                        progress >= 1.0 ? AppColors.success : AppColors.primary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 1),
    );
  }

  Widget _filterRow(String label, List<String> options, String selected, ValueChanged<String> onSelect) {
    return Row(
      children: [
        SizedBox(
          width: 70,
          child: Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
        ),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: options.map((opt) {
                final isSelected = selected == opt;
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: GestureDetector(
                    onTap: () => onSelect(opt),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected ? AppColors.primary : AppColors.divider,
                        ),
                      ),
                      child: Text(
                        opt,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          color: isSelected ? Colors.white : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _tag(String text, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 10, color: fg, fontWeight: FontWeight.w500),
      ),
    );
  }
}