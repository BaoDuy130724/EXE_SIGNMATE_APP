import 'api_client.dart';
import '../models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final ApiClient _apiClient = ApiClient();

  /// Logs in and returns a UserModel if successful. Saves JWT token.
  Future<UserModel> login(String email, String password) async {
    final response = await _apiClient.post(
      '/auth/login',
      body: {
        'email': email,
        'password': password,
      },
      requiresAuth: false,
    );

    // Backend returns TokenResponse (accessToken, refreshToken, expiresAt)
    final token = response['accessToken'];
    final refreshToken = response['refreshToken'];
    
    if (token != null) {
      if (refreshToken != null) {
        await _apiClient.saveTokens(token, refreshToken);
      } else {
        await _apiClient.saveToken(token);
      }
    } else {
      throw Exception('No access token received from server.');
    }

    // Explicitly fetch the User profile using the newly saved token
    return await getMe();
  }

  /// Request a registration OTP email
  Future<void> sendRegisterOtp(String email) async {
    await _apiClient.post('/auth/send-register-otp', body: {'email': email}, requiresAuth: false);
  }

  /// Registers and returns a UserModel if successful. Saves JWT token.
  Future<UserModel> register(String name, String email, String password, String otpCode) async {
    final response = await _apiClient.post(
      '/auth/register',
      body: {
        'fullName': name, // Map Dart 'name' to C# 'FullName'
        'email': email,
        'password': password,
        'otpCode': otpCode,
      },
      requiresAuth: false,
    );

    final token = response['accessToken'];
    final refreshToken = response['refreshToken'];
    
    if (token != null) {
      if (refreshToken != null) {
        await _apiClient.saveTokens(token, refreshToken);
      } else {
        await _apiClient.saveToken(token);
      }
      return await getMe(); // If backend auto-logs in, get profile
    }

    // Fallback if backend doesn't auto-login after register
    return UserModel(
      id: '', name: name, email: email, userRole: 'student', plan: 'free',
      streak: 0, totalXp: 0, level: 1, lessonsCompleted: 0, practiceAccuracy: 0,
    );
  }

  /// Fetches the profile of the currently logged-in user.
  Future<UserModel> getMe() async {
    final response = await _apiClient.get('/users/me');
    return UserModel.fromJson(response);
  }


  /// Logs out by clearing the token and optionally calling the logout endpoint.
  Future<void> logout() async {
    try {
      await _apiClient.post('/auth/logout');
    } catch (_) {
      // Ignore network errors during logout
    } finally {
      await _apiClient.clearToken();
      // Also clear standard SharedPreferences if they exist
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    }
  }

  /// Refresh access token
  Future<void> refreshToken() async {
    final response = await _apiClient.post('/auth/refresh');
    final token = response['token'];
    if (token != null) {
      await _apiClient.saveToken(token);
    }
  }

  /// Request a password reset email
  Future<void> forgotPassword(String email) async {
    await _apiClient.post('/auth/forgot-password', body: {'email': email}, requiresAuth: false);
  }

  /// Reset password using the code
  Future<void> resetPassword(String email, String code, String newPassword) async {
    await _apiClient.post('/auth/reset-password', body: {
      'email': email,
      'code': code,
      'newPassword': newPassword,
    }, requiresAuth: false);
  }

  /// Change password for logged-in user
  Future<void> changePassword(String oldPassword, String newPassword) async {
    await _apiClient.post('/auth/change-password', body: {
      'oldPassword': oldPassword,
      'newPassword': newPassword,
    });
  }

  /// Update current user profile
  Future<UserModel> updateProfile(Map<String, dynamic> data) async {
    final response = await _apiClient.put('/users/me', body: data);
    return UserModel.fromJson(response);
  }

  /// Get current user's learning streak
  Future<Map<String, dynamic>> getStreak() async {
    final response = await _apiClient.get('/users/me/streak');
    return response as Map<String, dynamic>;
  }

  /// Get current user's achievements
  Future<List<dynamic>> getAchievements() async {
    final response = await _apiClient.get('/users/me/achievements');
    return response is List ? response : [];
  }

  /// Submit initial user onboarding preferences
  Future<void> submitOnboarding(Map<String, dynamic> data) async {
    await _apiClient.post('/onboarding', body: data);
  }
}
