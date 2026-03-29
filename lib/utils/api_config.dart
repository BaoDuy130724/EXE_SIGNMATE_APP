import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class ApiConfig {
  // Thay URL này bằng IPv4 của máy tính bạn mang Wi-Fi nếu test trên điện thoại thật (VD: http://192.168.1.X:5184/api)
  // Trong lúc test Emulator, hãy dùng: 'http://10.0.2.2:5184/api'
  // ==========================================
  // 1. .NET Backend API (Main Database & Logic)
  // ==========================================
  static String get baseUrl {
    // 🌍 [PRODUCTION] Bỏ comment dòng này khi muốn trỏ lên Server Thật (Runasp)
    return 'http://signmate.runasp.net/api';

    // 🏠 [LOCAL] Dành cho lúc đang code, test Emulator hoặc Chrome
    // if (kIsWeb) return 'https://localhost:7122/api';
    // if (Platform.isAndroid) return 'http://10.0.2.2:5184/api'; // Máy ảo Android
    // return 'http://localhost:5184/api'; // Desktop / iOS / Web
  }

  // ==========================================
  // 2. Python AI Service (Real-time Scoring)
  // ==========================================
  static String get aiBaseUrl {
    // 🌍 [PRODUCTION] Bỏ comment dòng này khi BE Python đã Deploy (Azure, Render, v.v.)
    // return 'https://signmate-ai.example.com';

    // 🏠 [LOCAL] Dành cho lúc đang chạy máy học cục bộ cổng 8000
    if (kIsWeb) return 'http://localhost:8000';
    if (Platform.isAndroid) return 'http://10.0.2.2:8000'; // Máy ảo Android chọc ra cổng 8000 máy thật
    return 'http://localhost:8000'; 
  }

  // ==========================================
  // 3. Timeout Settings
  // ==========================================
  static const Duration timeoutDuration = Duration(seconds: 15);
  static const Duration aiTimeoutDuration = Duration(seconds: 5);
}
