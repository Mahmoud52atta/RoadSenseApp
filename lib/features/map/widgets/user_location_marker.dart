import 'package:flutter/material.dart';
// no external model imports required for this widget

/// Simple custom marker widget that displays a circle with an inner dot and
/// a subtle shadow — looks modern and is easy to theme.
class UserLocationMarker extends StatelessWidget {
  final double size;
  const UserLocationMarker({this.size = 56, super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    final bg = Theme.of(context).scaffoldBackgroundColor;
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bg,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Container(
        width: size * 0.55,
        height: size * 0.55,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: bg, width: 3),
        ),
      ),
    );
  }
}
