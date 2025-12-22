import 'package:flutter/material.dart';

/// Car icon widget displayed in the center of the splash screen
/// Features a custom-painted car with yellow highlights
class CarIcon extends StatelessWidget {
  final Animation<double> animation;

  const CarIcon({super.key, required this.animation});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.scale(
          scale: animation.value,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFF1A1F3A), // Dark gray-blue
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: const Icon(
              Icons.directions_car_rounded,
              size: 50,
              color: Color(0xFF00BCD4),
            ),
          ),
        );
      },
    );
  }
}

/// Custom painter for drawing the car icon
class CarIconPainter extends CustomPainter {
  static const Color carColor = Color(0xFF2A2F4A); // Dark car body
  static const Color yellowAccent = Color(0xFFFFD700); // Gold/Yellow

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Draw car body (simple rectangle with rounded corners)
    _drawCarBody(canvas, center, size);

    // Draw wheels
    _drawWheels(canvas, center, size);

    // Draw windows/windshield
    _drawWindows(canvas, center, size);

    // Draw yellow accent marks (bumper/light details)
    _drawAccents(canvas, center, size);
  }

  /// Draw the main car body
  void _drawCarBody(Canvas canvas, Offset center, Size size) {
    final paint = Paint()
      ..color = carColor
      ..style = PaintingStyle.fill;

    // Main body (wider at bottom)
    final bodyRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy + 5),
        width: 35,
        height: 25,
      ),
      const Radius.circular(3),
    );

    canvas.drawRRect(bodyRect, paint);

    // Top section (cab)
    final cabRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy - 8),
        width: 25,
        height: 15,
      ),
      const Radius.circular(2),
    );

    canvas.drawRRect(cabRect, paint);
  }

  /// Draw wheels
  void _drawWheels(Canvas canvas, Offset center, Size size) {
    final wheelPaint = Paint()
      ..color = Colors.grey[800]!
      ..style = PaintingStyle.fill;

    final wheelOutline = Paint()
      ..color = Colors.grey[600]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Left wheel
    final leftWheelCenter = Offset(center.dx - 12, center.dy + 12);
    canvas.drawCircle(leftWheelCenter, 5, wheelPaint);
    canvas.drawCircle(leftWheelCenter, 5, wheelOutline);

    // Right wheel
    final rightWheelCenter = Offset(center.dx + 12, center.dy + 12);
    canvas.drawCircle(rightWheelCenter, 5, wheelPaint);
    canvas.drawCircle(rightWheelCenter, 5, wheelOutline);
  }

  /// Draw windows/windshield
  void _drawWindows(Canvas canvas, Offset center, Size size) {
    final windowPaint = Paint()
      ..color = Colors.grey[700]!.withOpacity(0.6)
      ..style = PaintingStyle.fill;

    // Windshield
    final windshield = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(center.dx - 5, center.dy - 10),
        width: 12,
        height: 8,
      ),
      const Radius.circular(1),
    );

    canvas.drawRRect(windshield, windowPaint);

    // Rear window
    final rearWindow = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(center.dx + 5, center.dy - 8),
        width: 8,
        height: 6,
      ),
      const Radius.circular(1),
    );

    canvas.drawRRect(rearWindow, windowPaint);
  }

  /// Draw yellow accent marks (bumper/lights)
  void _drawAccents(Canvas canvas, Offset center, Size size) {
    final accentPaint = Paint()
      ..color = yellowAccent
      ..style = PaintingStyle.fill;

    // Front bumper/lights (left)
    canvas.drawRect(
      Rect.fromLTWH(center.dx - 18, center.dy + 15, 6, 4),
      accentPaint,
    );

    // Front bumper/lights (right)
    canvas.drawRect(
      Rect.fromLTWH(center.dx + 12, center.dy + 15, 6, 4),
      accentPaint,
    );

    // Roof stripe
    canvas.drawRect(
      Rect.fromLTWH(center.dx - 8, center.dy - 12, 16, 2),
      accentPaint,
    );
  }

  @override
  bool shouldRepaint(CarIconPainter oldDelegate) => false;
}
