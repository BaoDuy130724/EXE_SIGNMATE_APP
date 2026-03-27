import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class ApiConfig {
  // .NET Backend API
  static String get baseUrl {
    if (kIsWeb) return 'https://localhost:7122/api';
    if (Platform.isAndroid) return 'http://10.0.2.2:5184/api';
    return 'http://localhost:5184/api';
  }

  // Python AI Service (direct call for real-time scoring)
  static String get aiBaseUrl {
    if (kIsWeb) return 'http://localhost:8000';
    if (Platform.isAndroid) return 'http://10.0.2.2:8000';
    return 'http://localhost:8000';
  }

  // Timeout settings
  static const Duration timeoutDuration = Duration(seconds: 15);
  static const Duration aiTimeoutDuration = Duration(seconds: 5);
}
