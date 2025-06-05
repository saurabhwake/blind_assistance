import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';

// Import your modular screens here:
import 'settings/profile_screen.dart';
import 'settings/feedback_screen.dart';
import 'settings/help_support_screen.dart';
import 'settings/about_screen.dart';
import 'settings/privacy_policy_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with TickerProviderStateMixin {
  // Settings variables
  bool _voiceGuidance = true;
  bool _hapticFeedback = true;
  bool _darkMode = false;
  bool _highContrast = false;
  bool _largeText = false;
  bool _notifications = true;
  double _speechRate = 1.0;
  String _selectedLanguage = 'English';
  String _selectedVoice = 'Samantha';

  // Animation controllers
  late AnimationController _animationController;
  late AnimationController _floatingController;

  // Vibrant color scheme
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

  // Get theme-aware colors
  Color get _currentPrimaryBackground =>
      _darkMode ? darkPrimaryBackground : primaryBackground;
  Color get _currentSecondaryBackground =>
      _darkMode ? darkSecondaryBackground : secondaryBackground;
  Color get _currentPrimaryText => _darkMode ? darkPrimaryText : primaryText;
  Color get _currentSecondaryText =>
      _darkMode ? darkSecondaryText : secondaryText;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _floatingController = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..repeat(reverse: true);

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _floatingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _darkMode
          ? ThemeData.dark().copyWith(
              scaffoldBackgroundColor: darkPrimaryBackground,
              primaryColor: vibrantBlue,
              colorScheme: const ColorScheme.dark(
                primary: vibrantBlue,
                secondary: vibrantPurple,
              ),
            )
          : ThemeData.light().copyWith(
              scaffoldBackgroundColor: primaryBackground,
              primaryColor: vibrantBlue,
              colorScheme: const ColorScheme.light(
                primary: vibrantBlue,
                secondary: vibrantPurple,
              ),
            ),
      child: Scaffold(
        backgroundColor: _currentPrimaryBackground,
        body: Stack(
          children: [
            _buildModernBackground(),
            SafeArea(
              child: Column(
                children: [
                  _buildModernHeader(),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 32),
                          _buildModernTitle(),
                          const SizedBox(height: 32),
                          _buildProfileSection(),
                          const SizedBox(height: 32),
                          _buildSettingsCategories(),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernBackground() {
    return AnimatedBuilder(
      animation: _floatingController,
      builder: (context, child) {
        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: _darkMode
                  ? [
                      darkPrimaryBackground,
                      const Color(0xFF192133),
                      vibrantBlue.withOpacity(0.05),
                      vibrantPurple.withOpacity(0.02),
                      darkPrimaryBackground,
                    ]
                  : [
                      primaryBackground,
                      lightBlue.withOpacity(0.3),
                      lightPurple.withOpacity(0.2),
                      primaryBackground,
                    ],
              stops: const [0.0, 0.4, 0.7, 0.9, 1.0],
            ),
          ),
        );
      },
    );
  }

  Widget _buildModernHeader() {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, -1),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut,
      )),
      child: Container(
        margin: const EdgeInsets.all(24),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: _darkMode
                      ? [
                          darkSecondaryBackground.withOpacity(0.9),
                          vibrantBlue.withOpacity(0.1),
                          vibrantPurple.withOpacity(0.05),
                        ]
                      : [
                          secondaryBackground.withOpacity(0.9),
                          vibrantBlue.withOpacity(0.1),
                          vibrantPurple.withOpacity(0.05),
                        ],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: vibrantBlue.withOpacity(0.2),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: vibrantBlue.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // The back arrow button has been removed here.
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [vibrantBlue, vibrantPurple],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: vibrantBlue.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.settings_rounded,
                            color: secondaryBackground,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          'Settings',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: _currentPrimaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => _showContextMenu(context),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: vibrantBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.more_vert_rounded,
                          color: vibrantBlue,
                          size: 20,
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
    );
  }
  Widget _buildModernTitle() {
    return FadeTransition(
      opacity: Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'App Settings ⚙️',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: _currentPrimaryText,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Customize your experience for better accessibility',
            style: TextStyle(
              fontSize: 18,
              color: _currentSecondaryText,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            vibrantBlue.withOpacity(0.15),
            vibrantPurple.withOpacity(0.1),
            _currentSecondaryBackground.withOpacity(0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: vibrantBlue.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: vibrantBlue.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [vibrantBlue, vibrantPurple],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: vibrantBlue.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.person_rounded,
                    color: secondaryBackground,
                    size: 40,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'User Profile',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: _currentPrimaryText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Set up your preferences for a personalized experience',
                      style: TextStyle(
                        fontSize: 14,
                        color: _currentSecondaryText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            ),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              decoration: BoxDecoration(
                color: vibrantBlue,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: vibrantBlue.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.edit_rounded,
                    color: secondaryBackground,
                    size: 18,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Edit Profile',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: secondaryBackground,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCategories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Appearance Section
        _buildSettingsSectionHeader('Appearance', Icons.palette_outlined),
        const SizedBox(height: 16),
        _buildSettingsCard([
          _buildAnimatedSwitchTile(
            'Dark Mode',
            'Switch to dark theme',
            Icons.dark_mode_rounded,
            _darkMode,
            (value) {
              setState(() => _darkMode = value);
              HapticFeedback.lightImpact();
            },
            vibrantBlue,
          ),
          _buildAnimatedSwitchTile(
            'High Contrast',
            'Increase text & UI contrast',
            Icons.contrast_rounded,
            _highContrast,
            (value) {
              setState(() => _highContrast = value);
              HapticFeedback.lightImpact();
            },
            vibrantPurple,
          ),
          _buildAnimatedSwitchTile(
            'Large Text',
            'Increase text size',
            Icons.text_fields_rounded,
            _largeText,
            (value) {
              setState(() => _largeText = value);
              HapticFeedback.lightImpact();
            },
            vibrantOrange,
          ),
        ]),
        const SizedBox(height: 32),

        // Accessibility Section
        _buildSettingsSectionHeader(
            'Accessibility', Icons.accessibility_new_rounded),
        const SizedBox(height: 16),
        _buildSettingsCard([
          _buildAnimatedSwitchTile(
            'Voice Guidance',
            'Enable spoken instructions',
            Icons.record_voice_over_rounded,
            _voiceGuidance,
            (value) {
              setState(() => _voiceGuidance = value);
              HapticFeedback.lightImpact();
            },
            vibrantGreen,
          ),
          _buildAnimatedSwitchTile(
            'Haptic Feedback',
            'Vibration for confirmations',
            Icons.vibration_rounded,
            _hapticFeedback,
            (value) {
              setState(() => _hapticFeedback = value);
              HapticFeedback.lightImpact();
            },
            vibrantPink,
          ),
          _buildSliderTile(
            'Speech Rate',
            'Adjust voice guidance speed',
            Icons.speed_rounded,
            _speechRate,
            0.5,
            2.0,
            (value) {
              setState(() => _speechRate = value);
            },
            vibrantBlue,
          ),
        ]),

        const SizedBox(height: 32),

        // Notifications Section
        _buildSettingsSectionHeader(
            'Notifications', Icons.notifications_active_rounded),
        const SizedBox(height: 16),
        _buildSettingsCard([
          _buildAnimatedSwitchTile(
            'Push Notifications',
            'Receive important alerts',
            Icons.notifications_rounded,
            _notifications,
            (value) {
              setState(() => _notifications = value);
              HapticFeedback.lightImpact();
            },
            vibrantOrange,
          ),
        ]),

        const SizedBox(height: 32),

        // Language Section
        _buildSettingsSectionHeader('Language & Voice', Icons.language_rounded),
        const SizedBox(height: 16),
        _buildSettingsCard([
          _buildDropdownTile(
            'Language',
            'Select app language',
            Icons.translate_rounded,
            _selectedLanguage,
            ['English', 'Spanish', 'French', 'German', 'Japanese', 'Chinese'],
            (value) {
              setState(() => _selectedLanguage = value!);
              HapticFeedback.lightImpact();
            },
            vibrantPurple,
          ),
          _buildDropdownTile(
            'Voice',
            'Select voice assistant',
            Icons.record_voice_over_rounded,
            _selectedVoice,
            ['Samantha', 'Alex', 'Victoria', 'Tom', 'Daniel'],
            (value) {
              setState(() => _selectedVoice = value!);
              HapticFeedback.lightImpact();
            },
            vibrantBlue,
          ),
        ]),

        const SizedBox(height: 32),

        // About and Help Section
        _buildSettingsSectionHeader('About & Help', Icons.help_outline_rounded),
        const SizedBox(height: 16),
        _buildSettingsCard([
          _buildNavigationTile(
            'Profile',
            'View and edit your profile',
            Icons.account_circle_rounded,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            ),
            vibrantBlue,
          ),
          _buildNavigationTile(
            'Feedback',
            'Send us your feedback',
            Icons.feedback_rounded,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FeedbackScreen()),
            ),
            vibrantPurple,
          ),
          _buildNavigationTile(
            'Help & Support',
            'Get assistance with the app',
            Icons.support_agent_rounded,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HelpSupportScreen()),
            ),
            vibrantOrange,
          ),
          _buildNavigationTile(
            'About the App',
            'Version, licenses & credits',
            Icons.info_outline_rounded,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AboutScreen()),
            ),
            vibrantGreen,
          ),
          _buildNavigationTile(
            'Privacy Policy',
            'How we handle your data',
            Icons.security_rounded,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()),
            ),
            vibrantPurple,
          ),
        ]),
      ],
    );
  }

  Widget _buildSettingsSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          color: vibrantBlue,
          size: 24,
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: _currentPrimaryText,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: _currentSecondaryBackground,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: vibrantBlue.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildAnimatedSwitchTile(
    String title,
    String subtitle,
    IconData icon,
    bool value,
    ValueChanged<bool> onChanged,
    Color iconColor,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: () => onChanged(!value),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: _currentPrimaryText,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: _currentSecondaryText,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: value,
                onChanged: onChanged,
                activeColor: iconColor,
                activeTrackColor: iconColor.withOpacity(0.3),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSliderTile(
    String title,
    String subtitle,
    IconData icon,
    double value,
    double min,
    double max,
    ValueChanged<double> onChanged,
    Color iconColor,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: _currentPrimaryText,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: _currentSecondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${value.toStringAsFixed(1)}x',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: iconColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SliderTheme(
              data: SliderThemeData(
                activeTrackColor: iconColor,
                inactiveTrackColor: iconColor.withOpacity(0.2),
                thumbColor: iconColor,
              ),
              child: Slider(
                value: value,
                min: min,
                max: max,
                divisions: 15,
                onChanged: (newValue) {
                  onChanged(newValue);
                  HapticFeedback.lightImpact();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownTile(
    String title,
    String subtitle,
    IconData icon,
    String value,
    List<String> options,
    ValueChanged<String?> onChanged,
    Color iconColor,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: _currentPrimaryText,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: _currentSecondaryText,
                    ),
                  ),
                ],
              ),
            ),
            DropdownButton<String>(
              value: value,
              icon: Icon(Icons.arrow_drop_down, color: iconColor),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: _currentPrimaryText,
              ),
              underline: const SizedBox(),
              onChanged: onChanged,
              items: options.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              dropdownColor: _currentSecondaryBackground,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationTile(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
    Color iconColor,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: _currentPrimaryText,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: _currentSecondaryText,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: _currentSecondaryText,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Context Menu for the 3-dot icon
  void _showContextMenu(BuildContext context) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero),
            ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    showMenu(
      context: context,
      position: position,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: _currentSecondaryBackground,
      items: [
        _buildPopupMenuItem(
          'Reset Settings',
          Icons.refresh_rounded,
          vibrantBlue,
          () => _showResetSettingsDialog(),
        ),
        _buildPopupMenuItem(
          'Export Settings',
          Icons.upload_rounded,
          vibrantGreen,
          () => _exportSettings(),
        ),
        _buildPopupMenuItem(
          'Import Settings',
          Icons.download_rounded,
          vibrantOrange,
          () => _importSettings(),
        ),
        _buildPopupMenuItem(
          'Report Issue',
          Icons.bug_report_rounded,
          vibrantRed,
          () => _reportIssue(),
        ),
      ],
    );
  }

  PopupMenuItem<String> _buildPopupMenuItem(
    String text,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return PopupMenuItem<String>(
      value: text,
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(
              color: _currentPrimaryText,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showResetSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: _currentSecondaryBackground,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: vibrantRed.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.refresh_rounded,
                      color: vibrantRed,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Reset Settings',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: _currentPrimaryText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'This will reset all settings to their default values. This action cannot be undone.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: _currentSecondaryText,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _darkMode
                                ? darkSecondaryBackground
                                : Colors.grey[200],
                            foregroundColor:
                                _darkMode ? darkPrimaryText : primaryText,
                          ),
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _voiceGuidance = true;
                              _hapticFeedback = true;
                              _darkMode = false;
                              _highContrast = false;
                              _largeText = false;
                              _notifications = true;
                              _speechRate = 1.0;
                              _selectedLanguage = 'English';
                              _selectedVoice = 'Samantha';
                            });
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Settings reset to defaults'),
                                backgroundColor: vibrantBlue,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: vibrantRed,
                            foregroundColor: secondaryBackground,
                          ),
                          child: const Text('Reset'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _exportSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Settings exported successfully'),
        backgroundColor: vibrantGreen,
      ),
    );
  }

  void _importSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Settings imported successfully'),
        backgroundColor: vibrantBlue,
      ),
    );
  }

  void _reportIssue() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Issue reported. Thank you for your feedback!'),
        backgroundColor: vibrantOrange,
      ),
    );
  }
}
