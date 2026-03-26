class LessonModel {
  final String id;
  final String title;
  final String type;
  final String duration;
  final String topic;
  final String level;
  final String image;
  final String content;

  LessonModel({
    required this.id,
    required this.title,
    required this.type,
    required this.duration,
    required this.topic,
    required this.level,
    required this.image,
    required this.content,
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
    };
  }
}
