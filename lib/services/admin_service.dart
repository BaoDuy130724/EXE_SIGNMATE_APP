import 'api_client.dart';

class AdminService {
  final ApiClient _apiClient = ApiClient();

  Future<Map<String, dynamic>> getSystemDashboard() async {
    final response = await _apiClient.get('/admin/dashboard');
    return response as Map<String, dynamic>;
  }
}
