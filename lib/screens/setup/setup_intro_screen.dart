import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppColors {
  static const Color primaryBackground = Color(0xFFF8FAFF);
  static const Color secondaryBackground = Color(0xFFFFFFFF);
  static const Color primaryText = Color(0xFF1A1B3A);
  static const Color secondaryText = Color(0xFF6B7280);
  static const Color vibrantBlue = Color(0xFF3B82F6);
  static const Color vibrantPurple = Color(0xFF8B5CF6);
}

class SetupIntroScreen extends StatefulWidget {
  final VoidCallback onNext;
  const SetupIntroScreen({required this.onNext, super.key});

  @override
  State<SetupIntroScreen> createState() => _SetupIntroScreenState();
}

class _SetupIntroScreenState extends State<SetupIntroScreen> with TickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late AnimationController _animationController;
  late AnimationController _floatingController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _floatingController = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    );
    _animationController.forward();
    _floatingController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _floatingController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveAndContinue() async {
    if (_formKey.currentState?.validate() ?? false) {
      HapticFeedback.lightImpact();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userName', _nameController.text.trim());
      widget.onNext();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWide = size.width > 600;

    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      body: Stack(
        children: [
          // Animated Glassy Background
          AnimatedBuilder(
            animation: _floatingController,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primaryBackground,
                      AppColors.vibrantBlue.withOpacity(0.08),
                      AppColors.vibrantPurple.withOpacity(0.05),
                    ],
                  ),
                ),
                child: CustomPaint(
                  painter: _ModernBackgroundPainter(
                    _floatingController.value,
                    AppColors.vibrantBlue,
                    AppColors.vibrantPurple,
                  ),
                  size: Size.infinite,
                ),
              );
            },
          ),
          // Main Content
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: isWide ? 500 : double.infinity),
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: isWide ? 32 : 20, vertical: 28),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Glassmorphic Header
                              SlideTransition(
                                position: Tween<Offset>(begin: const Offset(0, -0.5), end: Offset.zero)
                                    .animate(CurvedAnimation(parent: _animationController, curve: Curves.elasticOut)),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(24),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            AppColors.secondaryBackground.withOpacity(0.9),
                                            AppColors.vibrantBlue.withOpacity(0.1),
                                            AppColors.vibrantPurple.withOpacity(0.05),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(24),
                                        border: Border.all(color: AppColors.vibrantBlue.withOpacity(0.2), width: 1),
                                        boxShadow: [
                                          BoxShadow(
                                              color: AppColors.vibrantBlue.withOpacity(0.08),
                                              blurRadius: 20,
                                              offset: const Offset(0, 8))
                                        ],
                                      ),
                                      child: Column(
                                        children: [
                                          Text("Welcome to",
                                              style: TextStyle(fontSize: 22, color: AppColors.secondaryText)),
                                          Text("Sense Path",
                                              style: TextStyle(
                                                  fontSize: 32,
                                                  fontWeight: FontWeight.w800,
                                                  color: AppColors.primaryText)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 40),
                              // Animated Illustration
                              ScaleTransition(
                                scale: Tween(begin: 0.5, end: 1.0).animate(_animationController),
                                child: Container(
                                  width: size.width * 0.4 > 180 ? 180 : size.width * 0.4,
                                  height: size.width * 0.4 > 180 ? 180 : size.width * 0.4,
                                  decoration: BoxDecoration(
                                    gradient: RadialGradient(
                                        colors: [AppColors.vibrantBlue.withOpacity(0.1), Colors.transparent]),
                                    shape: BoxShape.circle,
                                  ),
                                  child: CustomPaint(
                                    painter: _ModernIconPainter(
                                      _animationController.value,
                                      AppColors.vibrantBlue,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 40),
                              // Glassmorphic Input Card
                              FadeTransition(
                                opacity: _animationController,
                                child: SlideTransition(
                                  position: Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
                                      .animate(CurvedAnimation(
                                          parent: _animationController, curve: Curves.easeOut)),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(24),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                      child: Container(
                                        padding: const EdgeInsets.all(24),
                                        decoration: BoxDecoration(
                                          color: AppColors.secondaryBackground.withOpacity(0.8),
                                          borderRadius: BorderRadius.circular(24),
                                          border: Border.all(
                                              color: AppColors.vibrantBlue.withOpacity(0.2), width: 1),
                                          boxShadow: [
                                            BoxShadow(
                                                color: AppColors.vibrantBlue.withOpacity(0.08),
                                                blurRadius: 20,
                                                offset: const Offset(0, 8))
                                          ],
                                        ),
                                        child: Form(
                                          key: _formKey,
                                          child: TextFormField(
                                            controller: _nameController,
                                            style: TextStyle(color: AppColors.primaryText, fontSize: 16),
                                            decoration: InputDecoration(
                                              prefixIcon: Icon(Icons.person_rounded, color: AppColors.vibrantBlue),
                                              labelText: "Your Name",
                                              labelStyle: TextStyle(color: AppColors.secondaryText),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(12),
                                                borderSide: BorderSide.none,
                                              ),
                                              filled: true,
                                              fillColor: AppColors.vibrantBlue.withOpacity(0.05),
                                            ),
                                            validator: (value) =>
                                                value?.trim().isEmpty ?? true ? "Please enter your name" : null,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 36),
                              // Gradient Action Button
                              ScaleTransition(
                                scale: Tween(begin: 0.9, end: 1.0).animate(
                                    CurvedAnimation(
                                        parent: _animationController,
                                        curve: const Interval(0.5, 1.0, curve: Curves.elasticOut))),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: _saveAndContinue,
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(vertical: 18),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                      backgroundColor: AppColors.vibrantBlue,
                                      foregroundColor: Colors.white,
                                      elevation: 4,
                                      shadowColor: AppColors.vibrantBlue.withOpacity(0.3),
                                    ),
                                    child: const Text("Start Setup",
                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // The bottom backward arrow is now removed.
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter for background effects
class _ModernBackgroundPainter extends CustomPainter {
  final double animationValue;
  final Color vibrantBlue;
  final Color vibrantPurple;

  _ModernBackgroundPainter(this.animationValue, this.vibrantBlue, this.vibrantPurple);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [vibrantBlue.withOpacity(0.05), vibrantPurple.withOpacity(0.03)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path()
      ..addOval(Rect.fromCircle(
        center: Offset(size.width * 0.2, size.height * 0.3),
        radius: 80 + sin(animationValue * 2 * pi) * 20,
      ))
      ..addOval(Rect.fromCircle(
        center: Offset(size.width * 0.8, size.height * 0.6),
        radius: 60 + cos(animationValue * 2 * pi) * 15,
      ));

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Custom painter for animated illustration
class _ModernIconPainter extends CustomPainter {
  final double animationValue;
  final Color vibrantBlue;

  _ModernIconPainter(this.animationValue, this.vibrantBlue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = vibrantBlue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(size.width * 0.3, size.height * 0.7)
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height * 0.3,
        size.width * 0.7,
        size.height * 0.7,
      );

    canvas.drawPath(path, paint);
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.4), 8 + animationValue * 4, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
