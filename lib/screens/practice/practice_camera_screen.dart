import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../utils/app_colors.dart';

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
      appBar: AppBar(backgroundColor: AppColors.primaryDark, foregroundColor: Colors.white, title: const Text('Camera AI - Luyện tập'),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.go('/home'))),
      body: Column(children: [
        // Camera preview placeholder
        Expanded(flex: 3, child: Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.primaryDark, width: 2)),
          child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.camera_alt, size: 64, color: Colors.white.withValues(alpha: 0.5)),
            const SizedBox(height: 12),
            Text('Camera Preview', style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 16)),
            const SizedBox(height: 8),
            Text('(Tích hợp CameraController ở đây)', style: TextStyle(color: Colors.white.withValues(alpha: 0.3), fontSize: 12)),
          ])),
        )),
        // Target sign
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(12)),
          child: Row(children: [
            const Text('🎯', style: TextStyle(fontSize: 28)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Ký hiệu cần thực hiện:', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
              Text(_targetSign, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
            ])),
            if (_score > 0) Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: _score >= 70 ? AppColors.success : AppColors.warning, borderRadius: BorderRadius.circular(20)),
              child: Text('$_score%', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
          ]),
        ),
        // Feedback
        if (_feedback.isNotEmpty) Container(
          margin: const EdgeInsets.all(16), padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(_score >= 70 ? Icons.check_circle : Icons.info, color: _score >= 70 ? AppColors.success : AppColors.info),
            const SizedBox(width: 12),
            Expanded(child: Text(_feedback, style: const TextStyle(fontSize: 14))),
          ]),
        ),
        // Capture button
        Padding(padding: const EdgeInsets.all(16), child: Row(children: [
          Expanded(child: ElevatedButton.icon(
            onPressed: _isAnalyzing ? null : _captureAndAnalyze,
            icon: _isAnalyzing ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Icon(Icons.camera),
            label: Text(_isAnalyzing ? 'Đang phân tích...' : 'Chụp & Phân tích'),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, padding: const EdgeInsets.all(16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
          )),
          const SizedBox(width: 12),
          Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.divider)),
            child: IconButton(icon: const Icon(Icons.flip_camera_ios, color: AppColors.primary), onPressed: (){})),
        ])),
      ]),
    );
  }

  Future<void> _captureAndAnalyze() async {
    setState(() { _isAnalyzing = true; _feedback = ''; });
    // TODO: Capture image from CameraController and convert to Uint8List
    // final image = await _cameraController.takePicture();
    // final bytes = await image.readAsBytes();
    // final result = await _gemini.getPracticeFeedback(imageBytes: bytes, targetSign: _targetSign);
    await Future.delayed(const Duration(seconds: 2)); // Simulate
    setState(() { _isAnalyzing = false; _score = 78; _feedback = 'Tốt lắm! Tư thế tay gần đúng. Hãy mở rộng các ngón tay hơn một chút.'; });
  }
}