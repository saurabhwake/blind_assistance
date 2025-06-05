import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  bool _isHighContrast = false;
  bool _isLargeText = false;
  double _textScaleFactor = 1.0;

  // Modern Vibrant Color Scheme
  static const Color primaryBackground = Color(0xFFF8FAFF);
  static const Color secondaryBackground = Color(0xFFFFFFFF);
  static const Color primaryText = Color(0xFF1A1B3A);
  static const Color secondaryText = Color(0xFF6B7280);
  static const Color vibrantBlue = Color(0xFF3B82F6);
  static const Color vibrantPurple = Color(0xFF8B5CF6);
  static const Color vibrantPink = Color(0xFFEC4899);
  static const Color vibrantGreen = Color(0xFF10B981);
  static const Color vibrantOrange = Color(0xFFF59E0B);
  static const Color vibrantRed = Color(0xFFEF4444);
  static const Color lightBlue = Color(0xFFDBEAFE);
  static const Color lightPurple = Color(0xFFE9D5FF);

  // Dark theme colors
  static const Color darkPrimaryBackground = Color(0xFF111827);
  static const Color darkSecondaryBackground = Color(0xFF1F2937);
  static const Color darkPrimaryText = Color(0xFFF9FAFB);
  static const Color darkSecondaryText = Color(0xFF9CA3AF);

  // Getters
  bool get isDarkMode => _isDarkMode;
  bool get isHighContrast => _isHighContrast;
  bool get isLargeText => _isLargeText;
  double get textScaleFactor => _textScaleFactor;

  // Theme-aware color getters
  Color get currentPrimaryBackground =>
      _isDarkMode ? darkPrimaryBackground : primaryBackground;
  Color get currentSecondaryBackground =>
      _isDarkMode ? darkSecondaryBackground : secondaryBackground;
  Color get currentPrimaryText => _isDarkMode ? darkPrimaryText : primaryText;
  Color get currentSecondaryText =>
      _isDarkMode ? darkSecondaryText : secondaryText;

  ThemeProvider() {
    _loadThemeFromPrefs();
  }

  // Toggle dark mode
  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    _saveThemeToPrefs();
    notifyListeners();
  }

  // Toggle high contrast
  void toggleHighContrast() {
    _isHighContrast = !_isHighContrast;
    _saveThemeToPrefs();
    notifyListeners();
  }

  // Toggle large text
  void toggleLargeText() {
    _isLargeText = !_isLargeText;
    _textScaleFactor = _isLargeText ? 1.2 : 1.0;
    _saveThemeToPrefs();
    notifyListeners();
  }

  // Set dark mode directly
  void setDarkMode(bool value) {
    _isDarkMode = value;
    _saveThemeToPrefs();
    notifyListeners();
  }

  // Get light theme
  ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: primaryBackground,
      primaryColor: vibrantBlue,
      colorScheme: ColorScheme.light(
        primary: vibrantBlue,
        secondary: vibrantPurple,
        surface: secondaryBackground,
        onPrimary: secondaryBackground,
        onSecondary: secondaryBackground,
        onSurface: primaryText,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: vibrantBlue,
        foregroundColor: secondaryBackground,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: vibrantBlue,
          foregroundColor: secondaryBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return vibrantBlue;
          }
          return Colors.grey;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return vibrantBlue.withOpacity(0.3);
          }
          return Colors.grey.withOpacity(0.3);
        }),
      ),
      textTheme: TextTheme(
        displayLarge:
            TextStyle(color: primaryText, fontSize: 32 * _textScaleFactor),
        displayMedium:
            TextStyle(color: primaryText, fontSize: 28 * _textScaleFactor),
        displaySmall:
            TextStyle(color: primaryText, fontSize: 24 * _textScaleFactor),
        headlineLarge:
            TextStyle(color: primaryText, fontSize: 22 * _textScaleFactor),
        headlineMedium:
            TextStyle(color: primaryText, fontSize: 20 * _textScaleFactor),
        headlineSmall:
            TextStyle(color: primaryText, fontSize: 18 * _textScaleFactor),
        bodyLarge:
            TextStyle(color: primaryText, fontSize: 16 * _textScaleFactor),
        bodyMedium:
            TextStyle(color: primaryText, fontSize: 14 * _textScaleFactor),
        bodySmall:
            TextStyle(color: secondaryText, fontSize: 12 * _textScaleFactor),
      ),
    );
  }

  // Get dark theme
  ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkPrimaryBackground,
      primaryColor: vibrantBlue,
      colorScheme: ColorScheme.dark(
        primary: vibrantBlue,
        secondary: vibrantPurple,
        surface: darkSecondaryBackground,
        onPrimary: darkPrimaryBackground,
        onSecondary: darkPrimaryBackground,
        onSurface: darkPrimaryText,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: darkSecondaryBackground,
        foregroundColor: darkPrimaryText,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: vibrantBlue,
          foregroundColor: darkPrimaryBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return vibrantBlue;
          }
          return Colors.grey;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return vibrantBlue.withOpacity(0.3);
          }
          return Colors.grey.withOpacity(0.3);
        }),
      ),
      textTheme: TextTheme(
        displayLarge:
            TextStyle(color: darkPrimaryText, fontSize: 32 * _textScaleFactor),
        displayMedium:
            TextStyle(color: darkPrimaryText, fontSize: 28 * _textScaleFactor),
        displaySmall:
            TextStyle(color: darkPrimaryText, fontSize: 24 * _textScaleFactor),
        headlineLarge:
            TextStyle(color: darkPrimaryText, fontSize: 22 * _textScaleFactor),
        headlineMedium:
            TextStyle(color: darkPrimaryText, fontSize: 20 * _textScaleFactor),
        headlineSmall:
            TextStyle(color: darkPrimaryText, fontSize: 18 * _textScaleFactor),
        bodyLarge:
            TextStyle(color: darkPrimaryText, fontSize: 16 * _textScaleFactor),
        bodyMedium:
            TextStyle(color: darkPrimaryText, fontSize: 14 * _textScaleFactor),
        bodySmall: TextStyle(
            color: darkSecondaryText, fontSize: 12 * _textScaleFactor),
      ),
    );
  }

  // Save theme preferences
  void _saveThemeToPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', _isDarkMode);
    prefs.setBool('isHighContrast', _isHighContrast);
    prefs.setBool('isLargeText', _isLargeText);
    prefs.setDouble('textScaleFactor', _textScaleFactor);
  }

  // Load theme preferences
  void _loadThemeFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    _isHighContrast = prefs.getBool('isHighContrast') ?? false;
    _isLargeText = prefs.getBool('isLargeText') ?? false;
    _textScaleFactor = prefs.getDouble('textScaleFactor') ?? 1.0;
    notifyListeners();
  }

  // Reset all settings
  void resetToDefaults() {
    _isDarkMode = false;
    _isHighContrast = false;
    _isLargeText = false;
    _textScaleFactor = 1.0;
    _saveThemeToPrefs();
    notifyListeners();
  }
}
