import 'api_client.dart';
import '../models/dashboard_summary_model.dart';
import '../models/progress_stats_model.dart';

class DashboardService {
  final ApiClient _apiClient = ApiClient();

  /// Retrieves the main dashboard summary including streak, accuracy, and suggested lesson
  Future<DashboardSummaryModel> getSummary() async {
    final response = await _apiClient.get('/dashboard');
    return DashboardSummaryModel.fromJson(response);
  }

  /// Retrieves detailed progression stats, accuracy by topic, and mastered signs
  Future<ProgressStatsModel> getProgressStats() async {
    final response = await _apiClient.get('/dashboard/progress');
    return ProgressStatsModel.fromJson(response);
  }
}
