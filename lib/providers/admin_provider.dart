import 'package:flutter/material.dart';
import '../services/admin_service.dart';

class AdminProvider extends ChangeNotifier {
  final AdminService _adminService = AdminService();
  
  bool _isLoading = false;
  int _totalUsers = 0;
  double _totalRevenue = 0;
  int _activeCenters = 0;
  double _conversionRate = 0;
  int _premiumUsers = 0;
  double _retentionRate = 0;

  bool get isLoading => _isLoading;
  int get totalUsers => _totalUsers;
  double get totalRevenue => _totalRevenue;
  int get activeCenters => _activeCenters;
  double get conversionRate => _conversionRate;
  int get premiumUsers => _premiumUsers;
  double get retentionRate => _retentionRate;

  Future<void> loadDashboard() async {
    _isLoading = true;
    notifyListeners();

    try {
      final data = await _adminService.getSystemDashboard();
      _totalUsers = data['totalUsers'] as int? ?? 0;
      _totalRevenue = (data['totalRevenue'] as num?)?.toDouble() ?? 0.0;
      _activeCenters = data['activeCenters'] as int? ?? 0;
      _conversionRate = (data['conversionRate'] as num?)?.toDouble() ?? 0.0;
      _premiumUsers = data['premiumUsers'] as int? ?? 0;
      _retentionRate = (data['retentionRate'] as num?)?.toDouble() ?? 0.0;
      
    } catch (e) {
      debugPrint('Error loading admin dashboard: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
