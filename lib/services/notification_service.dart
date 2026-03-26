import 'api_client.dart';

class NotificationService {
  final ApiClient _apiClient = ApiClient();

  /// Get paginated notifications
  Future<List<dynamic>> getNotifications({int page = 1, int pageSize = 20}) async {
    final response = await _apiClient.get('/notifications?page=$page&pageSize=$pageSize');
    if (response is Map<String, dynamic> && response.containsKey('items')) {
      return response['items'] as List<dynamic>;
    }
    return response is List ? response : [];
  }

  /// Mark a specific notification as read
  Future<void> markAsRead(String notificationId) async {
    await _apiClient.put('/notifications/$notificationId/read');
  }
}
