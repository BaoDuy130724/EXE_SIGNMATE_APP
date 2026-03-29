import 'package:flutter/material.dart';
import '../services/teacher_service.dart';

class TeacherProvider extends ChangeNotifier {
  final TeacherService _teacherService = TeacherService();
  
  bool _isLoading = false;
  int _totalClasses = 0;
  int _totalStudents = 0;
  List<Map<String, dynamic>> _classes = [];
  List<Map<String, dynamic>> _students = [];

  bool get isLoading => _isLoading;
  int get totalClasses => _totalClasses;
  int get totalStudents => _totalStudents;
  List<Map<String, dynamic>> get classes => _classes;
  List<Map<String, dynamic>> get students => _students;

  Future<void> loadDashboard() async {
    _isLoading = true;
    notifyListeners();

    try {
      final dashboardData = await _teacherService.getTeacherDashboard();
      _totalClasses = dashboardData['totalClasses'] as int? ?? 0;
      _totalStudents = dashboardData['totalStudents'] as int? ?? 0;
    } catch (e) {
      debugPrint('Error loading teacher dashboard: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadClasses() async {
    _isLoading = true;
    notifyListeners();
    try {
      _classes = await _teacherService.getTeacherClasses();
    } catch (e) {
      debugPrint('Error loading teacher classes: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadStudents() async {
    _isLoading = true;
    notifyListeners();
    try {
      _students = await _teacherService.getTeacherStudents();
    } catch (e) {
      debugPrint('Error loading teacher students: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
