import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

/// SplashScreen is the first screen displayed when the Fade & Blade app starts.
/// It shows a gradient background (black to gold) and a Lottie animation of the logo.
/// After 3 seconds, it navigates to the onboarding flow.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to the next screen after a short delay.
    Future.delayed(const Duration(seconds: 3), () {
      context.go('/onboarding');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Black-to-gold gradient background for the Fade & Blade theme.
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black,     // Start with black
              Color(0xFFF8C737),// Fade into gold
              Color(0xFFFFC107),// Fade into gold
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          // Display a Lottie animation with fallback to a static image.
          child: Lottie.asset(
            'assets/animations/fade_and_blade_logo.json',
            width: 40.w,  // 40% of screen width, thanks to flutter_sizer
            height: 40.w,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(
                'assets/icons/splash_logo.png',
                width: 100.w,
                height: 100.w,
                fit: BoxFit.contain,
              );
            },
          ),
        ),
      ),
    );
  }
}
