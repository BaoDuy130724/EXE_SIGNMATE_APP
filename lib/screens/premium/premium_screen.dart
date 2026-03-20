import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../utils/app_colors.dart';
class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(backgroundColor: AppColors.background,
    appBar: AppBar(backgroundColor: AppColors.primaryDark, foregroundColor: Colors.white, title: const Text('Premium ⭐')),
    body: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(children: [
      Container(padding: const EdgeInsets.all(24), decoration: BoxDecoration(gradient: AppColors.premiumGradient, borderRadius: BorderRadius.circular(20)),
        child: const Column(children: [Text('⭐', style: TextStyle(fontSize: 60)), SizedBox(height: 12), Text('Nâng cấp Premium', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)), SizedBox(height: 8), Text('Mở khóa toàn bộ tính năng', style: TextStyle(color: Colors.white70, fontSize: 14))])),
      const SizedBox(height: 24),
      ...[['📹','Camera AI không giới hạn','Luyện tập với AI mọi lúc'],['📚','Tất cả bài học','Truy cập toàn bộ khóa học'],['📊','Báo cáo chi tiết','Theo dõi tiến độ nâng cao'],['🚫','Không quảng cáo','Trải nghiệm mượt mà']].map((f) =>
        Container(margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: Row(children: [Text(f[0], style: const TextStyle(fontSize: 28)), const SizedBox(width: 16), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(f[1], style: const TextStyle(fontWeight: FontWeight.w600)), Text(f[2], style: const TextStyle(color: AppColors.textSecondary, fontSize: 13))]))]))),
      const SizedBox(height: 16),
      _plan(context, 'Basic', '49,000đ/tháng', AppColors.primary, false),
      const SizedBox(height: 12),
      _plan(context, 'Pro', '99,000đ/tháng', AppColors.primaryDark, true),
    ])));
  static Widget _plan(BuildContext c, String n, String p, Color col, bool pop) => GestureDetector(onTap: () => c.go('/premium-payment'),
    child: Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: pop ? col : Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: col, width: 2)),
      child: Row(children: [Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [if(pop) const Text('Phổ biến nhất', style: TextStyle(color: Colors.white70, fontSize: 12)), Text(n, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: pop ? Colors.white : col)), Text(p, style: TextStyle(color: pop ? Colors.white70 : AppColors.textSecondary))])),
        Icon(Icons.arrow_forward_ios, color: pop ? Colors.white : col)])));
}