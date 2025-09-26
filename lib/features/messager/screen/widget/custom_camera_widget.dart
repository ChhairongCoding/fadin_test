import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class PremiumCameraWidget extends StatefulWidget {
  final Function(XFile) onMediaCaptured;
  final bool allowVideo;

  const PremiumCameraWidget({
    required this.onMediaCaptured,
    this.allowVideo = true,
  });

  @override
  State<PremiumCameraWidget> createState() => _PremiumCameraWidgetState();
}

class _PremiumCameraWidgetState extends State<PremiumCameraWidget> {
  List<CameraDescription> cameras = [];
  CameraController? controller;
  bool isRecording = false;
  bool flashOn = false;
  bool isFrontCamera = false;
  ResolutionPreset resolution = ResolutionPreset.ultraHigh;
  double _zoomLevel = 1.0;
  bool _isLoading = true;
  double _currentScale = 1.0;
  double _baseScale = 1.0;
  Duration _recordingDuration = Duration.zero;
  Timer? _recordingTimer;

  XFile? _capturedFile;
  bool _showPreview = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        await _initializeCamera(cameras[0]);
      }
    } catch (e) {
      debugPrint('Camera error: $e');
      if (mounted) {
        _showErrorSnackbar('Failed to initialize camera');
      }
    }
  }

  Future<void> _initializeCamera(CameraDescription camera) async {
    if (controller != null) {
      await controller!.dispose();
    }

    controller = CameraController(
      camera,
      resolution,
      enableAudio: widget.allowVideo,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    try {
      await controller!.initialize();
      await controller!.lockCaptureOrientation();
      if (mounted) {
        setState(() {
          _isLoading = false;
          _zoomLevel = 1.0;
        });
      }
    } catch (e) {
      debugPrint('Controller error: $e');
      if (mounted) {
        _showErrorSnackbar('Failed to start camera');
      }
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _recordingTimer?.cancel();
    controller?.dispose();
    super.dispose();
  }

  Future<void> _capturePhoto() async {
    if (controller == null || !controller!.value.isInitialized) return;

    try {
      if (flashOn) {
        await controller!.setFlashMode(FlashMode.torch);
        await Future.delayed(const Duration(milliseconds: 200));
      }

      final file = await controller!.takePicture();

      if (flashOn) await controller!.setFlashMode(FlashMode.off);

      setState(() {
        _capturedFile = file;
        _showPreview = true;
      });
    } catch (e) {
      debugPrint('Photo error: $e');
      _showErrorSnackbar('Failed to capture photo');
    }
  }

  Future<void> _toggleRecording() async {
    isRecording ? await _stopRecording() : await _startRecording();
  }

  Future<void> _startRecording() async {
    if (controller == null || !controller!.value.isInitialized) return;

    try {
      await controller!.prepareForVideoRecording();
      await controller!.startVideoRecording();
      setState(() {
        isRecording = true;
        _recordingDuration = Duration.zero;
      });
      _startRecordingTimer();
    } catch (e) {
      debugPrint('Record start error: $e');
      _showErrorSnackbar('Failed to start recording');
    }
  }

  void _startRecordingTimer() {
    _recordingTimer?.cancel();
    _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _recordingDuration += const Duration(seconds: 1);
        });
      }
    });
  }

  Future<void> _stopRecording() async {
    if (controller == null || !controller!.value.isRecordingVideo) return;

    try {
      _recordingTimer?.cancel();
      final file = await controller!.stopVideoRecording();
      setState(() {
        isRecording = false;
        _capturedFile = file;
        _showPreview = true;
      });
    } catch (e) {
      debugPrint('Record stop error: $e');
      _showErrorSnackbar('Failed to save recording');
    }
  }

  void _sendMedia() {
    if (_capturedFile != null) {
      widget.onMediaCaptured(_capturedFile!);
      Navigator.pop(context);
    }
  }

  void _retakeMedia() {
    setState(() {
      _capturedFile = null;
      _showPreview = false;
    });
  }

  Future<void> _switchCamera() async {
    if (cameras.length < 2) return;

    setState(() => _isLoading = true);

    final newCamera = isFrontCamera
        ? cameras.firstWhere((c) => c.lensDirection == CameraLensDirection.back)
        : cameras
            .firstWhere((c) => c.lensDirection == CameraLensDirection.front);

    await _initializeCamera(newCamera);
    setState(() => isFrontCamera = !isFrontCamera);
  }

  Future<void> _toggleFlash() async {
    if (controller == null || !controller!.value.isInitialized) return;

    setState(() => flashOn = !flashOn);
    await controller!.setFlashMode(flashOn ? FlashMode.torch : FlashMode.off);
  }

  void _handleScaleStart(ScaleStartDetails details) {
    _baseScale = _currentScale;
  }

  void _handleScaleUpdate(ScaleUpdateDetails details) {
    if (controller == null || !controller!.value.isInitialized) return;

    _currentScale = (_baseScale * details.scale).clamp(1.0, 10.0);
    controller!.setZoomLevel(_currentScale);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox.expand(
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (_showPreview && _capturedFile != null)
              _buildPreviewScreen()
            else if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (controller != null && controller!.value.isInitialized)
              _buildFullScreenCamera()
            else
              _buildErrorState(),
            if (!_showPreview) _buildAppBar(),
            if (!_showPreview) _buildControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewScreen() {
    final isVideo = _capturedFile!.path.endsWith('.temp') ||
        _capturedFile!.path.endsWith('.mp4');

    return Stack(
      fit: StackFit.expand,
      children: [
        if (isVideo)
          VideoPlayerWidget(videoFile: _capturedFile!)
        else
          Image.file(File(_capturedFile!.path), fit: BoxFit.cover),
        Positioned(
          top: MediaQuery.of(context).padding.top + 16,
          left: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildIconButton(
                  icon: Icons.close,
                  onPressed: _retakeMedia,
                ),
                _buildIconButton(
                  icon: Icons.check,
                  onPressed: _sendMedia,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFullScreenCamera() {
    return GestureDetector(
      onScaleStart: _handleScaleStart,
      onScaleUpdate: _handleScaleUpdate,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CameraPreview(controller!),
          if (isRecording) _buildRecordingIndicator(),
        ],
      ),
    );
  }

  Widget _buildRecordingIndicator() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 16,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.8),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.circle, color: Colors.white, size: 12),
              const SizedBox(width: 8),
              Text(
                'REC ${_formatDuration(_recordingDuration)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.camera_alt, size: 64, color: Colors.white54),
          const SizedBox(height: 24),
          const Text(
            'Camera Unavailable',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text('Go Back'),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Positioned(
      top: MediaQuery.of(context).padding.top,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildIconButton(
              icon: Icons.arrow_back,
              onPressed: () => Navigator.pop(context),
            ),
            if (controller != null &&
                controller!.value.isInitialized &&
                controller!.value.isRecordingVideo)
              _buildIconButton(
                icon: flashOn ? Icons.flash_on : Icons.flash_off,
                onPressed: _toggleFlash,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildControls() {
    return Positioned(
      bottom: MediaQuery.of(context).padding.bottom + 16,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if (widget.allowVideo)
            _buildControlOption(
              icon: isRecording ? Icons.stop : Icons.videocam,
              label: isRecording ? 'STOP' : 'VIDEO',
              isActive: isRecording,
              onTap: _toggleRecording,
            ),
          _buildShutterButton(),
          if (cameras.length > 1)
            _buildControlOption(
              icon: Icons.cameraswitch,
              onTap: _switchCamera,
              label: 'SWITCH',
            ),
        ],
      ),
    );
  }

  Widget _buildShutterButton() {
    return GestureDetector(
      onTap: _capturePhoto,
      child: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withOpacity(0.4),
            width: 4,
          ),
        ),
        child: Center(
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildControlOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isActive = false,
  }) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: isActive ? Colors.red : Colors.black.withOpacity(0.3),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
            ),
          ),
          child: IconButton(
            icon: Icon(icon, color: Colors.white),
            onPressed: onTap,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onPressed,
    double size = 28,
  }) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, size: size, color: Colors.white),
        onPressed: onPressed,
      ),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final XFile videoFile;

  const VideoPlayerWidget({required this.videoFile});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.videoFile.path))
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        VideoPlayer(_controller),
        Center(
          child: IconButton(
            icon: Icon(
              _isPlaying ? Icons.pause : Icons.play_arrow,
              size: 64,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _isPlaying = !_isPlaying;
                _isPlaying ? _controller.play() : _controller.pause();
              });
            },
          ),
        ),
      ],
    );
  }
}
