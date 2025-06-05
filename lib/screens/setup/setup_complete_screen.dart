import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:ui';

class SetupCompleteScreen extends StatefulWidget {
  final VoidCallback onFinish;
  const SetupCompleteScreen({required this.onFinish, super.key});

  @override
  State<SetupCompleteScreen> createState() => _SetupCompleteScreenState();
}

class _SetupCompleteScreenState extends State<SetupCompleteScreen> {
  List<Map<String, dynamic>> emergencyContacts = [];
  String selectedLanguage = "Not Set";
  String preferredVoice = "Not Set";

  final Color primaryBlue = const Color(0xFF4A90E2);
  final Color lightBlue = const Color(0xFFE3F2FD);
  final Color darkBlue = const Color(0xFF0D47A1);
  final Color accentBlue = const Color(0xFF82B1FF);

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    String? contactsJson = prefs.getString('emergencyContacts');
    if (contactsJson != null) {
      List decodedContacts = jsonDecode(contactsJson);
      setState(() {
        emergencyContacts = decodedContacts.map((contact) => Map<String, dynamic>.from(contact)).toList();
      });
    }
    setState(() {
      selectedLanguage = prefs.getString('selectedLanguage') ?? "Not Set";
      preferredVoice = prefs.getString('selectedVoice') ?? "Not Set";
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWide = size.width > 600;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  lightBlue,
                  primaryBlue.withOpacity(0.15),
                  Colors.white,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Positioned(
            top: 80,
            left: -40,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    accentBlue.withOpacity(0.12),
                    Colors.transparent,
                  ],
                  radius: 0.8,
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 500),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: isWide ? 40 : 20,
                            vertical: 28,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(60),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                                  child: Container(
                                    width: size.width * 0.25 > 120 ? 120 : size.width * 0.25,
                                    height: size.width * 0.25 > 120 ? 120 : size.width * 0.25,
                                    decoration: BoxDecoration(
                                      color: lightBlue.withOpacity(0.65),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: primaryBlue.withOpacity(0.09),
                                          blurRadius: 24,
                                          offset: const Offset(0, 8),
                                        ),
                                      ],
                                      border: Border.all(
                                        color: accentBlue.withOpacity(0.28),
                                        width: 2,
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.check_circle,
                                      size: size.width * 0.13 > 80 ? 80 : size.width * 0.13,
                                      color: primaryBlue,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 28),
                              Text(
                                "Setup Complete!",
                                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                      color: darkBlue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                "You're all set to use the assistant app.",
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: Colors.black87,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 32),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                                  child: Card(
                                    elevation: 4,
                                    margin: EdgeInsets.zero,
                                    color: Colors.white.withOpacity(0.78),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      side: BorderSide(color: accentBlue.withOpacity(0.7), width: 1.2),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(22.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(Icons.phone, color: primaryBlue),
                                              const SizedBox(width: 12),
                                              Text(
                                                "Emergency Contacts",
                                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                                      color: darkBlue,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          if (emergencyContacts.isEmpty)
                                            Padding(
                                              padding: const EdgeInsets.only(left: 36.0),
                                              child: Text(
                                                "No contacts added",
                                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                      fontStyle: FontStyle.italic,
                                                      color: Colors.black54,
                                                    ),
                                              ),
                                            )
                                          else
                                            Padding(
                                              padding: const EdgeInsets.only(left: 36.0),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: emergencyContacts.map((contact) {
                                                  return Padding(
                                                    padding: const EdgeInsets.only(bottom: 8.0),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          "${contact['name']}",
                                                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                                                fontWeight: FontWeight.w600,
                                                              ),
                                                        ),
                                                        const SizedBox(width: 8),
                                                        Text(
                                                          "${contact['phone']}",
                                                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                                color: Colors.black54,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }).toList(),
                                              ),
                                            ),
                                          Divider(height: 32, color: accentBlue.withOpacity(0.4)),
                                          Row(
                                            children: [
                                              Icon(Icons.language, color: primaryBlue),
                                              const SizedBox(width: 12),
                                              Text(
                                                "Language",
                                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                                      color: darkBlue,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 36.0),
                                            child: Text(
                                              selectedLanguage,
                                              style: Theme.of(context).textTheme.bodyLarge,
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          Row(
                                            children: [
                                              Icon(Icons.record_voice_over, color: primaryBlue),
                                              const SizedBox(width: 12),
                                              Text(
                                                "Voice",
                                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                                      color: darkBlue,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 36.0),
                                            child: Text(
                                              preferredVoice,
                                              style: Theme.of(context).textTheme.bodyLarge,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 36),
                              SizedBox(
                                width: double.infinity,
                                height: 56,
                                child: ElevatedButton(
                                  onPressed: widget.onFinish,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryBlue,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    elevation: 3,
                                  ),
                                  child: Text(
                                    "GET STARTED",
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.1,
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
