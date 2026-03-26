import 'api_client.dart';

class PracticeService {
  final ApiClient _apiClient = ApiClient();

  /// Start a practice session
  Future<Map<String, dynamic>> startSession(String lessonId) async {
    final response = await _apiClient.post('/practice/session/start', body: {
      'lessonId': lessonId,
    });
    return response as Map<String, dynamic>;
  }

  /// End a practice session
  Future<void> endSession(String sessionId) async {
    await _apiClient.post('/practice/session/end', body: {
      'sessionId': sessionId,
    });
  }

  /// Get practice history for a specific sign
  Future<List<dynamic>> getSignHistory(String signId) async {
    final response = await _apiClient.get('/practice/history/$signId');
    return response is List ? response : [];
  }

  /// Start a mini-game session
  Future<Map<String, dynamic>> startGame(String gameType) async {
    final response = await _apiClient.post('/games/start', body: {
      'gameType': gameType,
    });
    return response as Map<String, dynamic>;
  }

  /// Complete a game session to earn points/rewards
  Future<Map<String, dynamic>> completeGame(String gameId, int score, int duration) async {
    final response = await _apiClient.post('/games/complete', body: {
      'gameId': gameId,
      'score': score,
      'durationSeconds': duration,
    });
    return response as Map<String, dynamic>;
  }
}
