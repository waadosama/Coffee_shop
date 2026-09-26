import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../pages/menu_navigator.dart';

// Large hero image — centered, no decorative frame
class IntroHeroSection extends StatelessWidget {
  final Animation<double> animation;

  const IntroHeroSection({
    super.key,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.scale(
          scale: animation.value,
          child: child,
        );
      },
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColors.darkEspresso,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: const Image(
            image: AssetImage('assets/images/coffee-bag.png'),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

// Brand name, subtitle and tagline
class IntroBrandSection extends StatelessWidget {
  final Animation<double> animation;

  const IntroBrandSection({
    super.key,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Opacity(
          opacity: animation.value.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - animation.value)),
            child: child,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            Text(
              'ركن القهوة',
              style: GoogleFonts.caveat(
                fontSize: 36,
                fontWeight: FontWeight.w700,
                color: AppColors.pastelPink,
                height: 1.1,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              'Specialty Coffee House',
              style: GoogleFonts.specialElite(
                fontSize: 13,
                color: AppColors.powderBlue.withValues(alpha: 0.8),
                letterSpacing: 3,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Every cup tells a story',
              style: GoogleFonts.cairo(
                fontSize: 12,
                color: AppColors.coffeeLight.withValues(alpha: 0.7),
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Navigation buttons: Explore Menu and Our Story
class IntroNavigationButtons extends StatelessWidget {
  final Animation<double> animation;

  const IntroNavigationButtons({
    super.key,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Opacity(
          opacity: animation.value.clamp(0.0, 1.0),
          child: child,
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Primary CTA button
            SizedBox(
              width: 220,
              height: 44,
              child: ElevatedButton(
                onPressed: () => _navigateToMenu(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.pastelPink,
                  foregroundColor: AppColors.darkEspresso,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: AppColors.pastelPink.withValues(alpha: 0.6),
                      width: 1.5,
                    ),
                  ),
                  elevation: 6,
                  shadowColor: AppColors.pastelPink.withValues(alpha: 0.3),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'المنيو',
                      style: GoogleFonts.specialElite(
                        fontSize: 14,
                        letterSpacing: 2,
                        color: AppColors.darkEspresso,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.arrow_forward,
                      size: 16,
                      color: AppColors.darkEspresso,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Secondary button
            SizedBox(
              width: 220,
              height: 40,
              child: OutlinedButton(
                onPressed: () => _navigateToMenu(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.powderBlue,
                  side: BorderSide(
                    color: AppColors.powderBlue.withValues(alpha: 0.4),
                    width: 1.2,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  elevation: 0,
                ),
                child: Text(
                  'Our Story',
                  style: GoogleFonts.specialElite(
                    fontSize: 12,
                    letterSpacing: 2,
                    color: AppColors.powderBlue,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToMenu(BuildContext context) {
    openMenuPage(context);
  }
}
