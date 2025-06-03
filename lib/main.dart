import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'providers/theme_provider.dart';
import 'widgets/bottom_navigation.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Sense Path',
            debugShowCheckedModeBanner: false,

            // FIXED: Use modern theme approach without primarySwatch
            theme: _buildLightTheme(themeProvider),
            darkTheme: _buildDarkTheme(themeProvider),
            themeMode:
                themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,

            home: BottomNavigationWrapper(),

            // Enhanced accessibility configurations with theme provider
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaleFactor: (MediaQuery.of(context).textScaleFactor *
                          (themeProvider.isLargeText
                              ? themeProvider.textScaleFactor
                              : 1.0))
                      .clamp(0.8, 1.5),
                ),
                child: child!,
              );
            },
          );
        },
      ),
    );
  }

  // FIXED: Modern light theme without primarySwatch
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

  // FIXED: Modern dark theme without primarySwatch
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
