import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/center_provider.dart';
import '../../utils/app_colors.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/center_bottom_nav_bar.dart';

class CenterReportsScreen extends StatelessWidget {
  const CenterReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final center = context.watch<CenterProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: const Text('Báo cáo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overview Stats Card
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
                        'Thống kê tổng quan',
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _statRow('TB độ chính xác', '${center.avgAccuracy}%', AppColors.primary),
                  const Divider(height: 20),
                  _statRow('Tổng t.luyện tập', '${center.totalPracticeMinutes}', AppColors.info),
                  const Divider(height: 20),
                  _statRow('Học viên hoạt động', '${center.activeStudents}/${center.totalSeats}', AppColors.success),
                  const Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Số học phí đã nhận',
                        style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.warningLight,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Chưa hết',
                          style: TextStyle(color: AppColors.warning, fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Report Period Card
            CustomCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Báo cáo',
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.calendar_today, size: 14, color: AppColors.primary),
                            const SizedBox(width: 6),
                            Text(
                              _getDateRange(),
                              style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Report metrics
                  _reportMetric('Học viên mới', '+${center.newStudentsThisMonth}', AppColors.info),
                  const SizedBox(height: 14),
                  _reportMetric('Tỉ lệ hoàn thành', '${center.completionRate}%', AppColors.success),
                  const SizedBox(height: 14),
                  _reportMetric('Trung bình chính xác', '${center.reportAccuracy}%', AppColors.primary),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Download Report Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đang tải báo cáo...')),
                  );
                },
                icon: const Icon(Icons.download_rounded),
                label: const Text('Tải Báo cáo'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: const CenterBottomNavBar(currentIndex: 3),
    );
  }

  String _getDateRange() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, 1);
    return '${start.day}/${start.month}/${start.year} - ${now.day}/${now.month}/${now.year}';
  }

  Widget _statRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
        Text(
          value,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }

  Widget _reportMetric(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color),
          ),
        ),
      ],
    );
  }
}
