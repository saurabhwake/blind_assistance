import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'providers/theme_provider.dart';
import 'widgets/bottom_navigation.dart';

// Import setup screens (make sure each class is defined only in its own file)
import 'screens/setup/setup_intro_screen.dart';
import 'screens/setup/setup_language_screen.dart';
import 'screens/setup/setup_voice_screen.dart';
import 'screens/setup/setup_emergency_screen.dart';
import 'screens/setup/setup_complete_screen.dart';

// Import your new modular settings screen
// import 'screens/settings/settings_screen.dart';
import 'screens/settings/profile_screen.dart';
import 'screens/settings/feedback_screen.dart';
import 'screens/settings/help_support_screen.dart';
import 'screens/settings/about_screen.dart';
import 'screens/settings/privacy_policy_screen.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Sense Path',
            debugShowCheckedModeBanner: false,
            theme: _buildLightTheme(themeProvider),
            darkTheme: _buildDarkTheme(themeProvider),
            themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: LaunchDecider(),
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: TextScaler.linear(
                    (MediaQuery.of(context).textScaleFactor *
                            (themeProvider.isLargeText
                                ? themeProvider.textScaleFactor
                                : 1.0))
                        .clamp(0.8, 1.5),
                  ),
                ),
                child: child!,
              );
            },
          );
        },
      ),
    );
  }

  ThemeData _buildLightTheme(ThemeProvider themeProvider) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Color(0xFF4A90E2),
        brightness: Brightness.light,
        primary: Color(0xFF4A90E2),
        secondary: Color(0xFF357ABD),
      ),
      primaryColor: Color(0xFF4A90E2),
      scaffoldBackgroundColor: Colors.grey[50],
      canvasColor: Colors.white,
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: Color(0xFF4A90E2),
        foregroundColor: Colors.white,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
          letterSpacing: 0.5,
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
          size: 24,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: Color(0xFF4A90E2),
        unselectedItemColor: Colors.grey[600],
        selectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w400,
        ),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: 32 *
              (themeProvider.isLargeText ? themeProvider.textScaleFactor : 1.0),
          fontWeight: FontWeight.w800,
          color: Colors.black,
          height: 1.2,
        ),
        displayMedium: TextStyle(
          fontSize: 24 *
              (themeProvider.isLargeText ? themeProvider.textScaleFactor : 1.0),
          fontWeight: FontWeight.w700,
          color: Colors.black,
          height: 1.3,
        ),
        displaySmall: TextStyle(
          fontSize: 20 *
              (themeProvider.isLargeText ? themeProvider.textScaleFactor : 1.0),
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
        titleLarge: TextStyle(
          fontSize: 16 *
              (themeProvider.isLargeText ? themeProvider.textScaleFactor : 1.0),
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        titleMedium: TextStyle(
          fontSize: 18 *
              (themeProvider.isLargeText ? themeProvider.textScaleFactor : 1.0),
          fontWeight: FontWeight.w400,
          color: Colors.grey[600],
          height: 1.4,
        ),
        titleSmall: TextStyle(
          fontSize: 16 *
              (themeProvider.isLargeText ? themeProvider.textScaleFactor : 1.0),
          fontWeight: FontWeight.w500,
          color: Colors.grey[700],
        ),
        bodyLarge: TextStyle(
          fontSize: 16 *
              (themeProvider.isLargeText ? themeProvider.textScaleFactor : 1.0),
          fontWeight: FontWeight.w400,
          color: Colors.black87,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          fontSize: 14 *
              (themeProvider.isLargeText ? themeProvider.textScaleFactor : 1.0),
          fontWeight: FontWeight.w400,
          color: Colors.grey[600],
          height: 1.4,
        ),
        bodySmall: TextStyle(
          fontSize: 12 *
              (themeProvider.isLargeText ? themeProvider.textScaleFactor : 1.0),
          fontWeight: FontWeight.w400,
          color: Colors.grey[500],
        ),
      ),
      cardTheme: CardTheme(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF4A90E2),
          foregroundColor: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: TextStyle(
            fontSize: 16 *
                (themeProvider.isLargeText
                    ? themeProvider.textScaleFactor
                    : 1.0),
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }

  ThemeData _buildDarkTheme(ThemeProvider themeProvider) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Color(0xFF4A90E2),
        brightness: Brightness.dark,
        primary: Color(0xFF4A90E2),
        secondary: Color(0xFF357ABD),
      ),
      primaryColor: Color(0xFF4A90E2),
      scaffoldBackgroundColor: Color(0xFF111827),
      canvasColor: Color(0xFF1F2937),
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: Color(0xFF1F2937),
        foregroundColor: Colors.white,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
          letterSpacing: 0.5,
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
          size: 24,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF1F2937),
        selectedItemColor: Color(0xFF4A90E2),
        unselectedItemColor: Colors.grey[400],
        selectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w400,
        ),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: 32 *
              (themeProvider.isLargeText ? themeProvider.textScaleFactor : 1.0),
          fontWeight: FontWeight.w800,
          color: Colors.white,
          height: 1.2,
        ),
        displayMedium: TextStyle(
          fontSize: 24 *
              (themeProvider.isLargeText ? themeProvider.textScaleFactor : 1.0),
          fontWeight: FontWeight.w700,
          color: Colors.white,
          height: 1.3,
        ),
        displaySmall: TextStyle(
          fontSize: 20 *
              (themeProvider.isLargeText ? themeProvider.textScaleFactor : 1.0),
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
        titleLarge: TextStyle(
          fontSize: 16 *
              (themeProvider.isLargeText ? themeProvider.textScaleFactor : 1.0),
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        titleMedium: TextStyle(
          fontSize: 18 *
              (themeProvider.isLargeText ? themeProvider.textScaleFactor : 1.0),
          fontWeight: FontWeight.w400,
          color: Colors.grey[300],
          height: 1.4,
        ),
        titleSmall: TextStyle(
          fontSize: 16 *
              (themeProvider.isLargeText ? themeProvider.textScaleFactor : 1.0),
          fontWeight: FontWeight.w500,
          color: Colors.grey[300],
        ),
        bodyLarge: TextStyle(
          fontSize: 16 *
              (themeProvider.isLargeText ? themeProvider.textScaleFactor : 1.0),
          fontWeight: FontWeight.w400,
          color: Colors.white70,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          fontSize: 14 *
              (themeProvider.isLargeText ? themeProvider.textScaleFactor : 1.0),
          fontWeight: FontWeight.w400,
          color: Colors.grey[400],
          height: 1.4,
        ),
        bodySmall: TextStyle(
          fontSize: 12 *
              (themeProvider.isLargeText ? themeProvider.textScaleFactor : 1.0),
          fontWeight: FontWeight.w400,
          color: Colors.grey[500],
        ),
      ),
      cardTheme: CardTheme(
        elevation: 4,
        color: Color(0xFF1F2937),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF4A90E2),
          foregroundColor: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: TextStyle(
            fontSize: 16 *
                (themeProvider.isLargeText
                    ? themeProvider.textScaleFactor
                    : 1.0),
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }
}

