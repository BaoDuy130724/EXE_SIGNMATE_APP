class ProgressStatsModel {
  final double overallAccuracy;
  final int totalLessonsCompleted;
  final int totalSignsMastered;
  final List<String> weakTopics;
  final Map<String, int> accuracyByTopic;

  ProgressStatsModel({
    required this.overallAccuracy,
    required this.totalLessonsCompleted,
    required this.totalSignsMastered,
    required this.weakTopics,
    required this.accuracyByTopic,
  });

  factory ProgressStatsModel.fromJson(Map<String, dynamic> json) {
    return ProgressStatsModel(
      overallAccuracy: (json['overallAccuracy'] as num?)?.toDouble() ?? 0.0,
      totalLessonsCompleted: json['totalLessonsCompleted'] as int? ?? 0,
      totalSignsMastered: json['totalSignsMastered'] as int? ?? 0,
      weakTopics: (json['weakTopics'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      accuracyByTopic: (json['accuracyByTopic'] as Map<String, dynamic>?)?.map((k, v) => MapEntry(k, (v as num).toInt())) ?? {},
    );
  }
}
