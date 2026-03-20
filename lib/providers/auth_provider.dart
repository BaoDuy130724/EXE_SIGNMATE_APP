import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  String _userRole = 'student'; // student, teacher, admin
  String _userName = '';
  String _email = '';
  bool _isPremium = false;
  int _streak = 0;
  int _totalXp = 0;

  bool get isLoggedIn => _isLoggedIn;
  String get userRole => _userRole;
  String get userName => _userName;
  String get email => _email;
  bool get isPremium => _isPremium;
  int get streak => _streak;
  int get totalXp => _totalXp;

  Future<bool> login(String email, String password) async {
    // TODO: Firebase Auth
    await Future.delayed(const Duration(seconds: 1));
    _isLoggedIn = true;
    _email = email;
    _userName = email.split('@').first;
    _streak = 5;
    _totalXp = 1250;
    notifyListeners();
    return true;
  }

  Future<bool> register(String name, String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    _isLoggedIn = true;
    _userName = name;
    _email = email;
    notifyListeners();
    return true;
  }

  void setRole(String role) {
    _userRole = role;
    notifyListeners();
  }

  void upgradeToPremium() {
    _isPremium = true;
    notifyListeners();
  }

  void addXp(int xp) {
    _totalXp += xp;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _userName = '';
    _email = '';
    _isPremium = false;
    notifyListeners();
  }
}
