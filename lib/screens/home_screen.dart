import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'dart:math';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _floatingController;
  late AnimationController _rotationController;

  // Modern Vibrant Color Scheme - 2025 Trends
  static const Color primaryBackground =
      Color(0xFFF8FAFF); // Ultra-light blue-white
  static const Color secondaryBackground = Color(0xFFFFFFFF); // Pure white
  static const Color primaryText = Color(0xFF1A1B3A); // Deep navy
  static const Color secondaryText = Color(0xFF6B7280); // Cool gray
  static const Color vibrantBlue = Color(0xFF3B82F6); // Modern blue
  static const Color vibrantPurple = Color(0xFF8B5CF6); // Electric purple
  static const Color vibrantPink = Color(0xFFEC4899); // Bright pink
  static const Color vibrantGreen = Color(0xFF10B981); // Fresh green
  static const Color vibrantOrange = Color(0xFFF59E0B); // Warm orange
  static const Color vibrantRed = Color(0xFFEF4444); // Modern red
  static const Color lightBlue = Color(0xFFDBEAFE); // Soft blue
  static const Color lightPurple = Color(0xFFE9D5FF); // Soft purple

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );
    _floatingController = AnimationController(
      duration: Duration(seconds: 6),
      vsync: this,
    );
    _rotationController = AnimationController(
      duration: Duration(seconds: 8),
      vsync: this,
    );

    _animationController.forward();
    _floatingController.repeat(reverse: true);
    _rotationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _floatingController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackground,
      body: Stack(
        children: [
          // Vibrant Gradient Background
          _buildVibrantBackground(),

          // Floating Modern Elements
          _buildModernFloatingElements(),

          // Main Content with proper scrolling
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
                        _buildWelcomeSection(),
                        SizedBox(height: 32),
                        _buildQuickActions(),
                        SizedBox(height: 32),
                        _buildFeatureCards(),
                        SizedBox(height: 60), // Extra bottom padding
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

  Widget _buildVibrantBackground() {
    return AnimatedBuilder(
      animation: _floatingController,
      builder: (context, child) {
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
                lightPurple.withOpacity(0.2),
                primaryBackground,
              ],
              stops: [0.0, 0.4, 0.7, 1.0],
            ),
          ),
          child: Stack(
            children: [
              CustomPaint(
                painter: ModernBlobPainter(_floatingController.value),
                size: Size.infinite,
              ),
              CustomPaint(
                painter: GeometricPatternPainter(_rotationController.value),
                size: Size.infinite,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildModernFloatingElements() {
    return AnimatedBuilder(
      animation: _floatingController,
      builder: (context, child) {
        return Stack(
          children: List.generate(8, (index) {
            final colors = [
              vibrantBlue,
              vibrantPurple,
              vibrantPink,
              vibrantGreen
            ];
            final color = colors[index % colors.length];

            return Positioned(
              left: (index * 90.0) + (_floatingController.value * 50) - 100,
              top: 50 +
                  (index * 120.0) +
                  (sin(_floatingController.value * 2 * pi + index) * 60),
              child: Transform.rotate(
                angle: _rotationController.value * 2 * pi + index,
                child: Container(
                  width: 40 + (index * 6.0),
                  height: 40 + (index * 6.0),
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        color.withOpacity(0.2),
                        color.withOpacity(0.1),
                        Colors.transparent,
                      ],
                    ),
                    shape: index.isEven ? BoxShape.circle : BoxShape.rectangle,
                    borderRadius:
                        index.isOdd ? BorderRadius.circular(12) : null,
                  ),
                ),
              ),
            );
          }),
        );
      },
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
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [vibrantBlue, vibrantPurple],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: vibrantBlue.withOpacity(0.3),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.visibility_rounded,
                      color: secondaryBackground,
                      size: 24,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sense Path',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: primaryText,
                          ),
                        ),
                        Text(
                          'AI Vision Assistant',
                          style: TextStyle(
                            fontSize: 14,
                            color: secondaryText,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: vibrantGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.notifications_rounded,
                      color: vibrantGreen,
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

  Widget _buildWelcomeSection() {
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
            'Good Afternoon! 👋',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: primaryText,
              height: 1.2,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Ready to explore the world with AI assistance?',
            style: TextStyle(
              fontSize: 18,
              color: secondaryText,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Row(
      children: [
        Expanded(
          child: _buildQuickActionCard(
            'Voice Commands',
            Icons.mic_rounded,
            vibrantPurple,
            () {},
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: _buildQuickActionCard(
            'Emergency',
            Icons.emergency_rounded,
            vibrantRed,
            () {},
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionCard(
      String title, IconData icon, Color color, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.1),
                color.withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: color.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.3),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(icon, color: secondaryBackground, size: 24),
              ),
              SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: primaryText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCards() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Features',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: primaryText,
          ),
        ),
        SizedBox(height: 20),
        GridView.count(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.1, // Increased from 0.9 to 1.1 for more height
          children: [
            _buildFeatureCard(
              'Object Detection',
              'Identify objects with AI',
              Icons.camera_alt_rounded,
              [vibrantBlue, Color(0xFF60A5FA)],
              0.1,
            ),
            _buildFeatureCard(
              'Navigation',
              'Smart route guidance',
              Icons.navigation_rounded,
              [vibrantGreen, Color(0xFF34D399)],
              0.2,
            ),
            _buildFeatureCard(
              'Text Reader',
              'OCR text recognition',
              Icons.auto_stories_rounded,
              [vibrantOrange, Color(0xFFFBBF24)],
              0.3,
            ),
            _buildFeatureCard(
              'Voice Assistant',
              'Natural conversation',
              Icons.record_voice_over_rounded,
              [vibrantPink, Color(0xFFF472B6)],
              0.4,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFeatureCard(
    String title,
    String subtitle,
    IconData icon,
    List<Color> colors,
    double delay,
  ) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset(0, 0.5),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(delay, 1.0, curve: Curves.easeOut),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            _showFeatureDialog(title);
          },
          borderRadius: BorderRadius.circular(24),
          child: Container(
            padding: EdgeInsets.all(16), // Reduced padding from 20 to 16
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  secondaryBackground,
                  colors[0].withOpacity(0.05),
                  colors[1].withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: colors[0].withOpacity(0.1),
                  blurRadius: 20,
                  offset: Offset(0, 8),
                ),
              ],
              border: Border.all(
                color: colors[0].withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  // Use Flexible instead of fixed padding
                  child: Container(
                    padding: EdgeInsets.all(12), // Reduced from 16 to 12
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: colors),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: colors[0].withOpacity(0.3),
                          blurRadius: 12,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Icon(icon,
                        color: secondaryBackground,
                        size: 24), // Reduced from 28 to 24
                  ),
                ),
                SizedBox(height: 12), // Reduced from 16 to 12
                Flexible(
                  // Use Flexible for text
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14, // Reduced from 16 to 14
                      fontWeight: FontWeight.w700,
                      color: primaryText,
                    ),
                    maxLines: 2, // Limit to 2 lines
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(height: 6), // Reduced from 8 to 6
                Flexible(
                  // Use Flexible for subtitle
                  child: Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11, // Reduced from 12 to 11
                      color: secondaryText,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2, // Limit to 2 lines
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showFeatureDialog(String feature) {
    showDialog(
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
                border: Border.all(
                  color: vibrantBlue.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [vibrantBlue, vibrantPurple],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.auto_awesome_rounded,
                      color: secondaryBackground,
                      size: 32,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    feature,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: primaryText,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'This feature is coming soon with advanced AI capabilities.',
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
                    child: Text(
                      'Got it!',
                      style: TextStyle(fontWeight: FontWeight.w600),
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
}

// Custom Painters for Modern Effects
class ModernBlobPainter extends CustomPainter {
  final double animationValue;

  ModernBlobPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          Color(0xFF3B82F6).withOpacity(0.1),
          Color(0xFF8B5CF6).withOpacity(0.05),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path();
    final center = Offset(size.width * 0.7, size.height * 0.3);
    final radius = 100 + animationValue * 20;

    path.addOval(Rect.fromCircle(center: center, radius: radius));
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class GeometricPatternPainter extends CustomPainter {
  final double animationValue;

  GeometricPatternPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0xFF3B82F6).withOpacity(0.05)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < 3; i++) {
      final x = size.width * (0.2 + i * 0.3);
      final y = size.height * (0.2 + sin(animationValue * 2 * pi + i) * 0.1);

      canvas.drawCircle(Offset(x, y), 30, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
