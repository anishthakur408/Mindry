import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/constants.dart';
import '../utils/responsive_helper.dart';
import '../services/preferences_service.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  late AnimationController _floatController;
  late AnimationController _pulseController;
  late Animation<double> _floatAnimation;
  late Animation<double> _pulseAnimation;

  final List<OnboardingPageData> _pages = [
    OnboardingPageData(
      emoji: '📝',
      title: 'Capture Your Thoughts',
      description:
          'Write daily journal entries and express yourself freely. Your personal space to reflect and grow.',
      color: AppColors.watercolorPink,
    ),
    OnboardingPageData(
      emoji: '🌈',
      title: 'Track Your Mood',
      description:
          'Visualize your emotional patterns over time. Understand yourself better with beautiful insights.',
      color: AppColors.watercolorBlue,
    ),
    OnboardingPageData(
      emoji: '✅',
      title: 'Stay Organized',
      description:
          'Manage your tasks alongside your journal. Keep your goals and daily to-dos in one place.',
      color: AppColors.watercolorGreen,
    ),
  ];

  @override
  void initState() {
    super.initState();

    // Float animation for emoji
    _floatController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);
    _floatAnimation = Tween<double>(begin: -10, end: 10).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    // Pulse animation for accent circle
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _floatController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() => _currentPage = page);
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _completeOnboarding() async {
    await PreferencesService.setFirstLaunchComplete();
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const HomeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.1),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 600),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = ResponsiveHelper.getResponsiveValue<double>(
      context,
      mobile: 32,
      tablet: 48,
      desktop: 64,
    );

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.backgroundColor,
              AppColors.paperLight,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: ResponsiveHelper.getMaxContentWidth(context),
              ),
              child: Column(
                children: [
                  // Skip button
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: ResponsiveHelper.getResponsivePadding(context),
                      child: TextButton(
                        onPressed: _completeOnboarding,
                        child: Text(
                          'Skip',
                          style: GoogleFonts.inter(
                            fontSize: ResponsiveHelper.getResponsiveFontSize(
                                context, 16),
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Page content
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: _onPageChanged,
                      itemCount: _pages.length,
                      itemBuilder: (context, index) {
                        return _buildPage(_pages[index], index == _currentPage);
                      },
                    ),
                  ),

                  // Page indicator and button
                  Padding(
                    padding: EdgeInsets.all(bottomPadding),
                    child: Column(
                      children: [
                        // Page indicators
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            _pages.length,
                            (index) => _buildPageIndicator(index),
                          ),
                        ),

                        SizedBox(height: bottomPadding),

                        // Next/Get Started button
                        _buildActionButton(),
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

  Widget _buildPage(OnboardingPageData data, bool isActive) {
    // Responsive sizes
    final outerCircleSize = ResponsiveHelper.getResponsiveValue<double>(
      context,
      mobile: 180,
      tablet: 220,
      desktop: 260,
    );
    final innerCircleSize = ResponsiveHelper.getResponsiveValue<double>(
      context,
      mobile: 140,
      tablet: 170,
      desktop: 200,
    );
    final emojiSize = ResponsiveHelper.getResponsiveValue<double>(
      context,
      mobile: 64,
      tablet: 80,
      desktop: 96,
    );
    final titleSize = ResponsiveHelper.getResponsiveFontSize(context, 32);
    final descSize = ResponsiveHelper.getResponsiveFontSize(context, 16);
    final horizontalPadding = ResponsiveHelper.getResponsiveValue<double>(
      context,
      mobile: 40,
      tablet: 80,
      desktop: 120,
    );

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: isActive ? 1.0 : 0.5,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated emoji with background circle
            AnimatedBuilder(
              animation: Listenable.merge([_floatAnimation, _pulseAnimation]),
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _floatAnimation.value),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Pulsing background circle
                      Transform.scale(
                        scale: _pulseAnimation.value,
                        child: Container(
                          width: outerCircleSize,
                          height: outerCircleSize,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                data.color.withValues(alpha: 0.6),
                                data.color.withValues(alpha: 0.1),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Inner circle with border
                      Container(
                        width: innerCircleSize,
                        height: innerCircleSize,
                        decoration: BoxDecoration(
                          color: data.color.withValues(alpha: 0.3),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.sketchBorder,
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            data.emoji,
                            style: TextStyle(fontSize: emojiSize),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            SizedBox(
                height: ResponsiveHelper.getResponsiveValue<double>(
              context,
              mobile: 48,
              tablet: 56,
              desktop: 64,
            )),

            // Title with animation
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: isActive ? 1.0 : 0.0),
              duration: const Duration(milliseconds: 400),
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: Opacity(
                    opacity: value,
                    child: Text(
                      data.title,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.indieFlower(
                        fontSize: titleSize,
                        fontWeight: FontWeight.bold,
                        color: AppColors.inkDark,
                        height: 1.2,
                      ),
                    ),
                  ),
                );
              },
            ),

            SizedBox(
                height: ResponsiveHelper.getResponsiveValue<double>(
              context,
              mobile: 16,
              tablet: 20,
              desktop: 24,
            )),

            // Description with animation
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: isActive ? 1.0 : 0.0),
              duration: const Duration(milliseconds: 500),
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(0, 30 * (1 - value)),
                  child: Opacity(
                    opacity: value,
                    child: Text(
                      data.description,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: descSize,
                        color: AppColors.textSecondary,
                        height: 1.6,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageIndicator(int index) {
    final isActive = index == _currentPage;
    final indicatorHeight = ResponsiveHelper.getResponsiveValue<double>(
      context,
      mobile: 12,
      tablet: 14,
      desktop: 16,
    );

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.getResponsiveValue<double>(
          context,
          mobile: 6,
          tablet: 8,
          desktop: 10,
        ),
      ),
      width: isActive ? indicatorHeight * 2.5 : indicatorHeight,
      height: indicatorHeight,
      decoration: BoxDecoration(
        color: isActive ? _pages[_currentPage].color : AppColors.paperDark,
        borderRadius: BorderRadius.circular(indicatorHeight / 2),
        border: Border.all(
          color: AppColors.sketchBorder,
          width: isActive ? 2 : 1,
        ),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: _pages[_currentPage].color.withValues(alpha: 0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
    );
  }

  Widget _buildActionButton() {
    final isLastPage = _currentPage == _pages.length - 1;
    final buttonWidth = ResponsiveHelper.getResponsiveValue<double>(
      context,
      mobile: isLastPage ? 220 : 180,
      tablet: isLastPage ? 260 : 220,
      desktop: isLastPage ? 300 : 260,
    );
    final buttonHeight = ResponsiveHelper.getResponsiveValue<double>(
      context,
      mobile: 56,
      tablet: 64,
      desktop: 72,
    );
    final buttonFontSize = ResponsiveHelper.getResponsiveFontSize(context, 20);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: buttonWidth,
      height: buttonHeight,
      child: ElevatedButton(
        onPressed: _nextPage,
        style: ElevatedButton.styleFrom(
          backgroundColor: isLastPage
              ? AppColors.watercolorGreen
              : AppColors.watercolorYellow,
          foregroundColor: AppColors.inkDark,
          elevation: 4,
          shadowColor: AppColors.cardShadow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(
              color: AppColors.sketchBorder,
              width: 2,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isLastPage ? 'Get Started' : 'Next',
              style: GoogleFonts.indieFlower(
                fontSize: buttonFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            AnimatedRotation(
              turns: isLastPage ? 0 : 0,
              duration: const Duration(milliseconds: 300),
              child: Icon(
                isLastPage
                    ? Icons.rocket_launch_rounded
                    : Icons.arrow_forward_rounded,
                size: ResponsiveHelper.getResponsiveValue<double>(
                  context,
                  mobile: 22,
                  tablet: 26,
                  desktop: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingPageData {
  final String emoji;
  final String title;
  final String description;
  final Color color;

  OnboardingPageData({
    required this.emoji,
    required this.title,
    required this.description,
    required this.color,
  });
}
