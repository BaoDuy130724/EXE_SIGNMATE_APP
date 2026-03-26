import 'package:flutter/material.dart';
import '../services/center_service.dart';

class CenterStudent {
  final String name;
  final int accuracy;
  final List<String> topics;
  final int weeklyPractice;
  final bool isOnline;

  const CenterStudent({
    required this.name,
    required this.accuracy,
    required this.topics,
    required this.weeklyPractice,
    this.isOnline = false,
  });
}

class CenterClass {
  final String name;
  final String level;
  final int studentCount;
  final int completionPercent;
  final List<CenterStudent> students;

  const CenterClass({
    required this.name,
    required this.level,
    required this.studentCount,
    required this.completionPercent,
    required this.students,
  });
}

class CenterProvider extends ChangeNotifier {
  final CenterService _centerService = CenterService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _centerName = 'Trung Tâm';
  int _selectedClassIndex = 0;

  String get centerName => _centerName;
  int get selectedClassIndex => _selectedClassIndex;

  List<CenterClass> _classes = [];

  Future<void> loadDashboard(String centerId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final center = await _centerService.getCenterDashboard(centerId);
      final apiClasses = await _centerService.getClasses(centerId);

      _centerName = center.name;

      // Map real API data to the UI structure expected by screens
      _classes = apiClasses.map((cls) {
         return CenterClass(
           name: cls.name,
           level: 'N/A', // Assuming level isn't returned from ClassModel yet
           studentCount: cls.studentCount,
           completionPercent: 0, // Should be fetched from analytics API
           students: cls.students.map((student) => CenterStudent(
             name: student.name,
             accuracy: student.practiceAccuracy,
             topics: ['Chung'],
             weeklyPractice: 0, 
             isOnline: false,
           )).toList(),
         );
      }).toList();

      // If API returns no classes, list is empty. No more fallback mocks!
    } catch (e) {
      debugPrint('Error loading center dashboard: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Stats
  int get totalClasses => _classes.length;
  int get totalStudents => _classes.fold(0, (sum, c) => sum + c.studentCount);
  int get totalXp => 0;
  int get activeStudents => 0;
  int get totalSeats => 0;
  int get avgAccuracy => 0;
  int get totalPracticeMinutes => 0;
  int get totalFeeCollected => 0;

  // Report data
  int get newStudentsThisMonth => 0;
  int get completionRate => 0;
  int get reportAccuracy => 0;

  List<CenterClass> get classes => _classes;
  CenterClass get selectedClass => _classes.isNotEmpty ? _classes[_selectedClassIndex] : const CenterClass(name: '', level: '', studentCount: 0, completionPercent: 0, students: []);

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
