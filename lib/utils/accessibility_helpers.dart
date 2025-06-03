import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AccessibilityHelpers {
  // Haptic feedback for better user experience
  static void provideFeedback() {
    HapticFeedback.lightImpact();
  }

  // Voice announcement helper
  static void announceForAccessibility(BuildContext context, String message) {
    SemanticsService.announce(message, TextDirection.ltr);
  }

  // Custom button with accessibility features
  static Widget accessibleButton({
    required Widget child,
    required VoidCallback onPressed,
    required String semanticsLabel,
    Color? backgroundColor,
    EdgeInsetsGeometry? padding,
  }) {
    return Semantics(
      label: semanticsLabel,
      button: true,
      child: Material(
        color: backgroundColor ?? Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () {
            provideFeedback();
            onPressed();
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: padding ?? EdgeInsets.all(16),
            child: child,
          ),
        ),
      ),
    );
  }
}
