import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:url_launcher/url_launcher.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  void _launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'support@sensepath.app',
      query: 'subject=Privacy Policy Inquiry&body=Hi Sense Path Team,',
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final accent = const Color(0xFF8B5CF6);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.7),
        elevation: 0,
        title: const Text(
          'Privacy Policy',
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
                  accent.withOpacity(0.10),
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
                  filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.92,
                    constraints: const BoxConstraints(maxWidth: 480),
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.93),
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: accent.withOpacity(0.13),
                          blurRadius: 32,
                          offset: const Offset(0, 10),
                        ),
                      ],
                      border: Border.all(
                        color: accent.withOpacity(0.12),
                        width: 1.2,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [accent, Colors.blueAccent],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.privacy_tip_rounded,
                            color: Colors.white,
                            size: 34,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Your Privacy Matters',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF8B5CF6),
                          ),
                        ),
                        const SizedBox(height: 18),
                        const Text(
                          'Sense Path is committed to protecting your privacy. Our app processes data locally on your device whenever possible. When cloud processing is required, we anonymize data and delete it after processing. We do not sell your data to third parties.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF444B6E),
                            fontWeight: FontWeight.w500,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 28),
                        const Text(
                          'For more information, contact us at support@sensepath.app.',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: _launchEmail,
                          icon: const Icon(Icons.email_rounded, size: 20),
                          label: const Text('Contact Us'),
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
          ),
        ],
      ),
    );
  }
}
