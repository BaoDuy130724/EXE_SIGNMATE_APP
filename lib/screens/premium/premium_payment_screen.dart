import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/app_colors.dart';
class PremiumPaymentScreen extends StatelessWidget {
  const PremiumPaymentScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(backgroundColor: AppColors.background,
    appBar: AppBar(backgroundColor: AppColors.primary, foregroundColor: Colors.white, title: const Text('Thanh toán')),
    body: Padding(padding: const EdgeInsets.all(24), child: Column(children: [
      Container(padding: const EdgeInsets.all(24), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: const Column(children: [Text('Gói Pro', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)), SizedBox(height: 8), Text('99,000đ/tháng', style: TextStyle(fontSize: 20, color: AppColors.primary, fontWeight: FontWeight.w600)), Divider(height: 32), Row(children: [Icon(Icons.check, color: AppColors.success), SizedBox(width: 8), Text('Camera AI không giới hạn')]), SizedBox(height: 8), Row(children: [Icon(Icons.check, color: AppColors.success), SizedBox(width: 8), Text('Tất cả bài học')]), SizedBox(height: 8), Row(children: [Icon(Icons.check, color: AppColors.success), SizedBox(width: 8), Text('Không quảng cáo')])])),
      const Spacer(),
      SizedBox(width: double.infinity, height: 52, child: ElevatedButton(onPressed: () { context.read<AuthProvider>().upgradeToPremium(); context.go('/home'); },
        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
        child: const Text('Xác nhận thanh toán', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)))),
      const SizedBox(height: 20),
    ])));
}