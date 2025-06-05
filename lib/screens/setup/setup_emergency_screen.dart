import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

// HomeScreen color palette for consistency
const Color primaryBackground = Color(0xFFF8FAFF);
const Color secondaryBackground = Color(0xFFFFFFFF);
const Color primaryText = Color(0xFF1A1B3A);
const Color secondaryText = Color(0xFF6B7280);
const Color vibrantBlue = Color(0xFF3B82F6);
const Color vibrantPurple = Color(0xFF8B5CF6);
const Color vibrantPink = Color(0xFFEC4899);
const Color vibrantGreen = Color(0xFF10B981);
const Color lightBlue = Color(0xFFDBEAFE);
const Color lightPurple = Color(0xFFE9D5FF);

class SetupEmergencyScreen extends StatefulWidget {
  final VoidCallback onNext;
  const SetupEmergencyScreen({required this.onNext, Key? key}) : super(key: key);

  @override
  State<SetupEmergencyScreen> createState() => _SetupEmergencyScreenState();
}

class _SetupEmergencyScreenState extends State<SetupEmergencyScreen>
    with TickerProviderStateMixin {
  final List<TextEditingController> _nameControllers = [];
  final List<TextEditingController> _phoneControllers = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late AnimationController _animationController;
  late AnimationController _floatingController;
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _addNewContact();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _floatingController = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    );
    _rotationController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    );
    _animationController.forward();
    _floatingController.repeat(reverse: true);
    _rotationController.repeat();
  }

  @override
  void dispose() {
    for (final c in _nameControllers) {
      c.dispose();
    }
    for (final c in _phoneControllers) {
      c.dispose();
    }
    _animationController.dispose();
    _floatingController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  void _addNewContact() {
    setState(() {
      _nameControllers.add(TextEditingController());
      _phoneControllers.add(TextEditingController());
    });
  }

  void _removeContact(int index) {
    setState(() {
      _nameControllers[index].dispose();
      _phoneControllers[index].dispose();
      _nameControllers.removeAt(index);
      _phoneControllers.removeAt(index);
    });
  }

  bool _validateContacts() {
    for (int i = 0; i < _phoneControllers.length; i++) {
      String name = _nameControllers[i].text.trim();
      String phone = _phoneControllers[i].text.trim();
      if (name.isEmpty ||
          phone.isEmpty ||
          !RegExp(r'^[0-9]{10}$').hasMatch(phone)) {
        return false;
      }
    }
    return true;
  }

  Future<void> _saveContacts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map<String, String>> contacts = [];
    for (int i = 0; i < _nameControllers.length; i++) {
      contacts.add({
        'name': _nameControllers[i].text.trim(),
        'phone': _phoneControllers[i].text.trim(),
      });
    }
    await prefs.setString('emergencyContacts', jsonEncode(contacts));
  }

  void _submit() async {
    if ((_formKey.currentState?.validate() ?? false) && _validateContacts()) {
      await _saveContacts();
      widget.onNext();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Please enter valid names and 10-digit phone numbers")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWide = size.width > 600;

    return Scaffold(
      backgroundColor: primaryBackground,
      body: Stack(
        children: [
          _buildVibrantBackground(),
          _buildModernFloatingElements(),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: isWide ? 540 : double.infinity),
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: isWide ? 32 : 16, vertical: 32),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildModernHeader(isWide),
                              const SizedBox(height: 28),
                              Text(
                                "Add emergency contacts",
                                style: TextStyle(
                                  fontSize: isWide ? 28 : 22,
                                  fontWeight: FontWeight.w700,
                                  color: primaryText,
                                  letterSpacing: 0.2,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "These contacts will be notified in emergencies.",
                                style: TextStyle(
                                  fontSize: isWide ? 16 : 14,
                                  color: secondaryText,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 28),
                              Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    ...List.generate(_nameControllers.length, (index) {
                                      return Padding(
                                        padding: const EdgeInsets.only(bottom: 22.0),
                                        child: _buildGlassCard(index, isWide),
                                      );
                                    }),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: TextButton.icon(
                                        onPressed: _addNewContact,
                                        icon: Icon(Icons.add_circle_outline,
                                            color: vibrantPink),
                                        label: Text(
                                          "Add Another Contact",
                                          style: TextStyle(
                                            color: vibrantPink,
                                            fontWeight: FontWeight.w600,
                                            fontSize: isWide ? 16 : 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 36),
                              ScaleTransition(
                                scale: Tween(begin: 0.9, end: 1.0).animate(
                                    CurvedAnimation(
                                        parent: _animationController,
                                        curve: const Interval(0.5, 1.0,
                                            curve: Curves.elasticOut))),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(vertical: 18),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                      backgroundColor: vibrantGreen,
                                      foregroundColor: secondaryBackground,
                                      elevation: 8,
                                      shadowColor: vibrantGreen.withOpacity(0.4),
                                    ),
                                    onPressed: _submit,
                                    child: const Text(
                                      "Next",
                                      style: TextStyle(
                                          fontSize: 18, fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // --- BOTTOM CENTERED BACKWARD ARROW ---
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, size: 36),
                      tooltip: 'Back',
                      color: vibrantBlue,
                      onPressed: () => Navigator.of(context).pop(),
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

  Widget _buildVibrantBackground() {
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
                lightPurple.withOpacity(0.2),
                primaryBackground,
              ],
              stops: const [0.0, 0.4, 0.7, 1.0],
            ),
          ),
          child: Stack(
            children: [
              CustomPaint(
                painter: ModernBlobPainter(_floatingController.value),
                size: Size.infinite,
              ),
              CustomPaint(
                painter: GeometricPatternPainter(_rotationController.value),
                size: Size.infinite,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildModernFloatingElements() {
    return AnimatedBuilder(
      animation: _floatingController,
      builder: (context, child) {
        final width = MediaQuery.of(context).size.width;
        return Stack(
          children: List.generate(8, (index) {
            final colors = [
              vibrantBlue,
              vibrantPurple,
              vibrantPink,
              vibrantGreen
            ];
            final color = colors[index % colors.length];
            return Positioned(
              left: (index * (width / 8)) +
                  (_floatingController.value * (width / 16)) -
                  100,
              top: 50 +
                  (index * 120.0) +
                  (sin(_floatingController.value * 2 * pi + index) * 60),
              child: Transform.rotate(
                angle: _rotationController.value * 2 * pi + index,
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

  Widget _buildModernHeader(bool isWide) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, -0.6),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut,
      )),
      child: Container(
        margin: EdgeInsets.all(isWide ? 32 : 16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(isWide ? 32 : 20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: EdgeInsets.symmetric(
                  vertical: isWide ? 28 : 20, horizontal: isWide ? 32 : 18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    secondaryBackground.withOpacity(0.9),
                    vibrantBlue.withOpacity(0.1),
                    vibrantPurple.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(isWide ? 32 : 20),
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
                  Container(
                    width: isWide ? 56 : 48,
                    height: isWide ? 56 : 48,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [vibrantBlue, vibrantPurple],
                      ),
                      borderRadius: BorderRadius.circular(isWide ? 20 : 16),
                      boxShadow: [
                        BoxShadow(
                          color: vibrantBlue.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        Icons.contact_emergency_rounded,
                        color: secondaryBackground,
                        size: isWide ? 32 : 24,
                      ),
                    ),
                  ),
                  SizedBox(width: isWide ? 24 : 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Emergency Setup',
                          style: TextStyle(
                            fontSize: isWide ? 28 : 22,
                            fontWeight: FontWeight.w800,
                            color: primaryText,
                          ),
                        ),
                        Text(
                          'Safety First',
                          style: TextStyle(
                            fontSize: isWide ? 16 : 13,
                            color: secondaryText,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
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

  Widget _buildGlassCard(int index, bool isWide) {
    final nameController = _nameControllers[index];
    final phoneController = _phoneControllers[index];
    return FadeTransition(
      opacity: _animationController,
      child: SlideTransition(
        position: Tween<Offset>(
                begin: const Offset(0, 0.18), end: Offset.zero)
            .animate(CurvedAnimation(
                parent: _animationController,
                curve: Interval(0.13 * index, 1.0, curve: Curves.easeOut))),
        child: Container(
          padding: EdgeInsets.all(isWide ? 20 : 14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                secondaryBackground,
                vibrantGreen.withOpacity(0.05),
                vibrantBlue.withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(isWide ? 28 : 20),
            boxShadow: [
              BoxShadow(
                color: vibrantBlue.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
            border: Border.all(
              color: vibrantBlue.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(isWide ? 16 : 10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [vibrantGreen, vibrantBlue]),
                      borderRadius: BorderRadius.circular(isWide ? 18 : 12),
                      boxShadow: [
                        BoxShadow(
                          color: vibrantGreen.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.person,
                      color: secondaryBackground,
                      size: isWide ? 32 : 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: TextFormField(
                      controller: nameController,
                      style: TextStyle(
                        color: primaryText,
                        fontWeight: FontWeight.bold,
                        fontSize: isWide ? 18 : 16,
                      ),
                      decoration: const InputDecoration(
                        labelText: "Contact Name",
                        border: InputBorder.none,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter a contact name";
                        }
                        return null;
                      },
                    ),
                  ),
                  if (_nameControllers.length > 1)
                    IconButton(
                      icon: Icon(Icons.delete, color: vibrantPink),
                      onPressed: () => _removeContact(index),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(isWide ? 16 : 10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [vibrantPink, vibrantPurple]),
                      borderRadius: BorderRadius.circular(isWide ? 18 : 12),
                      boxShadow: [
                        BoxShadow(
                          color: vibrantPink.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.phone,
                      color: secondaryBackground,
                      size: isWide ? 32 : 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: TextFormField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      style: TextStyle(
                        color: primaryText,
                        fontWeight: FontWeight.w600,
                        fontSize: isWide ? 16 : 14,
                      ),
                      decoration: const InputDecoration(
                        labelText: "Phone Number",
                        border: InputBorder.none,
                        counterText: "",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter a phone number";
                        } else if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                          return "Enter a valid 10-digit number";
                        }
                        return null;
                      },
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
}

// Custom Painters for Modern Effects (from HomeScreen)
class ModernBlobPainter extends CustomPainter {
  final double animationValue;

  ModernBlobPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          vibrantBlue.withOpacity(0.1),
          vibrantPurple.withOpacity(0.05),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    final path = Path();
    final center = Offset(size.width * 0.7, size.height * 0.3);
    final radius = 100 + animationValue * 20;
    path.addOval(Rect.fromCircle(center: center, radius: radius));
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class GeometricPatternPainter extends CustomPainter {
  final double animationValue;

  GeometricPatternPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = vibrantBlue.withOpacity(0.05)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < 3; i++) {
      final x = size.width * (0.2 + i * 0.3);
      final y = size.height * (0.2 + sin(animationValue * 2 * pi + i) * 0.1);

      canvas.drawCircle(Offset(x, y), 30, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
