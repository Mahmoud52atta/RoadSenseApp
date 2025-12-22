import 'package:flutter/material.dart';
import 'package:road_sense_app/features/auth/auth_features.dart';
import 'package:road_sense_app/features/home/home_feature.dart';
import 'viewmodels/splash_view_model.dart';
import 'widgets/animated_circles.dart';
import 'widgets/car_icon.dart';
import 'widgets/progress_bar.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with TickerProviderStateMixin {
  late SplashViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = SplashViewModel(vsync: this);
    // When splash progress completes, navigate to Sign In screen
    _viewModel.onComplete = () {
      // Use addPostFrameCallback to ensure navigation happens after build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        HomeFeature.to.go();
      });
    };
    _viewModel.startAnimations();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E27), // Dark navy background
      body: SafeArea(
        child: Stack(
          children: [
            // Main content centered
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated circles with car icon
                  SizedBox(
                    height: 300,
                    width: 300,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Animated pulsing circles
                        AnimatedCircles(animation: _viewModel.circleAnimation),
                        // Car icon in center
                        CarIcon(animation: _viewModel.carScaleAnimation),
                      ],
                    ),
                  ),
                  const SizedBox(height: 60),
                  // Title
                  Text(
                    'ADAS Speed Bump\nDetection',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Subtitle
                  Text(
                    'Advanced Driver Assistance System',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF00BCD4), // Cyan color
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            // Progress bar at bottom
            Positioned(
              bottom: 40,
              left: 40,
              right: 40,
              child: ProgressBar(animation: _viewModel.progressAnimation),
            ),
          ],
        ),
      ),
    );
  }
}
