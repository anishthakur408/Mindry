import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/constants.dart';
import '../utils/responsive_helper.dart';
import '../services/preferences_service.dart';
import 'onboarding_screen.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _shimmerController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();

    // Fade animation
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    // Scale animation for the logo
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    // Shimmer animation
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();
    _shimmerAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.linear),
    );

    // Start animations
    _fadeController.forward();
    _scaleController.forward();

    // Navigate after delay
    Future.delayed(const Duration(milliseconds: 2800), () {
      _navigateNext();
    });
  }

  void _navigateNext() {
    final isFirstLaunch = PreferencesService.isFirstLaunch;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            isFirstLaunch ? const OnboardingScreen() : const HomeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 800),
      ),
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Responsive sizes
    final logoSize = ResponsiveHelper.getResponsiveValue<double>(
      context,
      mobile: 120,
      tablet: 150,
      desktop: 180,
    );
    final emojiSize = ResponsiveHelper.getResponsiveValue<double>(
      context,
      mobile: 56,
      tablet: 70,
      desktop: 84,
    );
    final titleSize = ResponsiveHelper.getResponsiveFontSize(context, 56);
    final taglineSize = ResponsiveHelper.getResponsiveFontSize(context, 16);
    final brandingSize = ResponsiveHelper.getResponsiveFontSize(context, 20);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.backgroundColor,
              AppColors.paperMedium,
              AppColors.paperLight,
            ],
          ),
        ),
        child: Stack(
          children: [
            // Watercolor blobs background
            _buildWatercolorBackground(),

            // Main content - centered with max width
            Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: ResponsiveHelper.getMaxContentWidth(context),
                ),
                child: AnimatedBuilder(
                  animation: Listenable.merge(
                      [_fadeAnimation, _scaleAnimation, _shimmerAnimation]),
                  builder: (context, child) {
                    return FadeTransition(
                      opacity: _fadeAnimation,
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // App Icon/Logo area
                            Container(
                              width: logoSize,
                              height: logoSize,
                              decoration: BoxDecoration(
                                color: AppColors.watercolorYellow,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.sketchBorder,
                                  width: 3,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.cardShadow,
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  '📔',
                                  style: TextStyle(fontSize: emojiSize),
                                ),
                              ),
                            ),

                            SizedBox(
                                height: ResponsiveHelper.getResponsiveValue(
                              context,
                              mobile: 32.0,
                              tablet: 40.0,
                              desktop: 48.0,
                            )),

                            // App Name with shimmer effect
                            ShaderMask(
                              shaderCallback: (bounds) {
                                return LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: const [
                                    AppColors.inkDark,
                                    AppColors.sketchLight,
                                    AppColors.inkDark,
                                  ],
                                  stops: [
                                    _shimmerAnimation.value - 0.3,
                                    _shimmerAnimation.value,
                                    _shimmerAnimation.value + 0.3,
                                  ],
                                ).createShader(bounds);
                              },
                              child: Text(
                                'Mindry',
                                style: GoogleFonts.indieFlower(
                                  fontSize: titleSize,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 2,
                                ),
                              ),
                            ),

                            const SizedBox(height: 8),

                            // Tagline
                            Text(
                              'Your Personal Journal',
                              style: GoogleFonts.inter(
                                fontSize: taglineSize,
                                color: AppColors.textSecondary,
                                fontStyle: FontStyle.italic,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Bottom branding
            Positioned(
              bottom: ResponsiveHelper.getResponsiveValue<double>(
                context,
                mobile: 48,
                tablet: 64,
                desktop: 80,
              ),
              left: 0,
              right: 0,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: [
                    Text(
                      'by',
                      style: GoogleFonts.inter(
                        fontSize:
                            ResponsiveHelper.getResponsiveFontSize(context, 12),
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Plorix Studio',
                      style: GoogleFonts.indieFlower(
                        fontSize: brandingSize,
                        fontWeight: FontWeight.bold,
                        color: AppColors.inkMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWatercolorBackground() {
    return AnimatedBuilder(
      animation: _shimmerAnimation,
      builder: (context, child) {
        return Stack(
          children: [
            // Top right blob
            Positioned(
              top: -50,
              right: -30,
              child: Opacity(
                opacity: 0.4,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.watercolorPink,
                        AppColors.watercolorPink.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Bottom left blob
            Positioned(
              bottom: 100,
              left: -60,
              child: Opacity(
                opacity: 0.35,
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.watercolorBlue,
                        AppColors.watercolorBlue.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Center accent
            Positioned(
              top: MediaQuery.of(context).size.height * 0.3,
              right: 50,
              child: Opacity(
                opacity: 0.3,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.watercolorYellow,
                        AppColors.watercolorYellow.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
