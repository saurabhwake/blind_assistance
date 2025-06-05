import 'package:flutter/material.dart';
import 'dart:ui';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _controller = TextEditingController();
  bool _submitted = false;

  @override
  Widget build(BuildContext context) {
    final accent = const Color(0xFF8B5CF6);
    final gradientColors = [accent, Colors.blueAccent];

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.7),
        elevation: 0,
        title: const Text(
          'Feedback',
          style: TextStyle(
            color: Color(0xFF1A1B3A),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF8B5CF6)),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
      ),
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  accent.withOpacity(0.09),
                  Colors.blueAccent.withOpacity(0.07),
                  Colors.white,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.90,
                    constraints: const BoxConstraints(maxWidth: 420),
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.88),
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: accent.withOpacity(0.10),
                          blurRadius: 32,
                          offset: const Offset(0, 10),
                        ),
                      ],
                      border: Border.all(
                        color: accent.withOpacity(0.12),
                        width: 1.2,
                      ),
                    ),
                    child: _submitted
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: gradientColors,
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.check_circle_rounded,
                                  color: Colors.white,
                                  size: 44,
                                ),
                              ),
                              const SizedBox(height: 18),
                              const Text(
                                'Thank you!',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF8B5CF6),
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Your feedback has been submitted.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF444B6E),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 24),
                              ElevatedButton.icon(
                                onPressed: () {
                                  setState(() {
                                    _submitted = false;
                                  });
                                },
                                icon: const Icon(Icons.arrow_back_rounded, size: 20),
                                label: const Text('Back'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: accent,
                                  foregroundColor: Colors.white,
                                  elevation: 2,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: gradientColors,
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.feedback_rounded,
                                  color: Colors.white,
                                  size: 38,
                                ),
                              ),
                              const SizedBox(height: 18),
                              const Text(
                                'We value your feedback!',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1A1B3A),
                                ),
                              ),
                              const SizedBox(height: 18),
                              TextField(
                                controller: _controller,
                                maxLines: 5,
                                minLines: 3,
                                decoration: InputDecoration(
                                  hintText: 'Enter your feedback here...',
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.95),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: BorderSide(
                                      color: accent.withOpacity(0.25),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: BorderSide(
                                      color: accent,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF1A1B3A),
                                ),
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton.icon(
                                onPressed: () {
                                  if (_controller.text.trim().isNotEmpty) {
                                    setState(() {
                                      _submitted = true;
                                    });
                                    _controller.clear();
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: const Text('Please enter your feedback.'),
                                        backgroundColor: accent,
                                      ),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: accent,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14)),
                                  minimumSize: const Size(double.infinity, 48),
                                ),
                                icon: const Icon(Icons.send),
                                label: const Text('Submit'),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
