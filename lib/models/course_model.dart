import 'lesson_model.dart';

class CourseModel {
  final String id;
  final String title;
  final String description;
  final String level;
  final String topic;
  final String image;
  final int totalLessons;
  final List<LessonModel> lessons;

  CourseModel({
    required this.id,
    required this.title,
    required this.description,
    required this.level,
    required this.topic,
    required this.image,
    required this.totalLessons,
    this.lessons = const [],
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      level: json['level'] ?? 'Người mới bắt đầu',
      topic: json['topic'] ?? 'Chung',
      image: json['image'] ?? 'assets/images/courses/default.jpg',
      totalLessons: json['totalLessons'] ?? 0,
      lessons: (json['lessons'] as List<dynamic>?)
              ?.map((e) => LessonModel.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'level': level,
      'topic': topic,
      'image': image,
      'totalLessons': totalLessons,
      'lessons': lessons.map((e) => e.toJson()).toList(),
    };
  }
}
