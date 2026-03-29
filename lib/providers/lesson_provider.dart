import 'package:flutter/material.dart';
import '../services/course_service.dart';
import '../models/course_model.dart';
import '../models/lesson_model.dart';

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
  final List<String> _mistakes = [];

  int get currentLesson => _currentLesson;
  int get currentQuestion => _currentQuestion;
  int get correctAnswers => _correctAnswers;
  int get totalQuestions => _totalQuestions;
  List<String> get completedLessons => _completedLessons;
  List<String> get mistakes => _mistakes;
  double get progress => _totalQuestions > 0 ? _correctAnswers / _totalQuestions : 0;

  /// Fetch courses from API
  Future<void> loadCourses({String? search, String? level}) async {
    _isLoading = true;
    notifyListeners();
    try {
      _courses = await _courseService.getCourses(search: search, level: level);
      _cachedLessons = null; // Clear cache on new load
    } catch (e) {
      debugPrint('Error loading courses: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<Map<String, dynamic>>? _cachedLessons;

  // New states for real Backend AI Data integration
  List<LessonModel> _activeLessons = [];
  bool _isLoadingDetails = false;

  List<LessonModel> get activeLessons => _activeLessons;
  bool get isLoadingDetails => _isLoadingDetails;

  /// Loads the actual detailed lessons with their vocabulary Signs
  Future<void> loadCourseDetails(String courseId) async {
    _isLoadingDetails = true;
    _activeLessons = [];
    notifyListeners();
    
    try {
      final lessonsBrief = await _courseService.getLessonsForCourse(courseId);
      
      // Fetch details for each lesson concurrently to get nested Signs
      final futures = lessonsBrief.map((l) => _courseService.getLesson(l.id));
      _activeLessons = await Future.wait(futures);
      
    } catch(e) {
      debugPrint('Error loading course detailed signs: $e');
    } finally {
      _isLoadingDetails = false;
      notifyListeners();
    }
  }

  /// Maps the real API CourseModels into the Map<String, dynamic> format 
  /// that the existing UI (lesson_screen.dart, home_screen.dart) expects.
  List<Map<String, dynamic>> get lessons {
    if (_courses.isEmpty) {
      return [];
    }
    if (_cachedLessons != null && _cachedLessons!.length == _courses.length) {
      return _cachedLessons!;
    }
    _cachedLessons = _courses.map((course) => {
      'id': course.id,
      'title': course.title,
      'icon': course.image.contains('assets') ? course.image : '📚',
      'lessons': course.totalLessons,
      'completed': 0,
      'level': course.level,
      'duration': 0,
      'topic': course.topic,
    }).toList();
    return _cachedLessons!;
  }

  void startLesson(int index) {
    _currentLesson = index;
    _currentQuestion = 0;
    _correctAnswers = 0;
    _mistakes.clear();
    
    if (_courses.isNotEmpty && index >= 0 && index < _courses.length) {
      final courseId = _courses[index].id;
      loadCourseDetails(courseId);
    }
    notifyListeners();
  }

  void answerCorrect() {
    _correctAnswers++;
    _currentQuestion++;
    notifyListeners();
  }

  void answerWrong({String? feedback}) {
    _currentQuestion++;
    if (feedback != null && feedback.isNotEmpty && !_mistakes.contains(feedback)) {
      _mistakes.add(feedback);
    }
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
    _mistakes.clear();
    notifyListeners();
  }
}
