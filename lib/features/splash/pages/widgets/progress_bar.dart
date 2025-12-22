import 'package:flutter/material.dart';

/// Animated progress bar widget showing loading progress
/// Features a cyan fill over a gray background
class ProgressBar extends StatelessWidget {
  final Animation<double> animation;

  const ProgressBar({super.key, required this.animation});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Column(
          children: [
            // Main progress bar
            Container(
              height: 6,
              decoration: BoxDecoration(
                color: const Color(0xFF263247), // Dark gray background
                borderRadius: BorderRadius.circular(3),
              ),
              child: Stack(
                children: [
                  // Filled portion (animated)
                  Container(
                    height: 6,
                    width:
                        (MediaQuery.of(context).size.width - 80) *
                        animation.value,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF00BCD4), // Cyan
                          const Color(0xFF00ACC1), // Slightly darker cyan
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(3),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF00BCD4).withOpacity(0.5),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Secondary progress indicator (subtle, always visible)
            Container(
              height: 3,
              margin: const EdgeInsets.symmetric(horizontal: 0),
              decoration: BoxDecoration(
                color: const Color(0xFF263247),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        );
      },
    );
  }
}
