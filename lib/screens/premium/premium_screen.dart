import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../utils/app_colors.dart';

import '../../widgets/common_widgets.dart';
import '../../services/subscription_service.dart';

class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        title: const Text('Nâng cấp ⭐'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.go('/home'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header
            const CustomCard(
              gradient: AppColors.premiumGradient,
              padding: EdgeInsets.all(28),
              child: Column(
                children: [
                  Text('⭐', style: TextStyle(fontSize: 56)),
                  SizedBox(height: 12),
                  Text(
                    'Chọn gói phù hợp',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Mở khóa toàn bộ tính năng học tập',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            FutureBuilder<List<dynamic>>(
              future: Future.wait([
                SubscriptionService().getPlans(),
                SubscriptionService().getMySubscription()
              ]),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                
                final plans = (snapshot.data?[0] as List?)?.cast<Map<String, dynamic>>() ?? [];
                final mySub = snapshot.data?[1] as Map<String, dynamic>?;
                
                if (plans.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text('Đang cập nhật các gói từ Máy chủ...'),
                  );
                }

                // Determine current plan based on BE response
                final String? currentPlanId = mySub?['isActive'] == true ? mySub!['planId']?.toString() : null;
                
                final b2cPlans = plans.where((p) => p['type'] != 'B2B').toList();
                final b2bPlans = plans.where((p) => p['type'] == 'B2B').toList();
                
                // Sort B2C plans by priceVnd ascending (Free first, then Basic, then Pro)
                b2cPlans.sort((a, b) => (a['priceVnd'] ?? 0).compareTo(b['priceVnd'] ?? 0));
                
                return Column(
                  children: [
                    // --- B2C Section ---
                    if (b2cPlans.isNotEmpty) ...[
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 4, bottom: 8, top: 8),
                          child: Text('Cá nhân',
                              style:
                                  TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      ...b2cPlans.map((plan) {
                        final String planId = plan['id']?.toString() ?? '';
                        final num price = plan['priceVnd'] ?? 0;
                        // If user has no active subscription from BE, the 0 VND plan (Free) is their active plan by default
                        final bool isCurrent = currentPlanId == planId || (currentPlanId == null && price == 0);
                        return _buildDynamicPlanCard(context, plan, isCurrentPlan: isCurrent);
                      }),
                      const SizedBox(height: 16),
                    ],

                    // --- B2B Section ---
                    if (b2bPlans.isNotEmpty) ...[
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 4, bottom: 8),
                          child: Text('Tổ chức & Trung tâm',
                              style:
                                  TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      ...b2bPlans.map((plan) {
                        final String planId = plan['id']?.toString() ?? '';
                        final bool isCurrent = currentPlanId == planId;
                        return _buildDynamicPlanCard(context, plan, isCurrentPlan: isCurrent);
                      }),
                    ]
                  ],
                );
              },
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildDynamicPlanCard(BuildContext context, Map<String, dynamic> plan, {bool isCurrentPlan = false}) {
    final planName = plan['name']?.toString() ?? 'Premium';
    final priceVnd = plan['priceVnd'] ?? 0;
    final priceStr = priceVnd == 0 ? 'Miễn phí' : '$priceVndđ/tháng';
    
    List<String> featureList = [];
    if (plan['featuresJson'] != null && plan['featuresJson'].toString().isNotEmpty) {
      try {
        final decoded = jsonDecode(plan['featuresJson']);
        if (decoded is List) {
          featureList = decoded.map((e) => e.toString()).toList();
        }
      } catch (e) {
        featureList = plan['featuresJson'].toString().split(',').map((e) => e.trim()).toList();
      }
    } else {
      featureList = ['Truy cập API học viện SignMate', 'Hỗ trợ 24/7'];
    }

    final bool isB2b = plan['type'] == 'B2B';
    final bool isPro = planName.toLowerCase().contains('pro') || planName.toLowerCase().contains('vip');

    Color color = AppColors.planBasic;
    if (isPro) color = AppColors.planPro;
    if (isB2b) color = AppColors.primary;

    return CustomCard(
      margin: const EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.zero,
      border: Border.all(
        color: isCurrentPlan ? AppColors.success : color, 
        width: (isPro || isCurrentPlan || isB2b) ? 2 : 1.5
      ),
      child: Column(
        children: [
          if (isCurrentPlan)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: const BoxDecoration(
                color: AppColors.success,
                borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
              ),
              child: const Text(
                '✅ Đang sử dụng',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13),
              ),
            )
          else if (isPro)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: color,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(14)),
              ),
              child: const Text(
                '⭐ Phổ biến nhất',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      planName,
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: color),
                    ),
                    const Spacer(),
                    Text(
                      priceStr,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: color),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...featureList.map((f) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        children: [
                          Icon(Icons.check_circle, color: color, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                              child: Text(f,
                                  style: const TextStyle(fontSize: 14))),
                        ],
                      ),
                    )),
                if (isB2b) ...[
                  const SizedBox(height: 12),
                  CustomButton(
                    text: 'Liên hệ tư vấn',
                    icon: Icons.mail_outline,
                    isOutlined: true,
                    onPressed: () => context.go('/contact-form'),
                  ),
                ] else if (priceVnd != 0) ...[
                  const SizedBox(height: 12),
                  CustomButton(
                    text: isCurrentPlan ? 'Đang sử dụng' : 'Chọn gói $planName',
                    backgroundColor: isCurrentPlan ? AppColors.success : color,
                    onPressed: isCurrentPlan ? null : () async {
                      final planId = plan['id']?.toString() ?? '';
                      try {
                        final result = await SubscriptionService().subscribe(planId);
                        final paymentUrl = result['paymentUrl'] as String?;
                        if (paymentUrl != null && context.mounted) {
                          context.go('/premium-payment', extra: {'paymentUrl': paymentUrl});
                        } else if (result['success'] == true && context.mounted) {
                          // Free plan activated
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('✅ Gói đã được kích hoạt!'), backgroundColor: AppColors.success),
                          );
                          context.go('/home');
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Lỗi: $e'), backgroundColor: AppColors.error),
                          );
                        }
                      }
                    },
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
