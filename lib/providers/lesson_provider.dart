import 'package:flutter/material.dart';

class LessonProvider extends ChangeNotifier {
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

  final List<Map<String, dynamic>> lessons = [
    {'id': '1', 'title': 'Bảng chữ cái', 'icon': '🔤', 'lessons': 26, 'completed': 10, 'level': 'Cơ bản', 'duration': 15, 'topic': 'Ngôn ngữ'},
    {'id': '2', 'title': 'Số đếm', 'icon': '🔢', 'lessons': 20, 'completed': 5, 'level': 'Cơ bản', 'duration': 10, 'topic': 'Ngôn ngữ'},
    {'id': '3', 'title': 'Chào hỏi', 'icon': '👋', 'lessons': 15, 'completed': 3, 'level': 'Cơ bản', 'duration': 10, 'topic': 'Giao tiếp'},
    {'id': '4', 'title': 'Gia đình', 'icon': '👨‍👩‍👧', 'lessons': 12, 'completed': 0, 'level': 'Trung cấp', 'duration': 15, 'topic': 'Giao tiếp'},
    {'id': '5', 'title': 'Màu sắc', 'icon': '🎨', 'lessons': 10, 'completed': 0, 'level': 'Cơ bản', 'duration': 8, 'topic': 'Từ vựng'},
    {'id': '6', 'title': 'Động vật', 'icon': '🐾', 'lessons': 15, 'completed': 0, 'level': 'Trung cấp', 'duration': 12, 'topic': 'Từ vựng'},
    {'id': '7', 'title': 'Thức ăn', 'icon': '🍔', 'lessons': 12, 'completed': 0, 'level': 'Trung cấp', 'duration': 10, 'topic': 'Từ vựng'},
    {'id': '8', 'title': 'Cảm xúc', 'icon': '😊', 'lessons': 10, 'completed': 0, 'level': 'Nâng cao', 'duration': 15, 'topic': 'Giao tiếp'},
  ];

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
