import 'package:flutter/material.dart';
import 'dart:ui';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final accent = const Color(0xFF10B981);
    final gradientColors = [accent, Colors.purpleAccent, Colors.blueAccent];

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.7),
        elevation: 0,
        title: const Text(
          'About the App',
          style: TextStyle(
            color: Color(0xFF1A1B3A),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF10B981)),
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
                  Colors.purpleAccent.withOpacity(0.07),
                  Colors.blueAccent.withOpacity(0.06),
                  Colors.white,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // Glassmorphic Card
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.90,
                  constraints: const BoxConstraints(maxWidth: 420),
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: accent.withOpacity(0.13),
                        blurRadius: 32,
                        offset: const Offset(0, 12),
                      ),
                    ],
                    border: Border.all(
                      color: accent.withOpacity(0.13),
                      width: 1.2,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: gradientColors,
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: accent.withOpacity(0.25),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.visibility_rounded,
                          color: Colors.white,
                          size: 44,
                        ),
                      ),
                      const SizedBox(height: 22),
                      const Text(
                        'Sense Path',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.2,
                          color: Color(0xFF1A1B3A),
                        ),
                      ),
                      const SizedBox(height: 7),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 5),
                        decoration: BoxDecoration(
                          color: accent.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Version 1.0.0',
                          style: TextStyle(
                            color: Color(0xFF10B981),
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 22),
                      const Text(
                        'Sense Path is a vision assistance app designed to help users navigate and interact with their environment using advanced AI technology.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF444B6E),
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 28),
                      ElevatedButton.icon(
                        onPressed: () => Navigator.pop(context),
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
