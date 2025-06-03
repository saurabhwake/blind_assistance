import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../screens/home_screen.dart';
import '../screens/image_recognition_screen.dart';
import '../screens/camera_screen.dart';
import '../screens/emergency_screen.dart';
import '../screens/settings_screen.dart';

class BottomNavigationWrapper extends StatefulWidget {
  @override
  _BottomNavigationWrapperState createState() =>
      _BottomNavigationWrapperState();
}

class _BottomNavigationWrapperState extends State<BottomNavigationWrapper> {
  int _selectedIndex = 0;
  late FlutterTts flutterTts;
  bool _isTtsInitialized = false;

  final List<Widget> _screens = [
    HomeScreen(),
    ImageRecognitionScreen(),
    CameraScreen(),
    EmergencyScreen(),
    SettingsScreen(),
  ];

  // Audio names for each navigation item
  final List<String> _pageNames = [
    'Home Page',
    'Image Recognition',
    'Camera',
    'Emergency',
    'Settings',
  ];

  @override
  void initState() {
    super.initState();
    _initializeTts();
  }

  @override
  void dispose() {
    if (_isTtsInitialized) {
      flutterTts.stop();
    }
    super.dispose();
  }

  // Initialize Text-to-Speech
  Future<void> _initializeTts() async {
    try {
      flutterTts = FlutterTts();

      // Configure TTS settings
      await flutterTts.setLanguage("en-US");
      await flutterTts.setSpeechRate(0.6); // Moderate speed
      await flutterTts.setVolume(0.9); // High volume
      await flutterTts.setPitch(1.0); // Normal pitch

      // Set up handlers
      flutterTts.setStartHandler(() {
        print("TTS Started");
      });

      flutterTts.setCompletionHandler(() {
        print("TTS Completed");
      });

      flutterTts.setErrorHandler((msg) {
        print("TTS Error: $msg");
      });

      setState(() {
        _isTtsInitialized = true;
      });

      // Welcome message
      await Future.delayed(Duration(milliseconds: 500));
      await _speakText("Welcome to Sense Path");
    } catch (e) {
      print("TTS initialization error: $e");
    }
  }

  // Speak the provided text
  Future<void> _speakText(String text) async {
    if (!_isTtsInitialized) {
      print("TTS not initialized");
      return;
    }

    try {
      await flutterTts.stop(); // Stop any current speech
      await flutterTts.speak(text); // Speak the text
      print("Speaking: $text");
    } catch (e) {
      print("TTS speak error: $e");
    }
  }

  // Handle navigation item tap with audio feedback
  void _onItemTapped(int index) async {
    // Haptic feedback
    HapticFeedback.lightImpact();

    // Update selected index
    setState(() {
      _selectedIndex = index;
    });

    // Speak the navigation item name
    await _speakText(_pageNames[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: _buildAccessibleBottomNav(),
    );
  }

  Widget _buildAccessibleBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped, // This will trigger audio
        selectedItemColor: Color(0xFF4A90E2),
        unselectedItemColor: Colors.grey[600],
        selectedFontSize: 12,
        unselectedFontSize: 10,
        iconSize: 24,
        elevation: 0,
        backgroundColor: Colors.transparent,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
            tooltip: 'Home Page', // Accessibility
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.image_search_rounded),
            label: 'Vision',
            tooltip: 'Image Recognition',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt_rounded),
            label: 'Camera',
            tooltip: 'Camera',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emergency_share_rounded),
            label: 'Emergency',
            tooltip: 'Emergency',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_rounded),
            label: 'Settings',
            tooltip: 'Settings',
          ),
        ],
      ),
    );
  }
}
