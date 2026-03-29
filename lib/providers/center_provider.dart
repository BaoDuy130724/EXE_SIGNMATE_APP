import 'package:flutter/material.dart';
import '../services/center_service.dart';

class CenterStudent {
  final String name;
  final int accuracy;
  final int weeklyPractice;
  final bool isOnline;

  const CenterStudent({
    required this.name,
    required this.accuracy,
    required this.weeklyPractice,
    this.isOnline = false,
  });
}

class CenterClass {
  final String name;
  final int studentCount;
  final List<CenterStudent> students;

  const CenterClass({
    required this.name,
    required this.studentCount,
    required this.students,
  });
}

class CenterProvider extends ChangeNotifier {
  final CenterService _centerService = CenterService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _centerName = 'Trung Tâm';
  int _selectedClassIndex = 0;
  int _totalSeats = 0;
  int _totalStudents = 0;
  int _activeLearners = 0;
  double _averageAccuracy = 0;
  int _totalPracticeMinutes = 0;
  int _newStudentsThisMonth = 0;

  String get centerName => _centerName;
  int get selectedClassIndex => _selectedClassIndex;

  List<CenterClass> _classes = [];

  Future<void> loadDashboard(String centerId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final center = await _centerService.getCenterDashboard(centerId);
      final apiClasses = await _centerService.getClasses(centerId);

      _centerName = center['centerName']?.toString() ?? 'Trung Tâm';
      _totalSeats = center['maxSeats'] as int? ?? 0;
      _totalStudents = center['totalStudents'] as int? ?? 0;
      _activeLearners = center['activeLearners'] as int? ?? 0;
      _averageAccuracy = (center['averageAccuracy'] as num?)?.toDouble() ?? 0.0;
      _totalPracticeMinutes = center['totalPracticeMinutes'] as int? ?? 0;
      _newStudentsThisMonth = center['newStudentsThisMonth'] as int? ?? 0;

      // Map real API data to the UI structure
      _classes = apiClasses.map((cls) {
         return CenterClass(
           name: cls.name,
           studentCount: cls.studentCount,
           students: cls.students.map((student) => CenterStudent(
             name: student.name,
             accuracy: student.practiceAccuracy,
             weeklyPractice: 0,
             isOnline: false,
           )).toList(),
         );
      }).toList();

    } catch (e) {
      debugPrint('Error loading center dashboard: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Stats — all from API
  int get totalClasses => _classes.length;
  int get totalStudents => _totalStudents;
  int get activeStudents => _activeLearners;
  int get totalSeats => _totalSeats;
  int get avgAccuracy => _averageAccuracy.toInt();
  int get totalPracticeMinutes => _totalPracticeMinutes;
  int get newStudentsThisMonth => _newStudentsThisMonth;

  // Report data — derived from dashboard API
  int get completionRate => _totalStudents > 0 && _activeLearners > 0
      ? (_activeLearners * 100 ~/ _totalStudents)
      : 0;
  int get reportAccuracy => _averageAccuracy.toInt();

  List<CenterClass> get classes => _classes;
  CenterClass get selectedClass => _classes.isNotEmpty
      ? _classes[_selectedClassIndex]
      : const CenterClass(name: '', studentCount: 0, students: []);

  List<CenterStudent> get allStudents {
    final all = <CenterStudent>[];
    for (final c in _classes) {
      all.addAll(c.students);
    }
    return all;
  }

  void selectClass(int index) {
    if (index >= 0 && index < _classes.length) {
      _selectedClassIndex = index;
      notifyListeners();
    }
  }

  void setCenterName(String name) {
    _centerName = name;
    notifyListeners();
  }
}
