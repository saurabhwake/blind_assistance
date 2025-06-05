import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageScreenColors {
  static const Color primaryBackground = Color(0xFFF5F3FF);
  static const Color secondaryBackground = Color(0xFFFFFFFF);
  static const Color primaryText = Color(0xFF2D1E4A);
  static const Color secondaryText = Color(0xFF64748B);
  static const Color vibrantPurple = Color(0xFF8B5CF6);
  static const Color vibrantTeal = Color(0xFF06B6D4);
}

class SetupLanguageScreen extends StatefulWidget {
  final VoidCallback onNext;
  const SetupLanguageScreen({required this.onNext, super.key});

  @override
  State<SetupLanguageScreen> createState() => _SetupLanguageScreenState();
}

class _SetupLanguageScreenState extends State<SetupLanguageScreen>
    with TickerProviderStateMixin {
  String selectedLanguage = "English";
  final List<Map<String, String>> languages = [
    {"code": "English", "name": "English"},
    {"code": "Hindi", "name": "हिन्दी"},
  ];

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
    super.dispose();
  }

  Future<void> _saveLanguagePreference() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedLanguage', selectedLanguage);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWide = size.width > 600;
    return Scaffold(
      backgroundColor: LanguageScreenColors.primaryBackground,
      // AppBar removed as requested
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
                      LanguageScreenColors.primaryBackground,
                      LanguageScreenColors.vibrantTeal.withOpacity(0.10),
                      LanguageScreenColors.vibrantPurple.withOpacity(0.08),
                    ],
                  ),
                ),
                child: CustomPaint(
                  painter: _ModernBackgroundPainter(
                    _floatingController.value,
                    LanguageScreenColors.vibrantPurple,
                    LanguageScreenColors.vibrantTeal,
                  ),
                  size: Size.infinite,
                ),
              );
            },
          ),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                          maxWidth: isWide ? 500 : double.infinity),
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: isWide ? 32 : 20, vertical: 28),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Glassmorphic Header
                              SlideTransition(
                                position: Tween<Offset>(
                                        begin: const Offset(0, -0.5), end: Offset.zero)
                                    .animate(CurvedAnimation(
                                        parent: _animationController,
                                        curve: Curves.elasticOut)),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(24),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 20, horizontal: 24),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            LanguageScreenColors.secondaryBackground.withOpacity(0.9),
                                            LanguageScreenColors.vibrantPurple.withOpacity(0.10),
                                            LanguageScreenColors.vibrantTeal.withOpacity(0.08),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(24),
                                        border: Border.all(
                                            color: LanguageScreenColors.vibrantPurple.withOpacity(0.18),
                                            width: 1),
                                        boxShadow: [
                                          BoxShadow(
                                              color: LanguageScreenColors.vibrantPurple
                                                  .withOpacity(0.09),
                                              blurRadius: 20,
                                              offset: const Offset(0, 8))
                                        ],
                                      ),
                                      child: Column(
                                        children: [
                                          Icon(Icons.language,
                                              size: 48, color: LanguageScreenColors.vibrantTeal),
                                          const SizedBox(height: 8),
                                          Text("Choose Language",
                                              style: TextStyle(
                                                  fontSize: 28,
                                                  fontWeight: FontWeight.w800,
                                                  color: LanguageScreenColors.primaryText)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 32),
                              // Subtitle
                              Text(
                                "Select your preferred language",
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                      color: LanguageScreenColors.vibrantPurple,
                                      fontWeight: FontWeight.bold,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "The app will use this language for all text and speech.",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      color: LanguageScreenColors.secondaryText,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 32),
                              // Language List
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: languages.length,
                                itemBuilder: (context, index) {
                                  final language = languages[index];
                                  final isSelected =
                                      language["code"] == selectedLanguage;
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 14.0),
                                    child: FadeTransition(
                                      opacity: _animationController,
                                      child: SlideTransition(
                                        position: Tween<Offset>(
                                                begin: const Offset(0, 0.3),
                                                end: Offset.zero)
                                            .animate(CurvedAnimation(
                                                parent: _animationController,
                                                curve: Interval(
                                                    0.2 * index, 1.0,
                                                    curve: Curves.easeOut))),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(18),
                                          child: BackdropFilter(
                                            filter: ImageFilter.blur(
                                                sigmaX: 8, sigmaY: 8),
                                            child: Card(
                                              elevation: isSelected ? 6 : 1,
                                              color: LanguageScreenColors.secondaryBackground
                                                  .withOpacity(0.85),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(18),
                                                side: BorderSide(
                                                  color: isSelected
                                                      ? LanguageScreenColors.vibrantTeal
                                                      : Colors.transparent,
                                                  width: 2,
                                                ),
                                              ),
                                              child: InkWell(
                                                borderRadius:
                                                    BorderRadius.circular(18),
                                                onTap: () {
                                                  setState(() {
                                                    selectedLanguage =
                                                        language["code"]!;
                                                  });
                                                  HapticFeedback.selectionClick();
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(
                                                      vertical: 18.0,
                                                      horizontal: 24.0),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        width: 48,
                                                        height: 48,
                                                        decoration: BoxDecoration(
                                                          gradient: RadialGradient(
                                                            colors: [
                                                              LanguageScreenColors.vibrantTeal
                                                                  .withOpacity(0.18),
                                                              Colors.transparent
                                                            ],
                                                          ),
                                                          shape: BoxShape.circle,
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            language["code"]![0],
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight.bold,
                                                              fontSize: 22,
                                                              color: LanguageScreenColors.vibrantTeal,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 16),
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              language["code"]!,
                                                              style: Theme.of(context)
                                                                  .textTheme
                                                                  .titleMedium
                                                                  ?.copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                            ),
                                                            Text(
                                                              language["name"]!,
                                                              style: Theme.of(context)
                                                                  .textTheme
                                                                  .bodyMedium
                                                                  ?.copyWith(
                                                                    color: LanguageScreenColors
                                                                        .secondaryText,
                                                                  ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      if (isSelected)
                                                        Icon(Icons.check_circle,
                                                            color:
                                                                LanguageScreenColors.vibrantTeal,
                                                            size: 28),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 36),
                              // Next Button
                              ScaleTransition(
                                scale: Tween(begin: 0.9, end: 1.0).animate(
                                    CurvedAnimation(
                                        parent: _animationController,
                                        curve: const Interval(0.5, 1.0,
                                            curve: Curves.elasticOut))),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      padding:
                                          const EdgeInsets.symmetric(vertical: 18),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      backgroundColor: LanguageScreenColors.vibrantTeal,
                                      foregroundColor: Colors.white,
                                      elevation: 4,
                                      shadowColor:
                                          LanguageScreenColors.vibrantTeal.withOpacity(0.3),
                                    ),
                                    onPressed: () async {
                                      await _saveLanguagePreference();
                                      widget.onNext();
                                    },
                                    child: const Text(
                                      "Next",
                                      style: TextStyle(
                                          fontSize: 18, fontWeight: FontWeight.w600),
                                    ),
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
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, size: 36),
                    tooltip: 'Back',
                    color: LanguageScreenColors.vibrantTeal,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Painter for animated glassy background
class _ModernBackgroundPainter extends CustomPainter {
  final double animationValue;
  final Color vibrantPurple;
  final Color vibrantTeal;

  _ModernBackgroundPainter(
      this.animationValue, this.vibrantPurple, this.vibrantTeal);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [
          vibrantPurple.withOpacity(0.06),
          vibrantTeal.withOpacity(0.04)
        ],
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
