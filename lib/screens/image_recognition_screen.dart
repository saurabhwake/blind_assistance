import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';

class ImageRecognitionScreen extends StatefulWidget {
  const ImageRecognitionScreen({super.key});

  @override
  _ImageRecognitionScreenState createState() => _ImageRecognitionScreenState();
}

class _ImageRecognitionScreenState extends State<ImageRecognitionScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _processingController;

  String? _selectedImageType;
  bool _isProcessing = false;
  List<Map<String, dynamic>> _recognitionResults = [];

  // Modern Vibrant Color Scheme (matching home screen)
  static const Color primaryBackground = Color(0xFFF8FAFF);
  static const Color secondaryBackground = Color(0xFFFFFFFF);
  static const Color primaryText = Color(0xFF1A1B3A);
  static const Color secondaryText = Color(0xFF6B7280);
  static const Color vibrantBlue = Color(0xFF3B82F6);
  static const Color vibrantPurple = Color(0xFF8B5CF6);
  static const Color vibrantGreen = Color(0xFF10B981);
  static const Color vibrantOrange = Color(0xFFF59E0B);
  static const Color lightBlue = Color(0xFFDBEAFE);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );
    _processingController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _processingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackground,
      body: Stack(
        children: [
          // Modern Background
          _buildModernBackground(),

          // Main Content
          SafeArea(
            child: Column(
              children: [
                _buildModernHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 32),
                        _buildModernTitle(),
                        SizedBox(height: 32),
                        _buildModernImageSection(),
                        SizedBox(height: 24),
                        _buildModernActionButtons(),
                        if (_recognitionResults.isNotEmpty) ...[
                          SizedBox(height: 32),
                          _buildResultsSection(),
                        ],
                        SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernBackground() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primaryBackground,
            lightBlue.withOpacity(0.3),
            vibrantPurple.withOpacity(0.1),
            primaryBackground,
          ],
          stops: [0.0, 0.4, 0.7, 1.0],
        ),
      ),
    );
  }

  Widget _buildModernHeader() {
    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset(0, -1),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut,
      )),
      child: Container(
        margin: EdgeInsets.all(24),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    secondaryBackground.withOpacity(0.9),
                    vibrantBlue.withOpacity(0.1),
                    vibrantPurple.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: vibrantBlue.withOpacity(0.2),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: vibrantBlue.withOpacity(0.1),
                    blurRadius: 20,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Back arrow removed here
                  Expanded(
                    child: Text(
                      'Image Recognition',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: primaryText,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [vibrantBlue, vibrantPurple],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.auto_awesome_rounded,
                      color: secondaryBackground,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModernTitle() {
    return FadeTransition(
      opacity: Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(0.3, 1.0, curve: Curves.easeOut),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'AI Object Detection 🔍',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: primaryText,
              height: 1.2,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Simulate image capture and recognition with AI',
            style: TextStyle(
              fontSize: 16,
              color: secondaryText,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernImageSection() {
    return SizedBox(
      width: double.infinity,
      height: 300,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  secondaryBackground.withOpacity(0.9),
                  vibrantBlue.withOpacity(0.05),
                  vibrantPurple.withOpacity(0.03),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: vibrantBlue.withOpacity(0.2),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: vibrantBlue.withOpacity(0.1),
                  blurRadius: 20,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: _selectedImageType != null
                ? _buildSelectedImageView()
                : _isProcessing
                    ? _buildProcessingView()
                    : _buildPlaceholderView(),
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholderView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [vibrantBlue, vibrantPurple],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: vibrantBlue.withOpacity(0.3),
                blurRadius: 20,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Icon(
            Icons.image_search_rounded,
            size: 48,
            color: secondaryBackground,
          ),
        ),
        SizedBox(height: 24),
        Text(
          'Select or Capture Image',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: primaryText,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Choose from gallery or take a new photo',
          style: TextStyle(
            fontSize: 14,
            color: secondaryText,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedImageView() {
    return Stack(
      children: [
        // Simulated Image Display
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                vibrantBlue.withOpacity(0.2),
                vibrantPurple.withOpacity(0.1),
                vibrantGreen.withOpacity(0.1),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _selectedImageType == 'camera'
                    ? Icons.camera_alt_rounded
                    : Icons.photo_library_rounded,
                size: 80,
                color: primaryText.withOpacity(0.7),
              ),
              SizedBox(height: 16),
              Text(
                _selectedImageType == 'camera'
                    ? 'Camera Image Captured'
                    : 'Gallery Image Selected',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: primaryText,
                ),
              ),
              Text(
                'Sample image for demonstration',
                style: TextStyle(
                  fontSize: 14,
                  color: secondaryText,
                ),
              ),
            ],
          ),
        ),
        // Overlay with actions
        Positioned(
          top: 16,
          right: 16,
          child: Row(
            children: [
              _buildImageAction(
                  Icons.refresh_rounded, 'Retake', () => _clearImage()),
              SizedBox(width: 8),
              _buildImageAction(
                  Icons.auto_awesome_rounded, 'Analyze', () => _analyzeImage()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImageAction(IconData icon, String tooltip, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: primaryText.withOpacity(0.8),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: secondaryBackground.withOpacity(0.3)),
          ),
          child: Icon(icon, color: secondaryBackground, size: 20),
        ),
      ),
    );
  }

  Widget _buildProcessingView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedBuilder(
          animation: _processingController,
          builder: (context, child) {
            return Transform.rotate(
              angle: _processingController.value * 2 * 3.14159,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [vibrantBlue, vibrantPurple],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.auto_awesome_rounded,
                  color: secondaryBackground,
                  size: 30,
                ),
              ),
            );
          },
        ),
        SizedBox(height: 24),
        Text(
          'Analyzing Image...',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: primaryText,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'AI is processing your image',
          style: TextStyle(
            fontSize: 14,
            color: secondaryText,
          ),
        ),
      ],
    );
  }

  Widget _buildModernActionButtons() {
    return Row(
      children: [
        Expanded(
          child: _buildModernButton(
            'Camera',
            Icons.camera_alt_rounded,
            vibrantBlue,
            () => _simulateCamera(),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: _buildModernButton(
            'Gallery',
            Icons.photo_library_rounded,
            vibrantGreen,
            () => _simulateGallery(),
          ),
        ),
      ],
    );
  }

  Widget _buildModernButton(
      String title, IconData icon, Color color, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color,
                color.withOpacity(0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 15,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: secondaryBackground, size: 24),
              SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: secondaryBackground,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recognition Results 🎯',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: primaryText,
          ),
        ),
        SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: secondaryBackground,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: vibrantBlue.withOpacity(0.1),
                blurRadius: 20,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.all(16),
            itemCount: _recognitionResults.length,
            itemBuilder: (context, index) {
              final result = _recognitionResults[index];
              return _buildResultItem(result, index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildResultItem(Map<String, dynamic> result, int index) {
    final confidence = (result['confidence'] * 100).round();
    final color = confidence > 80 ? vibrantGreen : vibrantOrange;

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.1),
            color.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.check_circle_rounded,
              color: secondaryBackground,
              size: 20,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  result['label'],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: primaryText,
                  ),
                ),
                Text(
                  'Confidence: $confidence%',
                  style: TextStyle(
                    fontSize: 14,
                    color: secondaryText,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$confidence%',
              style: TextStyle(
                color: secondaryBackground,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Simulation Functions for FlutLab.io
  void _simulateCamera() async {
    try {
      HapticFeedback.lightImpact();

      // Show camera simulation dialog
      await _showSimulationDialog('Camera', 'Camera functionality simulated');

      setState(() {
        _selectedImageType = 'camera';
        _recognitionResults.clear();
      });
    } catch (e) {
      _showErrorDialog('Camera Error', 'Simulation failed: $e');
    }
  }

  void _simulateGallery() async {
    try {
      HapticFeedback.lightImpact();

      // Show gallery simulation dialog
      await _showSimulationDialog('Gallery', 'Gallery functionality simulated');

      setState(() {
        _selectedImageType = 'gallery';
        _recognitionResults.clear();
      });
    } catch (e) {
      _showErrorDialog('Gallery Error', 'Simulation failed: $e');
    }
  }

  Future<void> _showSimulationDialog(String source, String message) async {
    return showDialog<void>(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: secondaryBackground.withOpacity(0.9),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: vibrantBlue.withOpacity(0.2)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient:
                          LinearGradient(colors: [vibrantBlue, vibrantPurple]),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      source == 'Camera'
                          ? Icons.camera_alt_rounded
                          : Icons.photo_library_rounded,
                      color: secondaryBackground,
                      size: 32,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    '$source Simulated ✅',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: primaryText,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Image successfully captured from $source. You can now analyze it with AI.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: secondaryText,
                    ),
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: vibrantBlue,
                      foregroundColor: secondaryBackground,
                      padding:
                          EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text('Continue'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _analyzeImage() async {
    if (_selectedImageType == null) return;

    setState(() {
      _isProcessing = true;
    });

    _processingController.repeat();

    // Simulate AI processing
    await Future.delayed(Duration(seconds: 3));

    setState(() {
      _isProcessing = false;
      _recognitionResults = [
        {'label': 'Smartphone', 'confidence': 0.95},
        {'label': 'Electronic Device', 'confidence': 0.87},
        {'label': 'Mobile Phone', 'confidence': 0.82},
        {'label': 'Technology', 'confidence': 0.76},
      ];
    });

    _processingController.stop();

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'AI analysis completed! Found ${_recognitionResults.length} objects.'),
        backgroundColor: vibrantGreen,
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _clearImage() {
    setState(() {
      _selectedImageType = null;
      _recognitionResults.clear();
    });
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
