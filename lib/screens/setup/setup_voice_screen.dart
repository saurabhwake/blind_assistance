import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetupVoiceScreen extends StatefulWidget {
  final VoidCallback onNext;
  const SetupVoiceScreen({required this.onNext, super.key});

  @override
  State<SetupVoiceScreen> createState() => _SetupVoiceScreenState();
}

class _SetupVoiceScreenState extends State<SetupVoiceScreen>
    with TickerProviderStateMixin {
  String selectedVoice = "Male Voice";
  final List<String> voices = ["Male Voice", "Female Voice"];
  final FlutterTts flutterTts = FlutterTts();
  List<dynamic> availableVoices = [];
  dynamic maleVoice;
  dynamic femaleVoice;
  final Color primaryBlue = const Color(0xFF4A90E2);

  late AnimationController _animationController;
  late AnimationController _bgController;

  @override
  void initState() {
    super.initState();
    loadSelectedVoice();
    fetchVoices();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..forward();
    _bgController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    flutterTts.stop();
    _animationController.dispose();
    _bgController.dispose();
    super.dispose();
  }

  Future<void> loadSelectedVoice() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedVoice = prefs.getString("selectedVoice") ?? "Male Voice";
    });
  }

  Future<void> saveSelectedVoice(String voice) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("selectedVoice", voice);
  }

  Future<void> fetchVoices() async {
    await flutterTts.setLanguage("en-US");
    availableVoices = await flutterTts.getVoices;
    maleVoice = availableVoices.firstWhere(
      (voice) =>
          (voice["name"].toLowerCase().contains("male") ||
              voice["name"].toLowerCase().contains("david") ||
              voice["name"].toLowerCase().contains("matthew")) &&
          voice["locale"] == "en-US",
      orElse: () => availableVoices.first,
    );
    femaleVoice = availableVoices.firstWhere(
      (voice) =>
          (voice["name"].toLowerCase().contains("female") ||
              voice["name"].toLowerCase().contains("zira") ||
              voice["name"].toLowerCase().contains("siri")) &&
          voice["locale"] == "en-US",
      orElse: () => availableVoices.first,
    );
    if (mounted) {
      speak(selectedVoice);
    }
  }

  Future<void> speak(String voiceType) async {
    if (availableVoices.isEmpty) return;
    var selectedTTSVoice = (voiceType == "Male Voice") ? maleVoice : femaleVoice;
    await flutterTts.setVoice({
      "name": selectedTTSVoice["name"],
      "locale": selectedTTSVoice["locale"],
    });
    await flutterTts.speak("Hello, this is the $voiceType.");
  }

  Widget buildOptionCard(String voice, bool isSelected, int index) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.1 * index, 1, curve: Curves.easeOut),
      ),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: Offset(0, 0.2),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: _animationController,
          curve: Interval(0.1 * index, 1, curve: Curves.easeOut),
        )),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Card(
              elevation: isSelected ? 6 : 1,
              color: Colors.white.withOpacity(0.87),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
                side: BorderSide(
                  color: isSelected ? primaryBlue : Colors.transparent,
                  width: 2,
                ),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () {
                  setState(() {
                    selectedVoice = voice;
                  });
                  saveSelectedVoice(voice);
                  speak(voice);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 18.0, horizontal: 24.0),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            colors: [
                              primaryBlue.withOpacity(0.18),
                              Colors.transparent
                            ],
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            voice == "Male Voice" ? Icons.male : Icons.female,
                            color: primaryBlue,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          voice,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      if (isSelected)
                        Icon(Icons.check_circle, color: primaryBlue, size: 28),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWide = size.width > 600;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Animated glassy background
          AnimatedBuilder(
            animation: _bgController,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white,
                      primaryBlue.withOpacity(0.11),
                      Colors.white,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: CustomPaint(
                  painter: _VoiceBackgroundPainter(_bgController.value, primaryBlue),
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
                      constraints: BoxConstraints(maxWidth: isWide ? 500 : double.infinity),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: isWide ? 32 : 20, vertical: 28),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Glassy icon
                              ClipRRect(
                                borderRadius: BorderRadius.circular(36),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                  child: Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: primaryBlue.withOpacity(0.10),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: primaryBlue.withOpacity(0.08),
                                          blurRadius: 24,
                                          offset: const Offset(0, 8),
                                        ),
                                      ],
                                    ),
                                    child: Icon(Icons.record_voice_over, size: 48, color: primaryBlue),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                "Select a voice for text-to-speech",
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                      color: primaryBlue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Choose a voice that will be used for reading text aloud.",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      color: Colors.black54,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 32),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: voices.length,
                                itemBuilder: (context, index) {
                                  final voice = voices[index];
                                  final isSelected = voice == selectedVoice;
                                  return buildOptionCard(voice, isSelected, index);
                                },
                              ),
                              const SizedBox(height: 36),
                              ScaleTransition(
                                scale: Tween<double>(begin: 0.9, end: 1.0).animate(
                                  CurvedAnimation(
                                    parent: _animationController,
                                    curve: Curves.elasticOut,
                                  ),
                                ),
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 56,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: primaryBlue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      elevation: 4,
                                      shadowColor: primaryBlue.withOpacity(0.18),
                                    ),
                                    onPressed: widget.onNext,
                                    child: Text(
                                      "Next",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
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
                    color: primaryBlue,
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

// Animated background painter for glassy effect
class _VoiceBackgroundPainter extends CustomPainter {
  final double animationValue;
  final Color primaryBlue;

  _VoiceBackgroundPainter(this.animationValue, this.primaryBlue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          primaryBlue.withOpacity(0.10 + 0.07 * animationValue),
          Colors.transparent,
        ],
        center: Alignment(-0.6 + 1.2 * animationValue, -0.6),
        radius: 0.7 + 0.1 * animationValue,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawCircle(
      Offset(size.width * (0.3 + 0.3 * animationValue), size.height * 0.25),
      120 + 30 * animationValue,
      paint,
    );

    final paint2 = Paint()
      ..shader = RadialGradient(
        colors: [
          primaryBlue.withOpacity(0.08 + 0.06 * (1 - animationValue)),
          Colors.transparent,
        ],
        center: Alignment(0.7 - 1.2 * animationValue, 0.7),
        radius: 0.5 + 0.15 * (1 - animationValue),
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawCircle(
      Offset(size.width * (0.7 - 0.2 * animationValue), size.height * 0.7),
      80 + 20 * (1 - animationValue),
      paint2,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
