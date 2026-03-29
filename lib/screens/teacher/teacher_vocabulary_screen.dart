import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/course_service.dart';
import '../../models/course_model.dart';
import '../../models/lesson_model.dart';
import '../../utils/app_colors.dart';

class TeacherVocabularyScreen extends StatefulWidget {
  const TeacherVocabularyScreen({super.key});

  @override
  State<TeacherVocabularyScreen> createState() => _TeacherVocabularyScreenState();
}

class _TeacherVocabularyScreenState extends State<TeacherVocabularyScreen> {
  final CourseService _courseService = CourseService();
  final ImagePicker _picker = ImagePicker();

  List<CourseModel> _courses = [];
  List<LessonModel> _lessons = [];
  CourseModel? _selectedCourse;
  LessonModel? _selectedLesson;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  Future<void> _loadCourses() async {
    try {
      final courses = await _courseService.getCourses();
      setState(() {
        _courses = courses;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi tải danh sách: $e'), backgroundColor: Colors.red));
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadLessons(CourseModel course) async {
    setState(() {
      _selectedCourse = course;
      _selectedLesson = null;
      _lessons = [];
      _isLoading = true;
    });
    try {
      final lessons = await _courseService.getLessonsForCourse(course.id);
      setState(() {
        _lessons = lessons;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi tải bài học: $e'), backgroundColor: Colors.red));
      setState(() => _isLoading = false);
    }
  }

  Future<void> _selectLesson(LessonModel lesson) async {
    // Need full lesson detail to get signs
    setState(() => _isLoading = true);
    try {
      final detailedLesson = await _courseService.getLesson(lesson.id);
      setState(() {
        _selectedLesson = detailedLesson;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi tải từ vựng: $e'), backgroundColor: Colors.red));
      setState(() => _isLoading = false);
    }
  }

  Future<void> _uploadVideo(String signId, String signWord) async {
    try {
      // Prompt user to pick/record video
      final XFile? video = await _picker.pickVideo(
        source: ImageSource.gallery,
      );

      if (video == null) return;

      // Show loading overlay
      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );

      // Upload
      await _courseService.uploadSignReferenceVideo(signId, video.path);
      
      // Close overlay
      if (!mounted) return;
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Thành công gửi video cho từ "$signWord". Hệ thống đang xử lý!'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 4),
        )
      );
    } catch (e) {
      if (!mounted) return;
      // Close overlay early if error
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi tải lên: $e'), backgroundColor: Colors.red)
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: const Text('Kho Dữ Liệu AI'),
        leading: BackButton(onPressed: () => context.go('/teacher-home')),
      ),
      body: _isLoading && _courses.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Filter Section
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.white,
                  child: Column(
                    children: [
                      DropdownButtonFormField<CourseModel>(
                        decoration: const InputDecoration(labelText: 'Chọn khóa học', border: OutlineInputBorder()),
                        value: _courses.contains(_selectedCourse) ? _selectedCourse : null,
                        items: _courses.map((c) => DropdownMenuItem(value: c, child: Text(c.title))).toList(),
                        onChanged: (val) { if (val != null) _loadLessons(val); },
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<LessonModel>(
                        decoration: const InputDecoration(labelText: 'Chọn bài học', border: OutlineInputBorder()),
                        value: _lessons.contains(_selectedLesson) ? _selectedLesson : null,
                        items: _lessons.map((l) => DropdownMenuItem(value: l, child: Text(l.title))).toList(),
                        onChanged: (val) { if (val != null) _selectLesson(val); },
                        disabledHint: const Text('Vui lòng chọn khóa học trước'),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // Signs List Section
                Expanded(
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _selectedLesson == null
                          ? const Center(child: Text('Hãy chọn 1 bài học để xem danh sách từ vựng', style: TextStyle(color: AppColors.textSecondary)))
                          : _selectedLesson!.signs.isEmpty
                              ? const Center(child: Text('Bài học này chưa có từ vựng nào.'))
                              : ListView.builder(
                                  padding: const EdgeInsets.all(16),
                                  itemCount: _selectedLesson!.signs.length,
                                  itemBuilder: (context, index) {
                                    final sign = _selectedLesson!.signs[index];
                                    final bool hasReference = sign.referenceKeypointData.isNotEmpty;

                                    return Card(
                                      margin: const EdgeInsets.only(bottom: 12),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      child: ListTile(
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                        title: Text(sign.word, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                        subtitle: Text(
                                          hasReference ? 'Trạng thái: Đã có Data mẫu AI' : 'Trạng thái: THIẾU DATA MẪU AI',
                                          style: TextStyle(color: hasReference ? Colors.green : Colors.red, fontWeight: FontWeight.bold, fontSize: 12)
                                        ),
                                        trailing: ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors.secondary,
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                                          ),
                                          icon: const Icon(Icons.video_call),
                                          label: const Text('Bơm Video'),
                                          onPressed: () => _uploadVideo(sign.id, sign.word),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                ),
              ],
            ),
    );
  }
}
