import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_constants.dart';
import '../../widgets/common_widgets.dart';

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

            // B2C Plans
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 4, bottom: 8, top: 8),
                child: Text('Cá nhân',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),

            // Free Plan
            _planCard(
              context,
              name: 'Free',
              price: 'Miễn phí',
              features: [
                '5 bài học / ngày',
                'Phản hồi đúng / sai cơ bản',
                'Không có phân tích',
              ],
              color: AppColors.planFree,
              isPopular: false,
              planType: AppConstants.planFree,
            ),

            // Basic Plan
            _planCard(
              context,
              name: 'Basic',
              price: '49,000đ/tháng',
              features: [
                'Không giới hạn bài học',
                'Phản hồi chi tiết cơ bản',
                'Theo dõi tiến độ',
                'Hệ thống streak',
              ],
              color: AppColors.planBasic,
              isPopular: false,
              planType: AppConstants.planBasic,
            ),

            // Pro Plan
            _planCard(
              context,
              name: 'Pro',
              price: '99,000đ/tháng',
              features: [
                'Phân tích AI chi tiết',
                'Giải thích lỗi (tư thế, góc tay)',
                'Phát hiện điểm yếu',
                'Phân tích nâng cao',
                'Không quảng cáo',
              ],
              color: AppColors.planPro,
              isPopular: true,
              planType: AppConstants.planPro,
            ),

            const SizedBox(height: 16),

            // B2B Section
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 4, bottom: 8),
                child: Text('Tổ chức & Trung tâm',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),

            CustomCard(
              padding: const EdgeInsets.all(20),
              border: Border.all(color: AppColors.primary, width: 1.5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.business, color: AppColors.primary),
                      SizedBox(width: 8),
                      Text(
                        'B2B - Trung tâm',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '79,000đ / học viên / tháng',
                    style: TextStyle(
                        fontSize: 16,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600),
                  ),
                  const Text(
                    'Tối thiểu 20 học viên',
                    style:
                        TextStyle(color: AppColors.textSecondary, fontSize: 13),
                  ),
                  const SizedBox(height: 12),
                  ...[
                    'Dashboard giáo viên',
                    'Quản lý lớp học',
                    'Theo dõi học viên',
                    'Báo cáo hiệu suất'
                  ].map((f) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          children: [
                            const Icon(Icons.check_circle,
                                color: AppColors.success, size: 18),
                            const SizedBox(width: 8),
                            Text(f, style: const TextStyle(fontSize: 14)),
                          ],
                        ),
                      )),
                  const SizedBox(height: 16),
                  CustomButton(
                    text: 'Liên hệ tư vấn',
                    icon: Icons.mail_outline,
                    isOutlined: true,
                    onPressed: () => context.go('/contact-form'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _planCard(
    BuildContext context, {
    required String name,
    required String price,
    required List<String> features,
    required Color color,
    required bool isPopular,
    required String planType,
  }) {
    return CustomCard(
      margin: const EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.zero,
      border: isPopular ? Border.all(color: color, width: 2) : null,
      child: Column(
        children: [
          if (isPopular)
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
                      name,
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: color),
                    ),
                    const Spacer(),
                    Text(
                      price,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: color),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...features.map((f) => Padding(
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
                if (planType != AppConstants.planFree) ...[
                  const SizedBox(height: 12),
                  CustomButton(
                    text: 'Chọn gói $name',
                    backgroundColor: color,
                    onPressed: () => context.go('/premium-payment'),
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
