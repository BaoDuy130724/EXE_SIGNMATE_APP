import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../widgets/common_widgets.dart';

class AdminReportsScreen extends StatelessWidget {
  const AdminReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
        title: const Text('Báo cáo thống kê'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overview card
            CustomCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.analytics_outlined, color: AppColors.primary, size: 22),
                      SizedBox(width: 8),
                      Text(
                        'Tổng quan hệ thống',
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _statRow('Tổng người dùng', '1,234', AppColors.primary),
                  const Divider(height: 20),
                  _statRow('Doanh thu tháng', '12,500,000 ₫', AppColors.success),
                  const Divider(height: 20),
                  _statRow('Trung tâm hoạt động', '8', AppColors.info),
                  const Divider(height: 20),
                  _statRow('Tỉ lệ chuyển đổi', '89%', AppColors.streakOrange),
                ],
              ),
            ),

            // User breakdown
            CustomCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Phân loại người dùng',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _barRow('Free', 780, 1234, AppColors.planFree),
                  const SizedBox(height: 10),
                  _barRow('Basic', 298, 1234, AppColors.planBasic),
                  const SizedBox(height: 10),
                  _barRow('Pro', 156, 1234, AppColors.planPro),
                ],
              ),
            ),

            // Revenue breakdown
            CustomCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Doanh thu theo nguồn',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _revenueRow('B2C Basic', '4,500,000 ₫', AppColors.planBasic),
                  const SizedBox(height: 8),
                  _revenueRow('B2C Pro', '5,200,000 ₫', AppColors.planPro),
                  const SizedBox(height: 8),
                  _revenueRow('B2B Centers', '2,800,000 ₫', AppColors.primary),
                ],
              ),
            ),

            // Export
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đang xuất báo cáo PDF...')),
                  );
                },
                icon: const Icon(Icons.download_rounded),
                label: const Text('Xuất báo cáo PDF'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryDark,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
        Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }

  Widget _barRow(String label, int count, int total, Color color) {
    return Row(
      children: [
        SizedBox(
          width: 50,
          child: Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: count / total,
              minHeight: 8,
              backgroundColor: AppColors.divider,
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text('$count', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }

  Widget _revenueRow(String source, String amount, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 8),
            Text(source, style: const TextStyle(fontSize: 13)),
          ],
        ),
        Text(amount, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }
}