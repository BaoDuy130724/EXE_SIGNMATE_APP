import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/app_colors.dart';
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Scaffold(backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: AppColors.primary, foregroundColor: Colors.white, title: const Text('Hồ sơ & Tiến độ')),
      body: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(children: [
        Container(padding: const EdgeInsets.all(24), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: Column(children: [
            CircleAvatar(radius: 40, backgroundColor: AppColors.primaryLight, child: Text(auth.userName.isNotEmpty ? auth.userName[0].toUpperCase() : 'U', style: const TextStyle(fontSize: 32, color: AppColors.primary, fontWeight: FontWeight.bold))),
            const SizedBox(height: 12),
            Text(auth.userName.isEmpty ? 'User' : auth.userName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            if(auth.isPremium) Container(margin: const EdgeInsets.only(top: 8), padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4), decoration: BoxDecoration(gradient: AppColors.premiumGradient, borderRadius: BorderRadius.circular(20)), child: const Text('⭐ Premium', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12))),
            const SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              _stat('🔥', '${auth.streak}', 'Streak'), _stat('⭐', '${auth.totalXp}', 'XP'), _stat('📚', '18', 'Bài học'),
            ]),
          ])),
        const SizedBox(height: 16),
        _section('Thống kê tuần này', [_bar('T2',0.8), _bar('T3',0.6), _bar('T4',1.0), _bar('T5',0.4), _bar('T6',0.7), _bar('T7',0.3), _bar('CN',0.0)]),
        const SizedBox(height: 16),
        Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
          child: Column(children: [
            _menuItem(Icons.settings, 'Cài đặt', (){}),
            _menuItem(Icons.help, 'Trợ giúp', (){}),
            _menuItem(Icons.info, 'Về ứng dụng', (){}),
            _menuItem(Icons.logout, 'Đăng xuất', () { auth.logout(); context.go('/login'); }, color: AppColors.error),
          ])),
      ])),
    );
  }
  static Widget _stat(String e, String v, String l) => Column(children: [Text(e, style: const TextStyle(fontSize: 24)), Text(v, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), Text(l, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12))]);
  static Widget _bar(String d, double v) => Column(children: [Container(width: 30, height: 80, decoration: BoxDecoration(color: AppColors.divider, borderRadius: BorderRadius.circular(8)),
    child: Align(alignment: Alignment.bottomCenter, child: Container(width: 30, height: 80*v, decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(8))))), const SizedBox(height: 4), Text(d, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary))]);
  static Widget _section(String t, List<Widget> bars) => Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(t, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), const SizedBox(height: 16), Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: bars)]));
  static Widget _menuItem(IconData i, String t, VoidCallback f, {Color? color}) => ListTile(leading: Icon(i, color: color ?? AppColors.textSecondary), title: Text(t, style: TextStyle(color: color)), trailing: const Icon(Icons.chevron_right, color: AppColors.textLight), onTap: f);
}