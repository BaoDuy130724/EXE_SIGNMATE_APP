import 'sign_model.dart';

class LessonModel {
  final String id;
  final String title;
  final String type;
  final String duration;
  final String topic;
  final String level;
  final String image;
  final String content;
  final List<SignModel> signs;

  LessonModel({
    required this.id,
    required this.title,
    required this.type,
    required this.duration,
    required this.topic,
    required this.level,
    required this.image,
    required this.content,
    this.signs = const [],
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      type: json['type'] ?? 'basic',
      duration: json['duration'] ?? '5 phút',
      topic: json['topic'] ?? 'Chung',
      level: json['level'] ?? 'Người mới bắt đầu',
      image: json['image'] ?? 'assets/images/lessons/default.jpg',
      content: json['content'] ?? '',
      signs: (json['signs'] as List<dynamic>?)
              ?.map((e) => SignModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'type': type,
      'duration': duration,
      'topic': topic,
      'level': level,
      'image': image,
      'content': content,
      'signs': signs.map((e) => e.toJson()).toList(),
    };
  }
}
