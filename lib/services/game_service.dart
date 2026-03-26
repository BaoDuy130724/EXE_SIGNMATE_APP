import 'api_client.dart';

class GameService {
  final ApiClient _apiClient = ApiClient();

  Future<String> startGame(String gameType) async {
    final response = await _apiClient.post('/games/start', body: {'gameType': gameType});
    return response['sessionId'] as String;
  }

  Future<Map<String, dynamic>> completeGame(String sessionId, int score) async {
    final response = await _apiClient.post('/games/complete', body: {
      'sessionId': sessionId,
      'score': score
    });
    return response as Map<String, dynamic>;
  }
}
