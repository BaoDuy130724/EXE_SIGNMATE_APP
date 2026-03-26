import 'package:flutter/material.dart';
import '../utils/app_constants.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoggedIn = false;
  String _userRole = AppConstants.roleStudent;
  String _userName = '';
  String _email = '';
  String _plan = AppConstants.planFree;
  int _streak = 0;
  int _totalXp = 0;
  int _level = 1;
  int _lessonsCompleted = 0;
  int _practiceAccuracy = 0;
  String _goal = '';
  String _skillLevel = '';

  bool get isLoggedIn => _isLoggedIn;
  String get userRole => _userRole;
  String get userName => _userName;
  String get email => _email;
  String get plan => _plan;
  bool get isPremium => _plan != AppConstants.planFree;
  bool get isPro => _plan == AppConstants.planPro;
  int get streak => _streak;
  int get totalXp => _totalXp;
  int get level => _level;
  int get lessonsCompleted => _lessonsCompleted;
  int get practiceAccuracy => _practiceAccuracy;
  String get goal => _goal;
  String get skillLevel => _skillLevel;

  /// Fetches the current user profile using stored token on app startup
  Future<void> autoLogin() async {
    try {
      final user = await _authService.getMe();
      _isLoggedIn = true;
      _populateFromModel(user);
    } catch (e) {
      _isLoggedIn = false;
    }
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    try {
      final user = await _authService.login(email, password);
      _isLoggedIn = true;
      _populateFromModel(user);
      return true;
    } catch (e) {
      debugPrint('Login Error: $e');
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    try {
      final user = await _authService.register(name, email, password);
      _isLoggedIn = true;
      _populateFromModel(user);
      return true;
    } catch (e) {
      debugPrint('Register Error: $e');
      return false;
    }
  }

  void _populateFromModel(dynamic user) {
    _userName = user.name;
    _email = user.email;
    _userRole = user.userRole;
    _plan = user.plan;
    _streak = user.streak;
    _totalXp = user.totalXp;
    _level = user.level;
    _lessonsCompleted = user.lessonsCompleted;
    _practiceAccuracy = user.practiceAccuracy;
    notifyListeners();
  }

  void setRole(String role) {
    _userRole = role;
    notifyListeners();
  }

  Future<bool> submitOnboarding({required String goal, required String skillLevel}) async {
    try {
      await _authService.submitOnboarding({'goal': goal, 'level': skillLevel});
      _goal = goal;
      _skillLevel = skillLevel;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Onboarding Error: $e');
      return false;
    }
  }

  void upgradePlan(String plan) {
    _plan = plan;
    notifyListeners();
  }

  void upgradeToPremium() {
    _plan = AppConstants.planPro;
    notifyListeners();
  }

  void addXp(int xp) {
    _totalXp += xp;
    _level = (_totalXp / 500).floor() + 1;
    notifyListeners();
  }

  void incrementStreak() {
    _streak++;
    notifyListeners();
  }

  void completedLesson() {
    _lessonsCompleted++;
    addXp(AppConstants.xpPerLessonComplete);
    notifyListeners();
  }

  void updateAccuracy(int accuracy) {
    _practiceAccuracy = accuracy;
    notifyListeners();
  }

  Future<void> logout() async {
    await _authService.logout();
    _isLoggedIn = false;
    _userName = '';
    _email = '';
    _plan = AppConstants.planFree;
    _streak = 0;
    _totalXp = 0;
    _level = 1;
    _lessonsCompleted = 0;
    _practiceAccuracy = 0;
    notifyListeners();
  }
}
