import 'class_model.dart';

class CenterModel {
  final String id;
  final String name;
  final String address;
  final String contactEmail;
  final String contactPhone;
  final String status;
  final int studentCount;
  final int teacherCount;
  final List<ClassModel> classes;

  CenterModel({
    required this.id,
    required this.name,
    required this.address,
    required this.contactEmail,
    required this.contactPhone,
    required this.status,
    required this.studentCount,
    required this.teacherCount,
    this.classes = const [],
  });

  factory CenterModel.fromJson(Map<String, dynamic> json) {
    return CenterModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      contactEmail: json['contactEmail'] ?? '',
      contactPhone: json['contactPhone'] ?? '',
      status: json['status'] ?? 'Active',
      studentCount: json['studentCount'] ?? 0,
      teacherCount: json['teacherCount'] ?? 0,
      classes: (json['classes'] as List<dynamic>?)
              ?.map((e) => ClassModel.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'contactEmail': contactEmail,
      'contactPhone': contactPhone,
      'status': status,
      'studentCount': studentCount,
      'teacherCount': teacherCount,
      'classes': classes.map((e) => e.toJson()).toList(),
    };
  }
}
