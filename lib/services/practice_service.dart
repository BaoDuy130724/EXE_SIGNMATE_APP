import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'api_client.dart';
import '../../utils/api_config.dart';

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

  /// Real-time analysis: send keypoints directly to Python AI service
  Future<Map<String, dynamic>?> analyzeRealtime({
    required String signName,
    required List<List<Map<String, double>>> keypoints,
    required String referenceKeypoints,
  }) async {
    try {
      final payload = {
        'sign_name': signName,
        'user_keypoints_frames': keypoints,
        'reference_keypoints': referenceKeypoints,
      };

      final response = await http.post(
        Uri.parse('${ApiConfig.aiBaseUrl}/analyze/realtime-smart'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      ).timeout(ApiConfig.aiTimeoutDuration);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
      debugPrint('AI realtime error: ${response.statusCode}');
      return null;
    } catch (e) {
      debugPrint('AI realtime exception: $e');
      return null;
    }
  }
}
