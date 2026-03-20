import 'dart:typed_data';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  static const String _apiKey =
      'AIzaSyDK0rcB4FBG8PkgM0F-ENRf0kBj3eCBG6M'; // Replace with actual key

  late final GenerativeModel _model;

  GeminiService() {
    _model = GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: _apiKey,
    );
  }

  /// Analyze sign language gesture from camera image
  Future<SignLanguageResult> analyzeSignLanguage(Uint8List imageBytes) async {
    try {
      final prompt = TextPart('''
Bạn là chuyên gia về ngôn ngữ ký hiệu (Sign Language). 
Hãy phân tích hình ảnh này và xác định:
1. Đây là ký hiệu gì trong ngôn ngữ ký hiệu?
2. Ký hiệu này có đúng không? (tư thế tay, hướng bàn tay, vị trí)
3. Nếu sai, hãy chỉ ra lỗi cụ thể và cách sửa.
4. Độ chính xác (0-100%).

Trả lời theo format JSON:
{
  "detected_sign": "tên ký hiệu",
  "is_correct": true/false,
  "accuracy": 85,
  "feedback": "nhận xét chi tiết",
  "corrections": ["lỗi 1", "lỗi 2"],
  "tips": "mẹo cải thiện"
}
''');

      final imagePart = DataPart('image/jpeg', imageBytes);
      final response = await _model.generateContent([
        Content.multi([prompt, imagePart])
      ]);

      final text = response.text ?? '';
      return SignLanguageResult.fromJson(text);
    } catch (e) {
      return SignLanguageResult(
        detectedSign: 'Không xác định',
        isCorrect: false,
        accuracy: 0,
        feedback: 'Lỗi phân tích: $e',
        corrections: [],
        tips: 'Vui lòng thử lại.',
      );
    }
  }

  /// Get explanation for a sign language word
  Future<String> explainSign(String signName) async {
    try {
      final response = await _model.generateContent([
        Content.text('''
Giải thích cách thực hiện ký hiệu "$signName" trong ngôn ngữ ký hiệu Việt Nam.
Bao gồm:
- Tư thế tay
- Hướng bàn tay
- Chuyển động
- Biểu cảm khuôn mặt (nếu cần)
Giải thích ngắn gọn, dễ hiểu.
''')
      ]);
      return response.text ?? 'Không có thông tin.';
    } catch (e) {
      return 'Lỗi: $e';
    }
  }

  /// Real-time feedback during practice
  Future<PracticeFeedback> getPracticeFeedback({
    required Uint8List imageBytes,
    required String targetSign,
  }) async {
    try {
      final prompt = TextPart('''
So sánh ký hiệu trong hình với ký hiệu mục tiêu: "$targetSign"
Đánh giá:
1. Có khớp với ký hiệu "$targetSign" không?
2. Tư thế tay đúng chưa?
3. Điểm số (0-100)
4. Gợi ý cải thiện

Trả lời JSON:
{
  "matches_target": true/false,
  "hand_position_correct": true/false,
  "score": 85,
  "suggestion": "gợi ý ngắn"
}
''');

      final imagePart = DataPart('image/jpeg', imageBytes);
      final response = await _model.generateContent([
        Content.multi([prompt, imagePart])
      ]);

      final text = response.text ?? '';
      return PracticeFeedback.fromJson(text);
    } catch (e) {
      return PracticeFeedback(
        matchesTarget: false,
        handPositionCorrect: false,
        score: 0,
        suggestion: 'Vui lòng thử lại.',
      );
    }
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

  factory SignLanguageResult.fromJson(String jsonString) {
    try {
      // Parse JSON from Gemini response (may have markdown formatting)
      final cleaned =
          jsonString.replaceAll('```json', '').replaceAll('```', '').trim();
      // Simple parsing - in production use dart:convert
      return SignLanguageResult(
        detectedSign: _extractField(cleaned, 'detected_sign'),
        isCorrect: cleaned.contains('"is_correct": true'),
        accuracy: int.tryParse(_extractField(cleaned, 'accuracy')) ?? 0,
        feedback: _extractField(cleaned, 'feedback'),
        corrections: [],
        tips: _extractField(cleaned, 'tips'),
      );
    } catch (_) {
      return SignLanguageResult(
        detectedSign: 'Không xác định',
        isCorrect: false,
        accuracy: 0,
        feedback: jsonString,
        corrections: [],
        tips: '',
      );
    }
  }

  static String _extractField(String json, String field) {
    final regex = RegExp('"$field":\\s*"([^"]*)"');
    final match = regex.firstMatch(json);
    return match?.group(1) ?? '';
  }
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

  factory PracticeFeedback.fromJson(String jsonString) {
    try {
      final cleaned =
          jsonString.replaceAll('```json', '').replaceAll('```', '').trim();
      return PracticeFeedback(
        matchesTarget: cleaned.contains('"matches_target": true'),
        handPositionCorrect: cleaned.contains('"hand_position_correct": true'),
        score: int.tryParse(
                RegExp(r'"score":\s*(\d+)').firstMatch(cleaned)?.group(1) ??
                    '0') ??
            0,
        suggestion: RegExp(r'"suggestion":\s*"([^"]*)"')
                .firstMatch(cleaned)
                ?.group(1) ??
            '',
      );
    } catch (_) {
      return PracticeFeedback(
        matchesTarget: false,
        handPositionCorrect: false,
        score: 0,
        suggestion: 'Lỗi phân tích.',
      );
    }
  }
}
