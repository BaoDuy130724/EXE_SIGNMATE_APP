import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../utils/app_colors.dart';
import '../../widgets/bottom_nav_bar.dart';

import '../../services/subscription_service.dart';

class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ── Gradient Header ──
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                            onPressed: () => context.go('/home'),
                          ),
                          const Spacer(),
                          const Text(
                            'Nâng cấp Premium',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          const Spacer(),
                          const SizedBox(width: 48),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text('⭐', style: TextStyle(fontSize: 48)),
                      const SizedBox(height: 8),
                      const Text(
                        'Mở khóa toàn bộ tính năng',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── Plan Cards ──
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            sliver: SliverToBoxAdapter(
              child: FutureBuilder<List<dynamic>>(
                future: Future.wait([
                  SubscriptionService().getPlans(),
                  SubscriptionService().getMySubscription()
                ]),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.all(20),
                      child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
                    );
                  }

                  final plans = (snapshot.data?[0] as List?)?.cast<Map<String, dynamic>>() ?? [];
                  final mySub = snapshot.data?[1] as Map<String, dynamic>?;

                  if (plans.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(20),
                      child: Text('Đang cập nhật các gói...', style: TextStyle(color: AppColors.textSecondary)),
                    );
                  }

                  final String? currentPlanId = mySub?['isActive'] == true ? mySub!['planId']?.toString() : null;
                  final b2cPlans = plans.where((p) => p['type'] != 'B2B').toList();
                  final b2bPlans = plans.where((p) => p['type'] == 'B2B').toList();
                  b2cPlans.sort((a, b) => (a['priceVnd'] ?? 0).compareTo(b['priceVnd'] ?? 0));

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (b2cPlans.isNotEmpty) ...[
                        const Text('Cá nhân', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        ...b2cPlans.map((plan) {
                          final String planId = plan['id']?.toString() ?? '';
                          final num price = plan['priceVnd'] ?? 0;
                          final bool isCurrent = currentPlanId == planId || (currentPlanId == null && price == 0);
                          return _buildPlanCard(context, plan, isCurrent: isCurrent);
                        }),
                        const SizedBox(height: 16),
                      ],
                      if (b2bPlans.isNotEmpty) ...[
                        const Text('Tổ chức & Trung tâm', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        ...b2bPlans.map((plan) {
                          final String planId = plan['id']?.toString() ?? '';
                          final bool isCurrent = currentPlanId == planId;
                          return _buildPlanCard(context, plan, isCurrent: isCurrent);
                        }),
                      ],
                      const SizedBox(height: 100),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 4),
    );
  }

  Widget _buildPlanCard(BuildContext context, Map<String, dynamic> plan, {bool isCurrent = false}) {
    final planName = plan['name']?.toString() ?? 'Premium';
    final priceVnd = plan['priceVnd'] ?? 0;
    final priceStr = priceVnd == 0 ? 'Miễn phí' : '$priceVndđ/tháng';
    final bool isB2b = plan['type'] == 'B2B';
    final bool isPro = planName.toLowerCase().contains('pro') || planName.toLowerCase().contains('vip');

    Color color = AppColors.primary;
    if (isPro) color = AppColors.accentOrange;
    if (isB2b) color = AppColors.primary;
    if (priceVnd == 0) color = AppColors.success;

    List<String> featureList = [];
    if (plan['featuresJson'] != null && plan['featuresJson'].toString().isNotEmpty) {
      try {
        final decoded = jsonDecode(plan['featuresJson']);
        if (decoded is List) featureList = decoded.map((e) => e.toString()).toList();
      } catch (e) {
        featureList = plan['featuresJson'].toString().split(',').map((e) => e.trim()).toList();
      }
    } else {
      featureList = ['Truy cập SignMate', 'Hỗ trợ 24/7'];
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isCurrent ? AppColors.success : color.withValues(alpha: 0.4), width: isCurrent ? 2 : 1.5),
      ),
      child: Column(
        children: [
          if (isCurrent)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: const BoxDecoration(
                color: AppColors.success,
                borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
              ),
              child: const Text('✅ Đang sử dụng', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
            )
          else if (isPro)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
              ),
              child: const Text('⭐ Phổ biến nhất', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
            ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(planName, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
                    const Spacer(),
                    Text(priceStr, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: color)),
                  ],
                ),
                const SizedBox(height: 12),
                ...featureList.map((f) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: color, size: 18),
                      const SizedBox(width: 8),
                      Expanded(child: Text(f, style: const TextStyle(fontSize: 14))),
                    ],
                  ),
                )),
                if (!isCurrent && priceVnd != 0) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton(
                      onPressed: isB2b ? () => context.go('/contact-form') : () => context.go('/premium-payment'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(23)),
                        elevation: 0,
                      ),
                      child: Text(isB2b ? 'Liên hệ tư vấn' : 'Chọn gói $planName', style: const TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
