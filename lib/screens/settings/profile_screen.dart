import 'package:flutter/material.dart';
import 'dart:ui';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final Color accent = const Color(0xFF3B82F6);

  final TextEditingController _nameController =
      TextEditingController(text: 'John Doe');
  final TextEditingController _emailController =
      TextEditingController(text: 'john.doe@email.com');

  String _avatarUrl = 'https://i.pravatar.cc/150?img=3';

  // Placeholder for image picker
  void _pickImage() async {
    // In a real app, use image_picker package
    setState(() {
      // For demo, just change the avatar image
      _avatarUrl = 'https://i.pravatar.cc/150?img=5';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile picture changed!')),
    );
  }

  void _saveProfile() {
    // In a real app, validate and save the data
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile updated!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.7),
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Color(0xFF1A1B3A),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF3B82F6)),
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
                    width: MediaQuery.of(context).size.width * 0.92,
                    constraints: const BoxConstraints(maxWidth: 420),
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
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: 54,
                              backgroundColor: accent,
                              backgroundImage: NetworkImage(_avatarUrl),
                            ),
                            Positioned(
                              bottom: 4,
                              right: 4,
                              child: GestureDetector(
                                onTap: _pickImage,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: accent.withOpacity(0.18),
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  padding: const EdgeInsets.all(6),
                                  child: Icon(Icons.edit,
                                      color: accent, size: 20),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _nameController,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                            labelText: 'Full Name',
                            labelStyle: TextStyle(
                              color: accent,
                              fontWeight: FontWeight.w600,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(
                                color: accent,
                                width: 2,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 14),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _emailController,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 16, color: Colors.grey),
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(
                              color: accent,
                              fontWeight: FontWeight.w600,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(
                                color: accent,
                                width: 2,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 14),
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: _saveProfile,
                          icon: const Icon(Icons.save),
                          label: const Text('Save Changes'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accent,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                            minimumSize: const Size(double.infinity, 48),
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 17,
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
