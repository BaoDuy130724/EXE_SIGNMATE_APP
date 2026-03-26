import 'lesson_model.dart';

class DashboardSummaryModel {
  final double averageAccuracy;
  final int currentStreak;
  final LessonModel? suggestedLesson;

  DashboardSummaryModel({
    required this.averageAccuracy,
    required this.currentStreak,
    this.suggestedLesson,
  });

  factory DashboardSummaryModel.fromJson(Map<String, dynamic> json) {
    return DashboardSummaryModel(
      averageAccuracy: (json['averageAccuracy'] as num?)?.toDouble() ?? 0.0,
      currentStreak: json['currentStreak'] as int? ?? 0,
      suggestedLesson: json['suggestedLesson'] != null
          ? LessonModel.fromJson(json['suggestedLesson'] as Map<String, dynamic>)
          : null,
    );
  }
}