// Decides whether to show setup or main navigation
class LaunchDecider extends StatefulWidget {
  const LaunchDecider({super.key});

  @override
  _LaunchDeciderState createState() => _LaunchDeciderState();
}

class _LaunchDeciderState extends State<LaunchDecider> {
  bool? _setupCompleted;

  @override
  void initState() {
    super.initState();
    _checkSetupStatus();
  }

  Future<void> _checkSetupStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _setupCompleted = prefs.getBool('setup_completed') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_setupCompleted == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return _setupCompleted! ? BottomNavigationWrapper() : const SetupFlow();
  }
}

// Controls the 5-step setup flow
class SetupFlow extends StatefulWidget {
  const SetupFlow({super.key});

  @override
  _SetupFlowState createState() => _SetupFlowState();
}

class _SetupFlowState extends State<SetupFlow> {
  int _currentStep = 0;

  void _nextStep() async {
    if (_currentStep < 4) {
      setState(() {
        _currentStep++;
      });
    } else {
      // Setup complete: save flag and go to main app
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('setup_completed', true);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => BottomNavigationWrapper()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (_currentStep) {
      case 0:
        return SetupIntroScreen(onNext: _nextStep);
      case 1:
        return SetupLanguageScreen(onNext: _nextStep);
      case 2:
        return SetupVoiceScreen(onNext: _nextStep);
      case 3:
        return SetupEmergencyScreen(onNext: _nextStep);
      case 4:
        return SetupCompleteScreen(onFinish: _nextStep);
      default:
        return Container();
    }
  }
}
