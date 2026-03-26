import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/app_colors.dart';
import '../../widgets/common_widgets.dart';

class RegisterStep2Screen extends StatefulWidget {
  const RegisterStep2Screen({super.key});
  @override
  State<RegisterStep2Screen> createState() => _RegisterStep2ScreenState();
}

class _RegisterStep2ScreenState extends State<RegisterStep2Screen> {
  String _selectedGoal = '';
  String _selectedLevel = '';

  final goals = [
    {'icon': '🏫', 'title': 'Trường học', 'desc': 'Học tập và nghiên cứu'},
    {'icon': '👨‍👩‍👧', 'title': 'Gia đình', 'desc': 'Giao tiếp với người thân'},
    {'icon': '💼', 'title': 'Công việc', 'desc': 'Sử dụng trong công việc'},
  ];

  final levels = [
    {'icon': '🌱', 'title': 'Người mới', 'desc': 'Chưa biết gì về ngôn ngữ ký hiệu'},
    {'icon': '📚', 'title': 'Trung cấp', 'desc': 'Đã biết một số ký hiệu cơ bản'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
          onPressed: () => context.go('/register'),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              // Progress
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: _selectedGoal.isEmpty ? 0.33 : (_selectedLevel.isEmpty ? 0.66 : 1.0),
                  minHeight: 4,
                  backgroundColor: AppColors.divider,
                  valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                ),
              ),
              const SizedBox(height: 24),

              // Title
              Text(
                _selectedGoal.isEmpty ? 'Mục tiêu của bạn?' : 'Trình độ hiện tại?',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                _selectedGoal.isEmpty
                    ? 'Giúp chúng tôi cá nhân hóa trải nghiệm'
                    : 'Chọn trình độ phù hợp với bạn',
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
              ),
              const SizedBox(height: 28),

              // Options
              Expanded(
                child: ListView(
                  children: _selectedGoal.isEmpty
                      ? goals.map((g) => _optionCard(g, _selectedGoal, (v) => setState(() => _selectedGoal = v))).toList()
                      : levels.map((l) => _optionCard(l, _selectedLevel, (v) => setState(() => _selectedLevel = v))).toList(),
                ),
              ),

              // Button
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: CustomButton(
                  text: 'Tiếp tục',
                  icon: Icons.arrow_forward_rounded,
                  onPressed: _canProceed
                      ? () async {
                          if (_selectedGoal.isNotEmpty && _selectedLevel.isEmpty) {
                            // Show level selection
                            setState(() {});
                          } else {
                            final success = await context.read<AuthProvider>().submitOnboarding(
                              goal: _selectedGoal,
                              skillLevel: _selectedLevel,
                            );
                            if (success && context.mounted) {
                              context.go('/quiz');
                            } else if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Có lỗi xảy ra, vui lòng thử lại!')),
                              );
                            }
                          }
                        }
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool get _canProceed {
    if (_selectedGoal.isEmpty) return false;
    if (_selectedGoal.isNotEmpty && _selectedLevel.isEmpty) return true;
    return _selectedLevel.isNotEmpty;
  }

  Widget _optionCard(Map<String, String> item, String selected, ValueChanged<String> onSelect) {
    final isSelected = selected == item['title'];
    return GestureDetector(
      onTap: () => onSelect(item['title']!),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryLight : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.divider,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.1), blurRadius: 12)]
              : null,
        ),
        child: Row(
          children: [
            Text(item['icon']!, style: const TextStyle(fontSize: 36)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['title']!,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item['desc']!,
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                  ),
                ],
              ),
            ),
            AnimatedOpacity(
              opacity: isSelected ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
