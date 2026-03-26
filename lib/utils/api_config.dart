import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class ApiConfig {
  // Thay URL này bằng IPv4 của máy tính bạn mang Wi-Fi nếu test trên điện thoại thật (VD: http://192.168.1.X:5184/api)
  // Trong lúc test Emulator, hãy dùng: 'http://10.0.2.2:5184/api'
  static String get baseUrl {
    // Để chạy trên điên thoại thật (Android/iOS), bỏ qua kIsWeb/Platform và trả về biến IPv4 cứng:
    // return 'http://192.168.1.100:5184/api'; // <--- SỬA DÒNG NÀY THÀNH IPv4 CỦA BẠN

    if (kIsWeb) return 'https://localhost:7122/api';
    if (Platform.isAndroid) return 'http://10.0.2.2:5184/api';
    return 'http://localhost:5184/api';
  }

  // Timeout settings
  static const Duration timeoutDuration = Duration(seconds: 15);
}
