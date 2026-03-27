// NOTE: Gemini AI calls have been moved to the backend (Python AI + .NET).
// This file is kept for reference only. Do NOT use the client-side Gemini
// service in production — API keys should never be in mobile app source code.
//
// Real-time coaching: Python AI → /analyze/realtime-smart
// Post-practice feedback: .NET Backend → PracticeService.ReportResultAsync

import 'dart:typed_data';

/// @deprecated Use backend Gemini integration instead.
/// See: practice_service.dart → analyzeRealtime()
class GeminiService {
  // API key removed — use backend services instead
  static const String _deprecationNotice =
      'GeminiService is deprecated. Use PracticeService.analyzeRealtime() for real-time AI feedback.';

  GeminiService() {
    // ignore: avoid_print
    print(_deprecationNotice);
  }

  Future<SignLanguageResult> analyzeSignLanguage(Uint8List imageBytes) async {
    throw UnimplementedError(_deprecationNotice);
  }

  Future<String> explainSign(String signName) async {
    throw UnimplementedError(_deprecationNotice);
  }

  Future<PracticeFeedback> getPracticeFeedback({
    required Uint8List imageBytes,
    required String targetSign,
  }) async {
    throw UnimplementedError(_deprecationNotice);
  }
}

class SignLanguageResult {
  final String detectedSign;
  final bool isCorrect;
  final int accuracy;
  final String feedback;
  final List<String> corrections;
  final String tips;

  SignLanguageResult({
    required this.detectedSign,
    required this.isCorrect,
    required this.accuracy,
    required this.feedback,
    required this.corrections,
    required this.tips,
  });
}

class PracticeFeedback {
  final bool matchesTarget;
  final bool handPositionCorrect;
  final int score;
  final String suggestion;

  PracticeFeedback({
    required this.matchesTarget,
    required this.handPositionCorrect,
    required this.score,
    required this.suggestion,
  });
}
