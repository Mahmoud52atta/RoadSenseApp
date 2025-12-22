import 'package:flutter/material.dart';

/// ViewModel for managing splash screen animations
/// Handles lifecycle and control of all animation controllers
class SplashViewModel {
  late AnimationController _circleController;
  late AnimationController _carScaleController;
  late AnimationController _progressController;

  late Animation<double> _circleAnimation;
  late Animation<double> _carScaleAnimation;
  late Animation<double> _progressAnimation;

  final TickerProvider vsync;

  /// Optional callback invoked when the progress animation completes.
  VoidCallback? onComplete;

  SplashViewModel({required this.vsync});

  /// Animation for the pulsing circles (0 to 1, repeats)
  Animation<double> get circleAnimation => _circleAnimation;

  /// Animation for the car icon scale (0 to 1, repeats)
  Animation<double> get carScaleAnimation => _carScaleAnimation;

  /// Animation for the progress bar fill (0 to 1, one-time)
  Animation<double> get progressAnimation => _progressAnimation;

  /// Initialize and start all animations
  void startAnimations() {
    _setupCircleAnimation();
    _setupCarScaleAnimation();
    _setupProgressAnimation();
  }

  /// Setup the circle pulsing animation
  /// Scales circles from 0.8x to 1.2x in a continuous loop
  void _setupCircleAnimation() {
    _circleController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: vsync,
    );

    _circleAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _circleController, curve: Curves.easeInOut),
    );

    // Loop the animation
    _circleController.repeat(reverse: true);
  }

  /// Setup the car icon scale animation
  /// Creates a subtle pulse effect (0.95x to 1.05x)
  void _setupCarScaleAnimation() {
    _carScaleController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: vsync,
    );

    _carScaleAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _carScaleController, curve: Curves.easeInOut),
    );

    // Loop the animation
    _carScaleController.repeat(reverse: true);
  }

  /// Setup the progress bar animation
  /// Fills from 0 to 1 over 3 seconds
  void _setupProgressAnimation() {
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: vsync,
    );

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
    );

    // Start the progress animation and call onComplete when finished
    _progressController.forward().then((_) {
      if (onComplete != null) {
        onComplete!();
      }
    });
  }

  /// Dispose of all animation controllers
  void dispose() {
    _circleController.dispose();
    _carScaleController.dispose();
    _progressController.dispose();
  }
}
