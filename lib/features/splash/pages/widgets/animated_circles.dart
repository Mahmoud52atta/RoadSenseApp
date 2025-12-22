import 'package:flutter/material.dart';

/// Animated circles widget displaying concentric pulsing circles
/// with a cyan/teal gradient color scheme
class AnimatedCircles extends StatelessWidget {
  final Animation<double> animation;

  const AnimatedCircles({super.key, required this.animation});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return CustomPaint(
          painter: CirclesPainter(animationValue: animation.value),
          size: const Size.square(300),
        );
      },
    );
  }
}

/// Custom painter for drawing animated concentric circles
class CirclesPainter extends CustomPainter {
  final double animationValue;

  // Cyan/Teal color palette
  static const Color primaryCyan = Color(0xFF00BCD4);
  static const Color secondaryCyan = Color(0xFF0097A7);

  CirclesPainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Calculate the animation scale (pulsing effect)
    final scale = animationValue;

    // Outer circle (larger radius, more transparent)
    _drawCircle(canvas, center, 120 * scale, primaryCyan.withOpacity(0.3), 2.5);

    // Middle circle (medium radius)
    _drawCircle(canvas, center, 85 * scale, primaryCyan.withOpacity(0.5), 2.5);

    // Inner circle (smaller radius, more opaque)
    _drawCircle(
      canvas,
      center,
      50 * scale,
      secondaryCyan.withOpacity(0.7),
      3.0,
    );
  }

  /// Helper method to draw a single circle with stroke
  void _drawCircle(
    Canvas canvas,
    Offset center,
    double radius,
    Color color,
    double strokeWidth,
  ) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..isAntiAlias = true;

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(CirclesPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
