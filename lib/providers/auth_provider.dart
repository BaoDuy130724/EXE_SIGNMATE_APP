import 'package:flutter/material.dart';
import '../utils/app_constants.dart';

class AuthProvider extends ChangeNotifier {
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

  Future<bool> login(String email, String password) async {
    // TODO: Firebase Auth
    await Future.delayed(const Duration(seconds: 1));
    _isLoggedIn = true;
    _email = email;
    _userName = email.split('@').first;
    _streak = 5;
    _totalXp = 1250;
    _level = 4;
    _lessonsCompleted = 18;
    _practiceAccuracy = 78;
    notifyListeners();
    return true;
  }

  Future<bool> register(String name, String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    _isLoggedIn = true;
    _userName = name;
    _email = email;
    _streak = 0;
    _totalXp = 0;
    _level = 1;
    _lessonsCompleted = 0;
    _practiceAccuracy = 0;
    notifyListeners();
    return true;
  }

  void setRole(String role) {
    _userRole = role;
    notifyListeners();
  }

  void setOnboarding({required String goal, required String skillLevel}) {
    _goal = goal;
    _skillLevel = skillLevel;
    notifyListeners();
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
    // Level up every 500 XP
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

  void logout() {
    _isLoggedIn = false;
    _userName = '';
    _email = '';
    _plan = AppConstants.planFree;
    _streak = 0;
    _totalXp = 0;
    _level = 1;
    notifyListeners();
  }
}
