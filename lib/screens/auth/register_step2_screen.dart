import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/app_colors.dart';

class RegisterStep2Screen extends StatefulWidget {
  const RegisterStep2Screen({super.key});
  @override
  State<RegisterStep2Screen> createState() => _RegisterStep2ScreenState();
}

class _RegisterStep2ScreenState extends State<RegisterStep2Screen> {
  String _selectedGoal = '';
  String _selectedLevel = '';

  final goals = [
    {'icon': '🏫', 'title': 'Học Tập', 'desc': 'Môi trường học tập'},
    {'icon': '💼', 'title': 'Công Việc', 'desc': 'Môi trường công việc'},
  ];

  final levels = [
    {'icon': '🌱', 'title': 'Người mới', 'desc': 'Chưa biết gì về ngôn ngữ ký hiệu'},
    {'icon': '📚', 'title': 'Trung cấp', 'desc': 'Đã biết một số ký hiệu cơ bản'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // ── Gradient Header ──
          Container(
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
                padding: const EdgeInsets.fromLTRB(8, 8, 16, 20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                          onPressed: () => context.go('/register'),
                        ),
                        const Expanded(
                          child: Text(
                            'Mục tiêu học tập',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: _selectedGoal.isEmpty ? 0.33 : (_selectedLevel.isEmpty ? 0.66 : 1.0),
                          minHeight: 6,
                          backgroundColor: Colors.white.withValues(alpha: 0.2),
                          valueColor: const AlwaysStoppedAnimation(Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Content ──
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  Text(
                    _selectedGoal.isEmpty ? 'Mục tiêu của bạn?' : 'Trình độ hiện tại?',
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _selectedGoal.isEmpty
                        ? 'Giúp chúng tôi cá nhân hóa trải nghiệm'
                        : 'Chọn trình độ phù hợp với bạn',
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: ListView(
                      children: _selectedGoal.isEmpty
                          ? goals.map((g) => _optionCard(g, _selectedGoal, (v) => setState(() => _selectedGoal = v))).toList()
                          : levels.map((l) => _optionCard(l, _selectedLevel, (v) => setState(() => _selectedLevel = v))).toList(),
                    ),
                  ),
                  // ── Button ──
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _canProceed
                            ? () async {
                                if (_selectedGoal.isNotEmpty && _selectedLevel.isEmpty) {
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
                                      const SnackBar(content: Text('Có lỗi, vui lòng thử lại!')),
                                    );
                                  }
                                }
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accentOrange,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: AppColors.cardBorder,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                          elevation: 0,
                        ),
                        child: const Text('Bắt đầu thiết lập', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.06) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.cardBorder,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Text(item['icon']!, style: const TextStyle(fontSize: 36)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item['title']!, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: isSelected ? AppColors.primary : AppColors.textPrimary)),
                  const SizedBox(height: 2),
                  Text(item['desc']!, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                ],
              ),
            ),
            AnimatedOpacity(
              opacity: isSelected ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Container(
                width: 28, height: 28,
                decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                child: const Icon(Icons.check, color: Colors.white, size: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
