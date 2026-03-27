import 'dart:async';
import 'package:flutter/foundation.dart';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import '../../services/practice_service.dart';
import '../../utils/app_colors.dart';

class PracticeCameraScreen extends StatefulWidget {
  const PracticeCameraScreen({super.key});
  @override
  State<PracticeCameraScreen> createState() => _PracticeCameraScreenState();
}

class _PracticeCameraScreenState extends State<PracticeCameraScreen> {
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  int _cameraIndex = 0;

  PoseDetector? _poseDetector;
  bool _isDetecting = false;
  bool _isPracticing = false;
  bool _isAnalyzing = false;

  final PracticeService _practiceService = PracticeService();

  // Data collection for real-time analysis
  final List<List<Map<String, double>>> _frameBuffer = [];

  // Real-time feedback state
  double _overallScore = 0.0;
  Map<String, double> _dimensionScores = {};
  String? _geminiCoaching;
  String _statusText = 'Nhấn "Bắt đầu" để luyện tập';

  // Timer for periodic analysis
  Timer? _analysisTimer;

  // Sign info (passed via GoRouter extra)
  String _targetSign = '';
  String _referenceKeypoints = '[]';

  final _orientations = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      _poseDetector = PoseDetector(options: PoseDetectorOptions());
    }
    _initializeCamera();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final extra = GoRouterState.of(context).extra;
    if (extra is Map<String, dynamic>) {
      _targetSign = extra['signName'] ?? _targetSign;
      _referenceKeypoints = extra['referenceKeypoints'] ?? _referenceKeypoints;
    }
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        setState(() => _statusText = 'Không tìm thấy camera trên thiết bị này.');
        return;
      }

      _cameraIndex = _cameras.indexWhere((c) => c.lensDirection == CameraLensDirection.front);
      if (_cameraIndex == -1) _cameraIndex = 0;

      _startCamera();
    } catch (e) {
      if (mounted) {
        setState(() => _statusText = '📷 Không thể truy cập camera. Vui lòng cấp quyền camera trong cài đặt.');
      }
    }
  }

  Future<void> _startCamera() async {
    final camera = _cameras[_cameraIndex];

    ImageFormatGroup formatGroup = ImageFormatGroup.unknown;
    if (!kIsWeb) {
      formatGroup = Platform.isAndroid ? ImageFormatGroup.nv21 : ImageFormatGroup.bgra8888;
    }

    _cameraController = CameraController(
      camera,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: formatGroup,
    );

    try {
      await _cameraController!.initialize();
      if (!mounted) return;

      setState(() {});

      if (!kIsWeb) {
        _cameraController!.startImageStream((image) => _processImage(image));
      } else {
        if (mounted) setState(() => _statusText = 'AI Pose Detection không hoạt động trên Web. Hãy chạy trên Android/iOS.');
      }
    } catch (e) {
      if (mounted) {
        final msg = e.toString().contains('cameraNotFound') || e.toString().contains('No camera')
            ? '📷 Thiết bị này không có camera. Vui lòng sử dụng điện thoại hoặc máy tính bảng có camera.'
            : '📷 Không thể khởi động camera. Hãy kiểm tra xem ứng dụng khác có đang dùng camera không.';
        setState(() => _statusText = msg);
      }
    }
  }

  Future<void> _processImage(CameraImage image) async {
    if (_isDetecting || !_isPracticing) return;
    _isDetecting = true;

    try {
      final inputImage = _inputImageFromCameraImage(image);
      if (inputImage == null) {
        _isDetecting = false;
        return;
      }

      final poses = await _poseDetector?.processImage(inputImage);

      if (poses != null && poses.isNotEmpty) {
        final pose = poses.first;
        List<Map<String, double>> frameLandmarks = [];

        for (final landmark in pose.landmarks.values) {
          frameLandmarks.add({
            'x': landmark.x,
            'y': landmark.y,
            'z': landmark.z,
          });
        }

        _frameBuffer.add(frameLandmarks);
      }
    } catch (e) {
      debugPrint('Error processing image: $e');
    } finally {
      _isDetecting = false;
    }
  }

  void _startPractice() {
    setState(() {
      _isPracticing = true;
      _overallScore = 0.0;
      _dimensionScores = {};
      _geminiCoaching = null;
      _statusText = 'Đang phân tích... Hãy thực hiện ký hiệu';
      _frameBuffer.clear();
    });

    // Start periodic analysis every 2 seconds
    _analysisTimer = Timer.periodic(const Duration(seconds: 2), (_) => _analyzeCurrentFrames());
  }

  void _stopPractice() {
    _analysisTimer?.cancel();
    _analysisTimer = null;

    setState(() {
      _isPracticing = false;
      _statusText = 'Đang hoàn tất...';
    });

    // Navigate to feedback screen with final results
    final feedbacks = _dimensionScores.entries.map((e) => {
      'type': e.key,
      'score': e.value,
      'message': '',
    }).toList();

    context.go('/feedback', extra: {
      'overallScore': _overallScore,
      'feedbacks': feedbacks,
      'geminiFeedback': _geminiCoaching,
    });
  }

  Future<void> _analyzeCurrentFrames() async {
    if (_isAnalyzing || _frameBuffer.isEmpty || !_isPracticing) return;
    _isAnalyzing = true;

    // Take current buffer and clear for next batch
    final framesToAnalyze = List<List<Map<String, double>>>.from(_frameBuffer);
    _frameBuffer.clear();

    try {
      final result = await _practiceService.analyzeRealtime(
        signName: _targetSign,
        keypoints: framesToAnalyze,
        referenceKeypoints: _referenceKeypoints,
      );

      if (result != null && mounted && _isPracticing) {
        setState(() {
          _overallScore = (result['overall_score'] as num?)?.toDouble() ?? 0.0;

          // Parse dimension scores from feedbacks
          final fbs = result['feedbacks'] as List<dynamic>?;
          if (fbs != null) {
            for (final fb in fbs) {
              final type = fb['type'] as String? ?? '';
              final score = (fb['score'] as num?)?.toDouble() ?? 0.0;
              _dimensionScores[type] = score;
            }
          }

          // Gemini coaching (may be null if score is good or cooldown)
          final coaching = result['gemini_coaching'] as String?;
          if (coaching != null && coaching.isNotEmpty) {
            _geminiCoaching = coaching;
          }

          _statusText = _overallScore >= 0.7
              ? 'Tốt lắm! Tiếp tục giữ vững 💪'
              : 'Hãy xem gợi ý bên dưới 👇';
        });
      }
    } catch (e) {
      debugPrint('Realtime analysis error: $e');
    } finally {
      _isAnalyzing = false;
    }
  }

  InputImage? _inputImageFromCameraImage(CameraImage image) {
    if (kIsWeb) return null;
    if (_cameraController == null) return null;
    final camera = _cameras[_cameraIndex];
    final sensorOrientation = camera.sensorOrientation;

    InputImageRotation? rotation;
    if (Platform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    } else if (Platform.isAndroid) {
      var rotationCompensation = _orientations[_cameraController!.value.deviceOrientation];
      if (rotationCompensation == null) return null;
      if (camera.lensDirection == CameraLensDirection.front) {
        rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
      } else {
        rotationCompensation = (sensorOrientation - rotationCompensation + 360) % 360;
      }
      rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
    }

    if (rotation == null) return null;

    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    if (format == null) return null;

    if (image.planes.isEmpty) return null;

    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final Size imageSize = Size(image.width.toDouble(), image.height.toDouble());

    final metadata = InputImageMetadata(
      size: imageSize,
      rotation: rotation,
      format: format,
      bytesPerRow: image.planes[0].bytesPerRow,
    );

    return InputImage.fromBytes(bytes: bytes, metadata: metadata);
  }

  @override
  void dispose() {
    _analysisTimer?.cancel();
    _cameraController?.dispose();
    _poseDetector?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scorePercent = (_overallScore * 100).round();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
        title: const Text('Camera AI - Luyện tập'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            _analysisTimer?.cancel();
            context.go('/home');
          },
        ),
      ),
      body: Column(children: [
        // Camera preview with score overlay
        Expanded(
          flex: 3,
          child: Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _isPracticing
                    ? (_overallScore >= 0.7 ? AppColors.success : AppColors.error)
                    : AppColors.primaryDark,
                width: _isPracticing ? 3 : 2,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: _cameraController != null && _cameraController!.value.isInitialized
                  ? Stack(
                      fit: StackFit.expand,
                      children: [
                        CameraPreview(_cameraController!),

                        // Real-time score overlay (top-right)
                        if (_isPracticing && _overallScore > 0)
                          Positioned(
                            top: 12,
                            right: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: (_overallScore >= 0.7 ? AppColors.success : _overallScore >= 0.5 ? AppColors.warning : AppColors.error).withValues(alpha: 0.9),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '$scorePercent%',
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            ),
                          ),

                        // REC indicator (top-left)
                        if (_isPracticing)
                          Positioned(
                            top: 12,
                            left: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.error.withValues(alpha: 0.8),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.fiber_manual_record, color: Colors.white, size: 14),
                                  SizedBox(width: 4),
                                  Text('LIVE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                                ],
                              ),
                            ),
                          ),

                        // Dimension scores (bottom overlay)
                        if (_isPracticing && _dimensionScores.isNotEmpty)
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [Colors.black.withValues(alpha: 0.7), Colors.transparent],
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: _dimensionScores.entries.map((e) {
                                  final ok = e.value >= 0.7;
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        ok ? Icons.check_circle : Icons.cancel,
                                        color: ok ? AppColors.success : AppColors.error,
                                        size: 20,
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        _shortLabel(e.key),
                                        style: const TextStyle(color: Colors.white, fontSize: 10),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                      ],
                    )
                  : const Center(child: CircularProgressIndicator(color: AppColors.primary)),
            ),
          ),
        ),

        // Target sign info
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(12)),
          child: Row(children: [
            const Text('🎯', style: TextStyle(fontSize: 28)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Ký hiệu cần thực hiện:', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                Text(_targetSign, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
              ]),
            ),
            if (_overallScore > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _overallScore >= 0.7 ? AppColors.success : AppColors.warning,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$scorePercent%',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
          ]),
        ),

        // Gemini AI coaching (appears when score is low)
        if (_geminiCoaching != null && _geminiCoaching!.isNotEmpty)
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8E1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.auto_awesome, color: AppColors.warning, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _geminiCoaching!,
                    style: const TextStyle(fontSize: 14, height: 1.4),
                  ),
                ),
              ],
            ),
          ),

        // Status text
        if (_statusText.isNotEmpty && (_geminiCoaching == null || _geminiCoaching!.isEmpty))
          Container(
            margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                Icon(
                  _isPracticing ? Icons.insights : Icons.info_outline,
                  color: _isPracticing ? AppColors.primary : AppColors.info,
                ),
                const SizedBox(width: 12),
                Expanded(child: Text(_statusText, style: const TextStyle(fontSize: 14))),
              ],
            ),
          ),

        // Action buttons
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _isPracticing ? _stopPractice : _startPractice,
                icon: Icon(_isPracticing ? Icons.check_circle : Icons.play_arrow),
                label: Text(_isPracticing ? 'Hoàn thành' : 'Bắt đầu'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isPracticing ? AppColors.success : AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.divider),
              ),
              child: IconButton(
                icon: const Icon(Icons.flip_camera_ios, color: AppColors.primary),
                onPressed: () async {
                  if (_cameras.length > 1) {
                    _cameraIndex = (_cameraIndex + 1) % _cameras.length;
                    await _cameraController?.dispose();
                    _startCamera();
                  }
                },
              ),
            ),
          ]),
        ),
      ]),
    );
  }

  String _shortLabel(String type) {
    switch (type) {
      case 'HandShape': return 'Tay';
      case 'Movement': return 'Động';
      case 'Location': return 'Vị trí';
      case 'PalmOrientation': return 'Hướng';
      default: return type;
    }
  }
}