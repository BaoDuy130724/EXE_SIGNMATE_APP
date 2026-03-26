import 'user_model.dart';

class ClassModel {
  final String id;
  final String name;
  final String teacherId;
  final String teacherName;
  final String schedule;
  final int studentCount;
  final String status;
  final List<UserModel> students;

  ClassModel({
    required this.id,
    required this.name,
    required this.teacherId,
    required this.teacherName,
    required this.schedule,
    required this.studentCount,
    required this.status,
    this.students = const [],
  });

  factory ClassModel.fromJson(Map<String, dynamic> json) {
    return ClassModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      teacherId: json['teacherId']?.toString() ?? '',
      teacherName: json['teacherName'] ?? '',
      schedule: json['schedule'] ?? '',
      studentCount: json['studentCount'] ?? 0,
      status: json['status'] ?? 'Active',
      students: (json['students'] as List<dynamic>?)
              ?.map((e) => UserModel.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'teacherId': teacherId,
      'teacherName': teacherName,
      'schedule': schedule,
      'studentCount': studentCount,
      'status': status,
      'students': students.map((e) => e.toJson()).toList(),
    };
  }
}
