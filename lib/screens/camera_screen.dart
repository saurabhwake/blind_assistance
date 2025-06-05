import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/semantics.dart'; // Add this line

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with TickerProviderStateMixin {
  bool _isFlashOn = false;
  bool _isFrontCamera = false;
  final bool _isRecording = false;
  bool _showCapturedImage = false;
  late AnimationController _recordingController;
  late AnimationController _captureController;

  @override
  void initState() {
    super.initState();
    _recordingController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _captureController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _recordingController.dispose();
    _captureController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Camera Preview Area
            _buildCameraPreview(),

            // Top Controls
            _buildTopControls(),

            // Bottom Controls
            _buildBottomControls(),

            // Side Controls
            _buildSideControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraPreview() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.grey[900]!,
            Colors.grey[800]!,
            Colors.grey[700]!,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: _showCapturedImage ? _buildCapturedImage() : _buildLivePreview(),
    );
  }

  Widget _buildLivePreview() {
    return Container(
      child: Stack(
        children: [
          // Camera Preview Placeholder
          Center(
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      Icons.camera_alt_rounded,
                      size: 80,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Camera Preview',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                    semanticsLabel: 'Live camera preview for object detection',
                  ),
                ],
              ),
            ),
          ),

          // Recording Indicator
          if (_isRecording) _buildRecordingIndicator(),

          // Focus Assist Grid
          _buildFocusGrid(),
        ],
      ),
    );
  }

  Widget _buildCapturedImage() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 300,
            height: 400,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.photo_rounded,
                    size: 60,
                    color: Colors.white.withOpacity(0.8),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Photo Captured',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildCapturedImageButton(
                icon: Icons.close_rounded,
                label: 'Retake',
                onTap: () {
                  setState(() {
                    _showCapturedImage = false;
                  });
                },
              ),
              _buildCapturedImageButton(
                icon: Icons.check_rounded,
                label: 'Use Photo',
                onTap: () {
                  _analyzeImage();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCapturedImageButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Semantics(
      label: label,
      button: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecordingIndicator() {
    return Positioned(
      top: 20,
      left: 20,
      child: AnimatedBuilder(
        animation: _recordingController,
        builder: (context, child) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.9),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(_recordingController.value),
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  'REC',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFocusGrid() {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: CustomPaint(
        painter: GridPainter(),
      ),
    );
  }

  Widget _buildTopControls() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black.withOpacity(0.7),
              Colors.transparent,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Row(
          children: [
            // Removed back arrow button here
            Expanded(
              child: Center(
                child: Text(
                  'Camera',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            _buildTopButton(
              icon:
                  _isFlashOn ? Icons.flash_on_rounded : Icons.flash_off_rounded,
              onTap: _toggleFlash,
              semanticsLabel: _isFlashOn ? 'Turn flash off' : 'Turn flash on',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomControls() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.8),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildControlButton(
              icon: Icons.photo_library_rounded,
              onTap: _openGallery,
              semanticsLabel: 'Open photo gallery',
            ),
            _buildCaptureButton(),
            _buildControlButton(
              icon: Icons.flip_camera_ios_rounded,
              onTap: _switchCamera,
              semanticsLabel: 'Switch between front and rear camera',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSideControls() {
    return Positioned(
      right: 20,
      top: 0,
      bottom: 0,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSideButton(
              icon: Icons.zoom_in_rounded,
              onTap: () {},
              semanticsLabel: 'Zoom in',
            ),
            SizedBox(height: 20),
            _buildSideButton(
              icon: Icons.zoom_out_rounded,
              onTap: () {},
              semanticsLabel: 'Zoom out',
            ),
            SizedBox(height: 20),
            _buildSideButton(
              icon: Icons.tune_rounded,
              onTap: _showCameraSettings,
              semanticsLabel: 'Camera settings',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopButton({
    required IconData icon,
    required VoidCallback onTap,
    required String semanticsLabel,
  }) {
    return Semantics(
      label: semanticsLabel,
      button: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 24,
          ),
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onTap,
    required String semanticsLabel,
  }) {
    return Semantics(
      label: semanticsLabel,
      button: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.3)),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 28,
          ),
        ),
      ),
    );
  }

  Widget _buildCaptureButton() {
    return Semantics(
      label: 'Capture photo for object detection',
      button: true,
      child: GestureDetector(
        onTap: _capturePhoto,
        child: AnimatedBuilder(
          animation: _captureController,
          builder: (context, child) {
            return Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(
                  color: Color(0xFF4A90E2),
                  width: 4,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Transform.scale(
                scale: 1.0 - (_captureController.value * 0.1),
                child: Icon(
                  Icons.camera_alt_rounded,
                  color: Color(0xFF4A90E2),
                  size: 32,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSideButton({
    required IconData icon,
    required VoidCallback onTap,
    required String semanticsLabel,
  }) {
    return Semantics(
      label: semanticsLabel,
      button: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 24,
          ),
        ),
      ),
    );
  }

  void _toggleFlash() {
    HapticFeedback.lightImpact();
    setState(() {
      _isFlashOn = !_isFlashOn;
    });

    SemanticsService.announce(
      _isFlashOn ? 'Flash turned on' : 'Flash turned off',
      TextDirection.ltr,
    );
  }

  void _switchCamera() {
    HapticFeedback.lightImpact();
    setState(() {
      _isFrontCamera = !_isFrontCamera;
    });

    SemanticsService.announce(
      _isFrontCamera ? 'Switched to front camera' : 'Switched to rear camera',
      TextDirection.ltr,
    );
  }

  void _capturePhoto() async {
    HapticFeedback.heavyImpact();
    _captureController.forward().then((_) {
      _captureController.reverse();
    });
    // Simulate capture delay
    await Future.delayed(Duration(milliseconds: 500));

    setState(() {
      _showCapturedImage = true;
    });

    SemanticsService.announce(
      'Photo captured successfully. Choose to retake or use photo for analysis',
      TextDirection.ltr,
    );
  }

  void _openGallery() {
    HapticFeedback.lightImpact();
    SemanticsService.announce(
      'Opening photo gallery',
      TextDirection.ltr,
    );
    // Implement gallery opening logic
  }

  void _showCameraSettings() {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildSettingsSheet(),
    );
  }

  Widget _buildSettingsSheet() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Camera Settings',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 20),
          _buildSettingOption('HDR Mode', Icons.hdr_on_rounded),
          _buildSettingOption('Timer', Icons.timer_rounded),
          _buildSettingOption('Grid Lines', Icons.grid_on_rounded),
          _buildSettingOption('Voice Commands', Icons.mic_rounded),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSettingOption(String title, IconData icon) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Color(0xFF4A90E2).withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Color(0xFF4A90E2), size: 20),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Switch(
            value: false,
            onChanged: (value) {},
            activeColor: Color(0xFF4A90E2),
          ),
        ],
      ),
    );
  }

  void _analyzeImage() {
    Navigator.pop(context);
    SemanticsService.announce(
      'Starting object detection analysis',
      TextDirection.ltr,
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..strokeWidth = 1;

    // Vertical lines
    canvas.drawLine(
      Offset(size.width / 3, 0),
      Offset(size.width / 3, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(2 * size.width / 3, 0),
      Offset(2 * size.width / 3, size.height),
      paint,
    );

    // Horizontal lines
    canvas.drawLine(
      Offset(0, size.height / 3),
      Offset(size.width, size.height / 3),
      paint,
    );
    canvas.drawLine(
      Offset(0, 2 * size.height / 3),
      Offset(size.width, 2 * size.height / 3),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
