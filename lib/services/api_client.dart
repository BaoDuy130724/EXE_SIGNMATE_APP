import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/api_config.dart';

class ApiClient {
  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';

  Future<Map<String, String>> _getHeaders({bool requiresAuth = true}) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (requiresAuth) {
      final token = await getToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return headers;
  }
  
  // Reusable request dispatcher with retry logic
  Future<dynamic> _sendRequest(String method, String endpoint, {Map<String, dynamic>? body, bool requiresAuth = true}) async {
    Uri uri = Uri.parse('${ApiConfig.baseUrl}$endpoint');
    
    Future<http.Response> attemptRequest() async {
      final headers = await _getHeaders(requiresAuth: requiresAuth);
      if (method == 'GET') return http.get(uri, headers: headers).timeout(ApiConfig.timeoutDuration);
      if (method == 'POST') return http.post(uri, headers: headers, body: body != null ? jsonEncode(body) : null).timeout(ApiConfig.timeoutDuration);
      if (method == 'PUT') return http.put(uri, headers: headers, body: body != null ? jsonEncode(body) : null).timeout(ApiConfig.timeoutDuration);
      if (method == 'DELETE') return http.delete(uri, headers: headers).timeout(ApiConfig.timeoutDuration);
      throw Exception('Unsupported HTTP method: $method');
    }

    try {
      http.Response response = await attemptRequest();

      // Catch 401 Unauthorized and auto-refresh the token
      if (response.statusCode == 401 && requiresAuth && !endpoint.contains('/auth/')) {
        final success = await _attemptTokenRefresh();
        if (success) {
          response = await attemptRequest(); // Retry original request with new token
        } else {
          // If refresh failed, force user to log out
          await clearToken();
          throw Exception('Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại. (Error 401)');
        }
      }

      return _processResponse(response);
    } catch (e) {
      if (e is Exception && e.toString().contains('Phiên đăng nhập')) {
        rethrow;
      }
      debugPrint('HTTP $method Error: $e');
      throw Exception('Network error: $e');
    }
  }

  Future<bool> _attemptTokenRefresh() async {
    final prefs = await SharedPreferences.getInstance();
    final refreshToken = prefs.getString(_refreshTokenKey);
    if (refreshToken == null || refreshToken.isEmpty) return false;

    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}/auth/refresh');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refreshToken': refreshToken}),
      ).timeout(ApiConfig.timeoutDuration);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = jsonDecode(response.body);
        if (data['accessToken'] != null) {
            await saveTokens(data['accessToken'], data['refreshToken'] ?? refreshToken);
            return true;
        }
      }
    } catch (_) {}
    return false;
  }

  Future<dynamic> get(String endpoint, {bool requiresAuth = true}) => _sendRequest('GET', endpoint, requiresAuth: requiresAuth);
  Future<dynamic> post(String endpoint, {Map<String, dynamic>? body, bool requiresAuth = true}) => _sendRequest('POST', endpoint, body: body, requiresAuth: requiresAuth);
  Future<dynamic> put(String endpoint, {Map<String, dynamic>? body, bool requiresAuth = true}) => _sendRequest('PUT', endpoint, body: body, requiresAuth: requiresAuth);
  Future<dynamic> delete(String endpoint, {bool requiresAuth = true}) => _sendRequest('DELETE', endpoint, requiresAuth: requiresAuth);

  Future<dynamic> postMultipart(String endpoint, {required String filePath, String fileField = 'video', bool requiresAuth = true}) async {
    Uri uri = Uri.parse('${ApiConfig.baseUrl}$endpoint');

    Future<http.Response> attemptRequest() async {
      var request = http.MultipartRequest('POST', uri);
      final headers = await _getHeaders(requiresAuth: requiresAuth);
      headers.remove('Content-Type'); // Let http client handle boundary
      request.headers.addAll(headers);
      request.files.add(await http.MultipartFile.fromPath(fileField, filePath));

      final streamedResponse = await request.send().timeout(const Duration(minutes: 5)); // Allow longer timeout for video upload
      return await http.Response.fromStream(streamedResponse);
    }

    try {
      http.Response response = await attemptRequest();

      if (response.statusCode == 401 && requiresAuth) {
        final success = await _attemptTokenRefresh();
        if (success) {
          response = await attemptRequest();
        } else {
          await clearToken();
          throw Exception('Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại. (Error 401)');
        }
      }

      return _processResponse(response);
    } catch (e) {
      if (e is Exception && e.toString().contains('Phiên đăng nhập')) rethrow;
      throw Exception('Network error: $e');
    }
  }

  dynamic _processResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      return jsonDecode(response.body);
    } else {
      String message = 'API Error: ${response.statusCode}';
      try {
        final errorBody = jsonDecode(response.body);
        message = errorBody['message'] ?? message;
      } catch (_) {}
      throw Exception(message);
    }
  }

  // Token management
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<void> saveTokens(String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, accessToken);
    await prefs.setString(_refreshTokenKey, refreshToken);
  }

  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_refreshTokenKey);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }
}
