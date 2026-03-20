import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/lesson_provider.dart';
import '../../utils/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final lessons = context.watch<LessonProvider>();
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: Drawer(backgroundColor: AppColors.primary, child: SafeArea(child: Column(children: [
        const SizedBox(height: 20),
        CircleAvatar(radius: 40, backgroundColor: Colors.white24, child: Text(auth.userName.isNotEmpty ? auth.userName[0].toUpperCase() : 'U', style: const TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold))),
        const SizedBox(height: 12),
        Text(auth.userName.isEmpty ? 'User' : auth.userName, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
        const SizedBox(height: 30),
        ...[['home','Trang chủ',Icons.home],['lesson','Bài học',Icons.menu_book],['practice-camera','Camera AI',Icons.camera_alt],['profile','Tiến độ',Icons.bar_chart],['premium','Premium',Icons.workspace_premium]].map((e) =>
          ListTile(leading: Icon(e[2] as IconData, color: Colors.white70), title: Text(e[1] as String, style: const TextStyle(color: Colors.white70)), onTap: () => context.go('/${e[0]}'))),
        const Spacer(),
        ListTile(leading: const Icon(Icons.logout, color: Colors.white70), title: const Text('Đăng xuất', style: TextStyle(color: Colors.white70)), onTap: () { auth.logout(); context.go('/login'); }),
        const SizedBox(height: 20),
      ]))),
      appBar: AppBar(backgroundColor: AppColors.primary, foregroundColor: Colors.white,
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Xin chào, ${auth.userName.isEmpty ? "Bạn" : auth.userName}! 👋', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          Text('Streak: ${auth.streak} ngày 🔥', style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.8))),
        ]),
        actions: [IconButton(icon: const Icon(Icons.notifications_outlined), onPressed: (){}), IconButton(icon: const Icon(Icons.workspace_premium), onPressed: () => context.go('/premium'))],
      ),
      body: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(20)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Mục tiêu hôm nay', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ClipRRect(borderRadius: BorderRadius.circular(10), child: const LinearProgressIndicator(value: 0.6, minHeight: 10, backgroundColor: Colors.white30, valueColor: AlwaysStoppedAnimation(Colors.white))),
            const SizedBox(height: 8),
            Text('3/5 bài học hoàn thành', style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 13)),
          ])),
        const SizedBox(height: 24),
        Row(children: [
          _qa(context, '📹', 'Camera AI', '/practice-camera'),
          const SizedBox(width: 12),
          _qa(context, '📝', 'Kiểm tra', '/practice'),
          const SizedBox(width: 12),
          _qa(context, '📊', 'Tiến độ', '/profile'),
        ]),
        const SizedBox(height: 24),
        const Text('Tiếp tục học', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ...lessons.lessons.asMap().entries.map((e) => _lc(context, e.value, e.key, lessons)),
      ])),
      bottomNavigationBar: BottomNavigationBar(type: BottomNavigationBarType.fixed, selectedItemColor: AppColors.primary, unselectedItemColor: AppColors.textLight, currentIndex: 0,
        onTap: (i) { if(i==1) context.go('/lesson'); if(i==2) context.go('/practice-camera'); if(i==3) context.go('/profile'); },
        items: const [BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang chủ'), BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Bài học'), BottomNavigationBarItem(icon: Icon(Icons.camera_alt), label: 'Camera AI'), BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Hồ sơ')]),
    );
  }
  Widget _qa(BuildContext c, String e, String l, String r) => Expanded(child: GestureDetector(onTap: () => c.go(r), child: Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)]), child: Column(children: [Text(e, style: const TextStyle(fontSize: 32)), const SizedBox(height: 8), Text(l, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500), textAlign: TextAlign.center)]))));
  Widget _lc(BuildContext c, Map<String,dynamic> l, int i, LessonProvider lp) { final p = l['completed']/l['lessons']; return GestureDetector(onTap: () { lp.startLesson(i); c.go('/lesson'); }, child: Container(margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)), child: Row(children: [Container(width: 50, height: 50, decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(12)), child: Center(child: Text(l['icon'], style: const TextStyle(fontSize: 28)))), const SizedBox(width: 16), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(l['title'], style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)), const SizedBox(height: 4), Text('${l['completed']}/${l['lessons']} bài', style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)), const SizedBox(height: 8), ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: p, minHeight: 6, backgroundColor: AppColors.divider, valueColor: const AlwaysStoppedAnimation(AppColors.primary)))])), const Icon(Icons.chevron_right, color: AppColors.textLight)]))); }
}