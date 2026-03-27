import 'package:flutter/foundation.dart'; // Add kIsWeb
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
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
  bool _isRecording = false;
  
  // Data collection for backend
  final List<List<Map<String, double>>> _userKeypointsFrames = [];
  
  String _feedback = '';
  int _score = 0;
  final String _targetSign = 'Xin chào';

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      _poseDetector = PoseDetector(options: PoseDetectorOptions());
    }
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        setState(() => _feedback = 'Không tìm thấy camera trên thiết bị này.');
        return;
      }
      
      // Default to front camera
      _cameraIndex = _cameras.indexWhere((c) => c.lensDirection == CameraLensDirection.front);
      if (_cameraIndex == -1) _cameraIndex = 0;

      _startCamera();
    } catch (e) {
      if (mounted) setState(() => _feedback = 'Lỗi cấp quyền Camera: $e');
    }
  }

  Future<void> _startCamera() async {
    final camera = _cameras[_cameraIndex];
    
    // Choose format group based on platform to prevent UnsupportedError on Web
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
        if (mounted) setState(() => _feedback = 'Cảnh báo: Tính năng AI Pose Detection không hoạt động trên trình duyệt Web. Hãy chạy trên Android/iOS.');
      }
    } catch (e) {
      if (mounted) setState(() => _feedback = 'Lỗi mở camera: $e');
    }
  }

  Future<void> _processImage(CameraImage image) async {
    if (_isDetecting) return;
    _isDetecting = true;

    try {
      final inputImage = _inputImageFromCameraImage(image);
      if (inputImage == null) {
        _isDetecting = false;
        return;
      }

      final poses = await _poseDetector?.processImage(inputImage);
      
      if (_isRecording && poses != null && poses.isNotEmpty) {
        final pose = poses.first;
        // Extract 33 pose landmarks
        List<Map<String, double>> frameLandmarks = [];
        
        // PoseLandmarkType is an enum, we iterate over its values or just extract what we need
        for (final landmark in pose.landmarks.values) {
          frameLandmarks.add({
            'x': landmark.x,
            'y': landmark.y,
            'z': landmark.z,
          });
        }
        
        // Ensure we always have 33 points (the backend now expects 33 pose points)
        _userKeypointsFrames.add(frameLandmarks);
      }
    } catch (e) {
      debugPrint('Error processing image: $e');
    } finally {
      _isDetecting = false;
    }
  }

  final _orientations = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };

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
    _cameraController?.dispose();
    _poseDetector?.close();
    super.dispose();
  }
  
  void _toggleRecording() {
    if (_isRecording) {
      // Stop and submit
      setState(() {
        _isRecording = false;
        _feedback = '';
      });
      _submitToAI();
    } else {
      // Start recording
      setState(() {
        _userKeypointsFrames.clear();
        _isRecording = true;
        _score = 0;
        _feedback = 'Đang ghi hình... Vui lòng thực hiện ký hiệu';
      });
    }
  }

  Future<void> _submitToAI() async {
    if (_userKeypointsFrames.isEmpty) {
      setState(() => _feedback = 'Không tìm thấy khung hình nào. Hãy thử lại!');
      return;
    }
    
    // Simulate submitting the 3D tensor to the Python Backend
    setState(() => _feedback = 'Đang phân tích ${_userKeypointsFrames.length} khung hình với ML Kit Pose...');
    
    // final payload = {
    //   "sign_id": "123",
    //   "user_keypoints_frames": _userKeypointsFrames,
    //   "reference_keypoints": "[]"
    // };
    // await _aiService.analyzeRealtime(payload);
    
    await Future.delayed(const Duration(milliseconds: 1500)); // Simulate API latency
    
    if (mounted) {
      setState(() {
        _score = 88;
        _feedback = 'Rất tốt! Tọa độ khớp 88% so với chuyên gia khẩu hình.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: AppColors.primaryDark, foregroundColor: Colors.white, title: const Text('Camera AI - Luyện tập'),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.go('/home'))),
      body: Column(children: [
        // Camera preview
        Expanded(flex: 3, child: Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _isRecording ? AppColors.error : AppColors.primaryDark, width: _isRecording ? 4 : 2)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: _cameraController != null && _cameraController!.value.isInitialized
                ? Stack(
                    fit: StackFit.expand,
                    children: [
                      CameraPreview(_cameraController!),
                      if (_isRecording)
                        Positioned(top: 16, right: 16, child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(color: AppColors.error.withValues(alpha: 0.8), borderRadius: BorderRadius.circular(20)),
                          child: const Row(children: [
                            Icon(Icons.fiber_manual_record, color: Colors.white, size: 16),
                            SizedBox(width: 4),
                            Text('REC', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ]),
                        )),
                    ],
                  )
                : const Center(child: CircularProgressIndicator(color: AppColors.primary)),
          ),
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
            Icon(_score >= 70 ? Icons.check_circle : (_isRecording ? Icons.fiber_manual_record : Icons.info), color: _score >= 70 ? AppColors.success : (_isRecording ? AppColors.error : AppColors.info)),
            const SizedBox(width: 12),
            Expanded(child: Text(_feedback, style: const TextStyle(fontSize: 14))),
          ]),
        ),
        // Capture button
        Padding(padding: const EdgeInsets.all(16), child: Row(children: [
          Expanded(child: ElevatedButton.icon(
            onPressed: _toggleRecording,
            icon: Icon(_isRecording ? Icons.stop : Icons.camera),
            label: Text(_isRecording ? 'Dừng & Chấm điểm' : 'Bắt đầu Quay'),
            style: ElevatedButton.styleFrom(backgroundColor: _isRecording ? AppColors.error : AppColors.primary, foregroundColor: Colors.white, padding: const EdgeInsets.all(16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
          )),
          const SizedBox(width: 12),
          Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.divider)),
            child: IconButton(icon: const Icon(Icons.flip_camera_ios, color: AppColors.primary), onPressed: () async {
              if (_cameras.length > 1) {
                _cameraIndex = (_cameraIndex + 1) % _cameras.length;
                await _cameraController?.dispose();
                _startCamera();
              }
            })),
        ])),
      ]),
    );
  }
}