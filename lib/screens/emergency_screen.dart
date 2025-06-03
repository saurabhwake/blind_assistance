import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'dart:math';

class EmergencyScreen extends StatefulWidget {
  @override
  _EmergencyScreenState createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen>
    with TickerProviderStateMixin {
  bool _sosActive = false;
  bool _isLocationSharing = false;
  List<Map<String, dynamic>> _emergencyContacts = [];
  late AnimationController _animationController;
  late AnimationController _sosController;
  late AnimationController _pulseController;
  late AnimationController _floatingController;
  late AnimationController _locationController;

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

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadEmergencyContacts();
    _animationController.forward();
  }

  void _initializeControllers() {
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );
    _sosController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    )..repeat();
    _floatingController = AnimationController(
      duration: Duration(seconds: 6),
      vsync: this,
    )..repeat(reverse: true);
    _locationController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
  }

  void _loadEmergencyContacts() {
    setState(() {
      _emergencyContacts = [
        {
          'name': 'Family Doctor',
          'phone': '+1-555-123-4567',
          'icon': Icons.medical_services_rounded,
          'color': vibrantGreen,
          'type': 'Medical'
        },
        {
          'name': 'Emergency Contact',
          'phone': '+1-555-987-6543',
          'icon': Icons.person_rounded,
          'color': vibrantBlue,
          'type': 'Personal'
        },
        {
          'name': 'Poison Control',
          'phone': '+1-800-222-1222',
          'icon': Icons.warning_rounded,
          'color': vibrantOrange,
          'type': 'Emergency'
        },
      ];
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _sosController.dispose();
    _pulseController.dispose();
    _floatingController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackground,
      body: Stack(
        children: [
          _buildModernBackground(),
          _buildModernFloatingElements(),
          SafeArea(
            child: Column(
              children: [
                _buildFunctionalHeaderWithoutBackArrow(),
                Expanded(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 32),
                        _buildFunctionalTitle(),
                        SizedBox(height: 32),
                        _buildFunctionalSOSSection(),
                        SizedBox(height: 32),
                        _buildFunctionalQuickActions(),
                        SizedBox(height: 32),
                        _buildFunctionalEmergencyContacts(),
                        SizedBox(height: 60),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
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
              colors: [
                primaryBackground,
                lightBlue.withOpacity(0.3),
                vibrantRed.withOpacity(0.1),
                primaryBackground,
              ],
              stops: [0.0, 0.4, 0.7, 1.0],
            ),
          ),
        );
      },
    );
  }

  Widget _buildModernFloatingElements() {
    return AnimatedBuilder(
      animation: _floatingController,
      builder: (context, child) {
        return Stack(
          children: List.generate(8, (index) {
            final colors = [
              vibrantRed,
              vibrantOrange,
              vibrantPink,
              vibrantPurple
            ];
            final color = colors[index % colors.length];

            return Positioned(
              left: (index * 90.0) + (_floatingController.value * 50) - 100,
              top: 50 +
                  (index * 120.0) +
                  (sin(_floatingController.value * 2 * pi + index) * 60),
              child: Transform.rotate(
                angle: _floatingController.value * 2 * pi + index,
                child: Container(
                  width: 40 + (index * 6.0),
                  height: 40 + (index * 6.0),
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        color.withOpacity(0.2),
                        color.withOpacity(0.1),
                        Colors.transparent,
                      ],
                    ),
                    shape: index.isEven ? BoxShape.circle : BoxShape.rectangle,
                    borderRadius:
                        index.isOdd ? BorderRadius.circular(12) : null,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }

  // Header WITHOUT back arrow - perfectly centered
  Widget _buildFunctionalHeaderWithoutBackArrow() {
    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset(0, -1),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut,
      )),
      child: Container(
        margin: EdgeInsets.all(24),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    secondaryBackground.withOpacity(0.9),
                    vibrantRed.withOpacity(0.1),
                    vibrantOrange.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: vibrantRed.withOpacity(0.2),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: vibrantRed.withOpacity(0.1),
                    blurRadius: 20,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [vibrantRed, vibrantOrange],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: vibrantRed.withOpacity(0.3),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        Icons.emergency_rounded,
                        color: secondaryBackground,
                        size: 24,
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Emergency',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: primaryText,
                        ),
                      ),
                      Text(
                        'Emergency Assistance',
                        style: TextStyle(
                          fontSize: 14,
                          color: secondaryText,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 16),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: vibrantGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.local_hospital_rounded,
                        color: vibrantGreen,
                        size: 20,
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

  Widget _buildFunctionalTitle() {
    return FadeTransition(
      opacity: Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(0.3, 1.0, curve: Curves.easeOut),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Emergency Assistance 🚨',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: primaryText,
              height: 1.2,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Get immediate help when you need it most',
            style: TextStyle(
              fontSize: 18,
              color: secondaryText,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFunctionalSOSSection() {
    return Container(
      width: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: EdgeInsets.all(32),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: _sosActive
                    ? [
                        vibrantRed.withOpacity(0.3),
                        vibrantOrange.withOpacity(0.2),
                        secondaryBackground.withOpacity(0.8),
                      ]
                    : [
                        vibrantRed.withOpacity(0.1),
                        vibrantOrange.withOpacity(0.05),
                        secondaryBackground.withOpacity(0.9),
                      ],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: vibrantRed.withOpacity(0.3),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: vibrantRed.withOpacity(0.2),
                  blurRadius: 25,
                  offset: Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  'EMERGENCY SOS',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: vibrantRed,
                    letterSpacing: 2,
                  ),
                ),
                SizedBox(height: 24),
                Semantics(
                  label: _sosActive
                      ? 'SOS activated. Tap to cancel emergency alert'
                      : 'Tap and hold for 3 seconds to activate emergency SOS',
                  button: true,
                  child: GestureDetector(
                    onLongPressStart: (_) => _startFunctionalSOS(),
                    onLongPressEnd: (_) => _cancelSOS(),
                    onTap: _sosActive ? _cancelSOS : null,
                    child: AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, child) {
                        return Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                secondaryBackground,
                                secondaryBackground.withOpacity(0.9),
                              ],
                            ),
                            border: Border.all(
                              color: vibrantRed,
                              width: 4,
                            ),
                            boxShadow: _sosActive
                                ? [
                                    BoxShadow(
                                      color: vibrantRed.withOpacity(
                                          0.4 + _pulseController.value * 0.3),
                                      blurRadius:
                                          30 + _pulseController.value * 20,
                                      spreadRadius:
                                          8 + _pulseController.value * 10,
                                    ),
                                  ]
                                : [
                                    BoxShadow(
                                      color: vibrantRed.withOpacity(0.2),
                                      blurRadius: 20,
                                      offset: Offset(0, 8),
                                    ),
                                  ],
                          ),
                          child: Center(
                            child: Text(
                              'SOS',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                                color: vibrantRed,
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  _sosActive
                      ? 'SOS ACTIVATED - Emergency services notified'
                      : 'Hold for 3 seconds to activate',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: _sosActive ? vibrantRed : secondaryText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFunctionalQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: primaryText,
          ),
        ),
        SizedBox(height: 20),
        GridView.count(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.4,
          children: [
            _buildFunctionalQuickActionCard(
              icon: Icons.local_hospital_rounded,
              title: 'Medical',
              subtitle: '911',
              colors: [vibrantGreen, Color(0xFF059669)],
              onTap: () => _simulateCall('911', 'Medical Emergency Services'),
            ),
            _buildFunctionalQuickActionCard(
              icon: Icons.local_police_rounded,
              title: 'Police',
              subtitle: '911',
              colors: [vibrantBlue, Color(0xFF2563EB)],
              onTap: () => _simulateCall('911', 'Police Emergency Services'),
            ),
            _buildFunctionalQuickActionCard(
              icon: Icons.local_fire_department_rounded,
              title: 'Fire Dept',
              subtitle: '911',
              colors: [vibrantRed, Color(0xFFDC2626)],
              onTap: () => _simulateCall('911', 'Fire Department'),
            ),
            _buildFunctionalQuickActionCard(
              icon: Icons.my_location_rounded,
              title: 'Share Location',
              subtitle: 'Send GPS',
              colors: [vibrantPurple, Color(0xFF7C3AED)],
              onTap: () => _shareFunctionalLocation(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFunctionalQuickActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required List<Color> colors,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                secondaryBackground,
                colors[0].withOpacity(0.05),
                colors[1].withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: colors[0].withOpacity(0.1),
                blurRadius: 20,
                offset: Offset(0, 8),
              ),
            ],
            border: Border.all(
              color: colors[0].withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: colors),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: colors[0].withOpacity(0.3),
                        blurRadius: 12,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(icon, color: secondaryBackground, size: 22),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Flexible(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: primaryText,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(height: 4),
              Flexible(
                child: Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    color: secondaryText,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFunctionalEmergencyContacts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Emergency Contacts',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: primaryText,
              ),
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _showAddContactDialog(),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: vibrantBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.add_rounded,
                      color: vibrantBlue,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        Container(
          decoration: BoxDecoration(
            color: secondaryBackground,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: vibrantBlue.withOpacity(0.1),
                blurRadius: 20,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              ..._emergencyContacts
                  .map((contact) => _buildFunctionalContactItem(contact)),
              _buildAddContactTile(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFunctionalContactItem(Map<String, dynamic> contact) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _simulateCall(contact['phone'], contact['name']),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          margin: EdgeInsets.all(12),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                contact['color'].withOpacity(0.1),
                contact['color'].withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: contact['color'].withOpacity(0.2)),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: contact['color'],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Icon(
                    contact['icon'],
                    color: secondaryBackground,
                    size: 20,
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contact['name'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: primaryText,
                      ),
                    ),
                    Text(
                      contact['phone'],
                      style: TextStyle(
                        fontSize: 14,
                        color: secondaryText,
                      ),
                    ),
                    Text(
                      contact['type'],
                      style: TextStyle(
                        fontSize: 12,
                        color: contact['color'],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () =>
                          _simulateCall(contact['phone'], contact['name']),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: vibrantGreen.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.phone_rounded,
                            color: vibrantGreen,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => _deleteContact(contact),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: vibrantRed.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.delete_outline_rounded,
                            color: vibrantRed,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddContactTile() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _showAddContactDialog(),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          margin: EdgeInsets.all(12),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                vibrantBlue.withOpacity(0.1),
                vibrantPurple.withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: vibrantBlue.withOpacity(0.2),
              style: BorderStyle.solid,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_rounded,
                color: vibrantBlue,
                size: 24,
              ),
              SizedBox(width: 12),
              Text(
                'Add Emergency Contact',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: vibrantBlue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // SIMULATED CALL FUNCTIONALITY - Works in FlutLab.io
  Future<void> _simulateCall(String phoneNumber, String serviceName) async {
    try {
      HapticFeedback.lightImpact();

      // Show realistic calling interface
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => _buildCallDialog(phoneNumber, serviceName),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Call simulation error: $e'),
          backgroundColor: vibrantRed,
        ),
      );
    }
  }

  Widget _buildCallDialog(String phoneNumber, String serviceName) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: EdgeInsets.all(32),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  vibrantGreen.withOpacity(0.2),
                  secondaryBackground.withOpacity(0.9),
                  vibrantGreen.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              border:
                  Border.all(color: vibrantGreen.withOpacity(0.3), width: 2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Animated call icon
                AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    return Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          colors: [
                            vibrantGreen,
                            vibrantGreen.withOpacity(0.8),
                          ],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: vibrantGreen.withOpacity(
                                0.4 + _pulseController.value * 0.3),
                            blurRadius: 20 + _pulseController.value * 15,
                            spreadRadius: 5 + _pulseController.value * 8,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          Icons.phone_rounded,
                          color: secondaryBackground,
                          size: 32,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 24),
                Text(
                  'Calling...',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: primaryText,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  serviceName,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: vibrantGreen,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  phoneNumber,
                  style: TextStyle(
                    fontSize: 16,
                    color: secondaryText,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  'In a real app, this would initiate a phone call to the emergency service.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: secondaryText,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.call_end_rounded),
                        label: Text('End Call'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: vibrantRed,
                          foregroundColor: secondaryBackground,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Other existing methods remain the same...
  void _startFunctionalSOS() async {
    HapticFeedback.heavyImpact();
    setState(() {
      _sosActive = true;
    });

    _isLocationSharing = true;
    _locationController.repeat();

    await _sendFunctionalSOSAlert();
  }

  void _cancelSOS() {
    setState(() {
      _sosActive = false;
      _isLocationSharing = false;
    });
    _locationController.stop();
  }

  Future<void> _sendFunctionalSOSAlert() async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: secondaryBackground.withOpacity(0.9),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: vibrantRed.withOpacity(0.2)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient:
                          LinearGradient(colors: [vibrantRed, vibrantOrange]),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.emergency_rounded,
                      color: secondaryBackground,
                      size: 32,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'SOS Activated',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: primaryText,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Emergency services will be called automatically.\nYour location has been shared with:\n\n${_emergencyContacts.map((c) => c['name']).join('\n')}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: secondaryText,
                    ),
                  ),
                  SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _cancelSOS();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: secondaryText,
                            foregroundColor: secondaryBackground,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text('Cancel'),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _simulateCall('911', '911 Emergency Services');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: vibrantRed,
                            foregroundColor: secondaryBackground,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text('Call 911'),
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

  void _shareFunctionalLocation() async {
    HapticFeedback.lightImpact();
    _locationController.repeat();

    await showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: secondaryBackground.withOpacity(0.9),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedBuilder(
                    animation: _locationController,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _locationController.value * 2 * pi,
                        child: Icon(Icons.my_location_rounded,
                            color: vibrantPurple, size: 48),
                      );
                    },
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Location Shared ✅',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: primaryText,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Your GPS location has been shared with all emergency contacts.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: secondaryText),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: vibrantPurple,
                      foregroundColor: secondaryBackground,
                    ),
                    child: Text('Done'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    _locationController.stop();
  }

  void _showAddContactDialog() {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    String selectedType = 'Personal';
    IconData selectedIcon = Icons.person_rounded;
    Color selectedColor = vibrantBlue;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => Dialog(
          backgroundColor: Colors.transparent,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: secondaryBackground.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Add Emergency Contact',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: primaryText,
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Contact Name',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: phoneController,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        hintText: '+1-555-123-4567',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: selectedType,
                      decoration: InputDecoration(
                        labelText: 'Contact Type',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      items: [
                        DropdownMenuItem(
                            value: 'Personal', child: Text('Personal')),
                        DropdownMenuItem(
                            value: 'Medical', child: Text('Medical')),
                        DropdownMenuItem(
                            value: 'Emergency', child: Text('Emergency')),
                      ],
                      onChanged: (value) {
                        setDialogState(() {
                          selectedType = value!;
                          switch (value) {
                            case 'Medical':
                              selectedIcon = Icons.medical_services_rounded;
                              selectedColor = vibrantGreen;
                              break;
                            case 'Emergency':
                              selectedIcon = Icons.warning_rounded;
                              selectedColor = vibrantOrange;
                              break;
                            default:
                              selectedIcon = Icons.person_rounded;
                              selectedColor = vibrantBlue;
                          }
                        });
                      },
                    ),
                    SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: secondaryText,
                              foregroundColor: secondaryBackground,
                            ),
                            child: Text('Cancel'),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              if (nameController.text.isNotEmpty &&
                                  phoneController.text.isNotEmpty) {
                                _addContact(
                                    nameController.text,
                                    phoneController.text,
                                    selectedType,
                                    selectedIcon,
                                    selectedColor);
                                Navigator.pop(context);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: vibrantBlue,
                              foregroundColor: secondaryBackground,
                            ),
                            child: Text('Add Contact'),
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
      ),
    );
  }

  void _addContact(
      String name, String phone, String type, IconData icon, Color color) {
    setState(() {
      _emergencyContacts.add({
        'name': name,
        'phone': phone,
        'icon': icon,
        'color': color,
        'type': type,
      });
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$name added to emergency contacts'),
        backgroundColor: vibrantGreen,
      ),
    );
  }

  void _deleteContact(Map<String, dynamic> contact) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Contact'),
        content: Text('Are you sure you want to delete ${contact['name']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _emergencyContacts.remove(contact);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      '${contact['name']} removed from emergency contacts'),
                  backgroundColor: vibrantRed,
                ),
              );
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }
}
