import 'api_client.dart';

class SubscriptionService {
  final ApiClient _apiClient = ApiClient();

  Future<List<Map<String, dynamic>>> getPlans() async {
    final response = await _apiClient.get('/plans', requiresAuth: false);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<Map<String, dynamic>> subscribe(String planId) async {
    final response = await _apiClient.post('/subscription/subscribe', body: {'planId': planId});
    return response as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>?> getMySubscription() async {
    try {
      final response = await _apiClient.get('/subscription/me');
      return response as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }
}
