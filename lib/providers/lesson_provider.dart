import 'package:flutter/material.dart';
import '../services/course_service.dart';
import '../models/course_model.dart';

class LessonProvider extends ChangeNotifier {
  final CourseService _courseService = CourseService();
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<CourseModel> _courses = [];

  // Gamification states
  int _currentLesson = 0;
  int _currentQuestion = 0;
  int _correctAnswers = 0;
  final int _totalQuestions = 10;
  final List<String> _completedLessons = [];

  int get currentLesson => _currentLesson;
  int get currentQuestion => _currentQuestion;
  int get correctAnswers => _correctAnswers;
  int get totalQuestions => _totalQuestions;
  List<String> get completedLessons => _completedLessons;
  double get progress => _totalQuestions > 0 ? _correctAnswers / _totalQuestions : 0;

  /// Fetch courses from API
  Future<void> loadCourses({String? search, String? level}) async {
    _isLoading = true;
    notifyListeners();
    try {
      _courses = await _courseService.getCourses(search: search, level: level);
    } catch (e) {
      debugPrint('Error loading courses: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Maps the real API CourseModels into the Map<String, dynamic> format 
  /// that the existing UI (lesson_screen.dart, home_screen.dart) expects.
  List<Map<String, dynamic>> get lessons {
    if (_courses.isEmpty) {
      // Return empty list or maintain one hardcoded fallback if desired while loading
      return [];
    }
    return _courses.map((course) => {
      'id': course.id,
      'title': course.title,
      // API might return standard images, if empty use a fallback emoji
      'icon': course.image.contains('assets') ? course.image : '📚',
      'lessons': course.totalLessons,
      'completed': 0, // Should be fetched from Progress API
      'level': course.level,
      'duration': 15, // Default fallback
      'topic': course.topic,
    }).toList();
  }

  void startLesson(int index) {
    _currentLesson = index;
    _currentQuestion = 0;
    _correctAnswers = 0;
    notifyListeners();
  }

  void answerCorrect() {
    _correctAnswers++;
    _currentQuestion++;
    notifyListeners();
  }

  void answerWrong() {
    _currentQuestion++;
    notifyListeners();
  }

  void completeLesson(String lessonId) {
    if (!_completedLessons.contains(lessonId)) {
      _completedLessons.add(lessonId);
    }
    notifyListeners();
  }

  void reset() {
    _currentQuestion = 0;
    _correctAnswers = 0;
    notifyListeners();
  }
}
