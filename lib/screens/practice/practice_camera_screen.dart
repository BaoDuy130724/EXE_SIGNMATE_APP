import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../utils/app_colors.dart';
import '../../widgets/bottom_nav_bar.dart';

class PracticeCameraScreen extends StatefulWidget {
  const PracticeCameraScreen({super.key});
  @override
  State<PracticeCameraScreen> createState() => _PracticeCameraScreenState();
}

class _PracticeCameraScreenState extends State<PracticeCameraScreen> {
  bool _isAnalyzing = false;
  String _feedback = '';
  int _score = 0;
  final String _targetSign = 'Xin chào';

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
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                      onPressed: () => context.go('/home'),
                    ),
                    const Expanded(
                      child: Text(
                        'Luyện tập AI',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
            ),
          ),

          // ── Camera Preview ──
          Expanded(
            flex: 3,
            child: Container(
              margin: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.4), width: 2),
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.camera_alt, size: 56, color: Colors.white.withValues(alpha: 0.4)),
                    const SizedBox(height: 12),
                    Text('Camera Preview', style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 16)),
                  ],
                ),
              ),
            ),
          ),

          // ── Target Sign ──
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(child: Text('🎯', style: TextStyle(fontSize: 22))),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Ký hiệu cần thực hiện:', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      Text(_targetSign, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
                    ],
                  ),
                ),
                if (_score > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: _score >= 70 ? AppColors.success : AppColors.accentOrange,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text('$_score%', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
              ],
            ),
          ),

          // ── Feedback ──
          if (_feedback.isNotEmpty)
            Container(
              margin: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: _score >= 70 ? AppColors.success.withValues(alpha: 0.08) : AppColors.accentOrange.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: _score >= 70 ? AppColors.success.withValues(alpha: 0.3) : AppColors.accentOrange.withValues(alpha: 0.3)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(_score >= 70 ? Icons.check_circle : Icons.info, color: _score >= 70 ? AppColors.success : AppColors.accentOrange, size: 20),
                  const SizedBox(width: 10),
                  Expanded(child: Text(_feedback, style: const TextStyle(fontSize: 14))),
                ],
              ),
            ),

          // ── Capture Button ──
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: _isAnalyzing ? null : _captureAndAnalyze,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                        elevation: 0,
                      ),
                      icon: _isAnalyzing
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Icon(Icons.camera),
                      label: Text(_isAnalyzing ? 'Đang phân tích...' : 'Chụp & Phân tích', style: const TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  height: 52,
                  width: 52,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: IconButton(icon: const Icon(Icons.flip_camera_ios, color: AppColors.primary), onPressed: () {}),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 2),
    );
  }

  Future<void> _captureAndAnalyze() async {
    setState(() { _isAnalyzing = true; _feedback = ''; });
    await Future.delayed(const Duration(seconds: 2));
    setState(() { _isAnalyzing = false; _score = 78; _feedback = 'Tốt lắm! Tư thế tay gần đúng. Hãy mở rộng các ngón tay hơn một chút.'; });
  }
}