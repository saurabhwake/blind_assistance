import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:url_launcher/url_launcher.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  void _launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'support@sensepath.app',
      query: 'subject=Sense Path Support&body=Hi Support Team,',
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }

  void _showFAQs(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('FAQs'),
        content: const Text(
          'Q: How do I reset my password?\n'
          'A: Go to Profile > Change Password.\n\n'
          'Q: How do I contact support?\n'
          'A: Email us at support@sensepath.app.\n\n'
          'For more, visit our website.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(color: Color(0xFF3B82F6))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final accent = const Color(0xFFF59E0B);
    final secondary = const Color(0xFF10B981);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.7),
        elevation: 0,
        title: const Text(
          'Help & Support',
          style: TextStyle(
            color: Color(0xFF1A1B3A),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFFF59E0B)),
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
                  secondary.withOpacity(0.07),
                  Colors.white,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.92,
                  constraints: const BoxConstraints(maxWidth: 420),
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.90),
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
                      ListTile(
                        leading: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [secondary, Colors.greenAccent],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          padding: const EdgeInsets.all(7),
                          child: const Icon(Icons.support_agent,
                              color: Colors.white, size: 30),
                        ),
                        title: const Text(
                          'Customer Care',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                        ),
                        subtitle: const Text('support@sensepath.app'),
                        onTap: _launchEmail,
                        trailing: IconButton(
                          icon: const Icon(Icons.email_rounded, color: Color(0xFF10B981)),
                          onPressed: _launchEmail,
                          tooltip: 'Send Email',
                        ),
                      ),
                      const Divider(height: 32, thickness: 1.2),
                      ListTile(
                        leading: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [Color(0xFF3B82F6), Colors.blueAccent],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          padding: const EdgeInsets.all(7),
                          child: const Icon(Icons.help_outline,
                              color: Colors.white, size: 30),
                        ),
                        title: const Text(
                          'FAQs',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                        ),
                        subtitle: const Text('Find answers to common questions'),
                        onTap: () => _showFAQs(context),
                        trailing: IconButton(
                          icon: const Icon(Icons.open_in_new_rounded, color: Color(0xFF3B82F6)),
                          onPressed: () => _showFAQs(context),
                          tooltip: 'View FAQs',
                        ),
                      ),
                      const SizedBox(height: 28),
                      const Text(
                        'For further assistance, email us or visit our website.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF444B6E),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 18),
                      ElevatedButton.icon(
                        onPressed: _launchEmail,
                        icon: const Icon(Icons.email_rounded, size: 20),
                        label: const Text('Contact Support'),
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
