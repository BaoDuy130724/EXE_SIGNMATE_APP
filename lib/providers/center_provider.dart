import 'package:flutter/material.dart';

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
  String _centerName = 'Trung Tâm';
  int _selectedClassIndex = 0;

  String get centerName => _centerName;
  int get selectedClassIndex => _selectedClassIndex;

  // Stats
  int get totalClasses => _classes.length;
  int get totalStudents => _classes.fold(0, (sum, c) => sum + c.studentCount);
  int get totalXp => 14650;
  int get activeStudents => 80;
  int get totalSeats => 150;
  int get avgAccuracy => 71;
  int get totalPracticeMinutes => 465;
  int get totalFeeCollected => 6320000;

  // Report data
  int get newStudentsThisMonth => 3;
  int get completionRate => 76;
  int get reportAccuracy => 71;

  final List<CenterClass> _classes = const [
    CenterClass(
      name: 'Lớp VSL Trung Cấp 2',
      level: 'Trung cấp',
      studentCount: 25,
      completionPercent: 72,
      students: [
        CenterStudent(name: 'Minh Anh Nguyen', accuracy: 85, topics: ['Chính xác', 'Cảm xúc', 'Gia đình'], weeklyPractice: 3, isOnline: true),
        CenterStudent(name: 'An Le', accuracy: 72, topics: ['Chính xác', 'Gia đình', 'Cơ bản'], weeklyPractice: 3, isOnline: false),
        CenterStudent(name: 'Hồng Phạm', accuracy: 45, topics: ['Chính xác', 'Gia đình', 'Cơ bản'], weeklyPractice: 3, isOnline: true),
        CenterStudent(name: 'Tuấn Trần', accuracy: 91, topics: ['Chính xác', 'Cảm xúc', 'Gia đình'], weeklyPractice: 5, isOnline: false),
        CenterStudent(name: 'Linh Đỗ', accuracy: 68, topics: ['Cơ bản', 'Gia đình'], weeklyPractice: 2, isOnline: true),
      ],
    ),
    CenterClass(
      name: 'Lớp VSL Cơ Bản 1',
      level: 'Cơ bản',
      studentCount: 20,
      completionPercent: 78,
      students: [
        CenterStudent(name: 'Bảo Nguyễn', accuracy: 78, topics: ['Cơ bản', 'Chào hỏi'], weeklyPractice: 4, isOnline: true),
        CenterStudent(name: 'Mai Trần', accuracy: 65, topics: ['Cơ bản', 'Chào hỏi'], weeklyPractice: 2, isOnline: false),
        CenterStudent(name: 'Đức Lê', accuracy: 82, topics: ['Cơ bản', 'Số đếm'], weeklyPractice: 5, isOnline: true),
      ],
    ),
    CenterClass(
      name: 'Lớp VSL Trung Cấp 2',
      level: 'Trung cấp',
      studentCount: 30,
      completionPercent: 73,
      students: [
        CenterStudent(name: 'Hương Phạm', accuracy: 88, topics: ['Chính xác', 'Cảm xúc'], weeklyPractice: 4, isOnline: false),
        CenterStudent(name: 'Khoa Vũ', accuracy: 55, topics: ['Cơ bản', 'Gia đình'], weeklyPractice: 1, isOnline: true),
      ],
    ),
    CenterClass(
      name: 'Lớp VSL Nâng Cao',
      level: 'Nâng cao',
      studentCount: 15,
      completionPercent: 85,
      students: [
        CenterStudent(name: 'Thảo Ngô', accuracy: 95, topics: ['Chính xác', 'Nghề nghiệp', 'Y tế'], weeklyPractice: 6, isOnline: true),
        CenterStudent(name: 'Quang Hoàng', accuracy: 79, topics: ['Chính xác', 'Gia đình', 'Cảm xúc'], weeklyPractice: 3, isOnline: false),
      ],
    ),
  ];

  List<CenterClass> get classes => _classes;
  CenterClass get selectedClass => _classes[_selectedClassIndex];

  List<CenterStudent> get allStudents {
    final all = <CenterStudent>[];
    for (final c in _classes) {
      all.addAll(c.students);
    }
    return all;
  }

  void selectClass(int index) {
    _selectedClassIndex = index;
    notifyListeners();
  }

  void setCenterName(String name) {
    _centerName = name;
    notifyListeners();
  }
}
