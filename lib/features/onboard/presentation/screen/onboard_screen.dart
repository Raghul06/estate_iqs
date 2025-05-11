import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

/// Model to hold onboarding page data: image path, title, and description.
class OnboardingPageData {
  final String imagePath;
  final String title;
  final String description;

  OnboardingPageData({
    required this.imagePath,
    required this.title,
    required this.description,
  });
}

/// OnboardingScreen uses a PageView to display multiple pages describing
/// Fade & Blade's core functionalities, referencing the provided UI style.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  /// Sample data for 3 onboarding screens. Adjust image paths and text as needed.
  final List<OnboardingPageData> _pages = [
    OnboardingPageData(
      imagePath: 'assets/icons/onboard_1.png',
      title: 'Welcome to Fade & Blade',
      description:
      'Book your next fresh cut with ease. Fade & Blade connects you with the best barbers in your area.',
    ),
    OnboardingPageData(
      imagePath: 'assets/icons/onboard_2.png',
      title: 'Personalized Experience',
      description:
      'Discover talented barbers, explore their portfolios, and choose the perfect style for you.',
    ),
    OnboardingPageData(
      imagePath: 'assets/icons/onboard_3.png',
      title: 'Stay in Control',
      description:
      'Manage appointments, get real-time updates, and make secure payments—all in one place.',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// Navigates to the next page, or finishes onboarding on the last page.
  void _onNextPressed() {
    if (_currentPage == _pages.length - 1) {
      // Navigate to the login screen (or wherever your flow continues).
      context.go('/login');
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  /// Skips the onboarding and navigates directly to the login (or home) screen.
  void _onSkipPressed() {
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // No dedicated AppBar; we manually place a "Skip" button.
      body: SafeArea(
        child: Stack(
          children: [
            // PageView displaying each onboarding page.
            PageView.builder(
              controller: _pageController,
              itemCount: _pages.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                return _buildPage(_pages[index]);
              },
            ),
            // "Skip" button at the top-right (no dedicated AppBar).
            Positioned(
              top: 2.h,
              right: 5.w,
              child: GestureDetector(
                onTap: _onSkipPressed,
                child: Text(
                  'Skip',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 14.sp,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ),
            // Bottom area: Dots indicator + "Next" button.
            Positioned(
              bottom: 3.h,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  _buildDotsIndicator(),
                  SizedBox(height: 2.h),
                  _buildNextButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a single onboarding page based on the OnboardingPageData.
  Widget _buildPage(OnboardingPageData data) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Onboarding image.
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              data.imagePath,
              width: 80.w,
              height: 40.h,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 4.h),
          // Title text.
          Text(
            data.title,
            style: TextStyle(
              fontFamily: 'PlayfairDisplay',
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF4A3F35),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 2.h),
          // Description text.
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Text(
              data.description,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14.sp,
                color: Colors.grey[700],
                height: 1.3,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the dots indicator to show the current page.
  Widget _buildDotsIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_pages.length, (index) {
        final isActive = index == _currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: 1.w),
          width: isActive ? 4.w : 2.w,
          height: isActive ? 4.w : 2.w,
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF4A3F35) : Colors.grey[400],
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }

  /// Builds the "Next" (or "Get Started") button at the bottom.
  Widget _buildNextButton() {
    final isLastPage = _currentPage == _pages.length - 1;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: ElevatedButton(
        onPressed: _onNextPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4A3F35),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.symmetric(vertical: 2.h),
        ),
        child: Text(
          isLastPage ? 'Get Started' : 'Next',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600,
            fontSize: 14.sp,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
