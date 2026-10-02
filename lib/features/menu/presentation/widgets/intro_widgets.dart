import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../pages/menu_navigator.dart';
import 'intro_painters.dart';

// Large hero image — a coffee sack seen through an arched "roastery window"
// cut into the label. It floats gently, hovers brighten it and taps stamp a
// soft ink ripple.
class IntroHeroSection extends StatefulWidget {
  final Animation<double> animation;

  const IntroHeroSection({super.key, required this.animation});

  @override
  State<IntroHeroSection> createState() => _IntroHeroSectionState();
}

class _IntroHeroSectionState extends State<IntroHeroSection>
    with TickerProviderStateMixin {
  /// Idle loop behind the float.
  late final AnimationController _ambient;

  /// One-shot stamp played when the window is tapped.
  late final AnimationController _tap;

  bool _hovered = false;

  /// Window [animation] travels 0.86 → 1; the visible window starts there.
  static const double _fadeStart = 0.86;

  @override
  void initState() {
    super.initState();
    _ambient = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5200),
    )..repeat();
    _tap = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 560),
    );
  }

  @override
  void dispose() {
    _ambient.dispose();
    _tap.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => _tap.forward(from: 0),
        child: AnimatedBuilder(
          animation: Listenable.merge([widget.animation, _ambient, _tap]),
          builder: (context, child) {
            final entrance = widget.animation.value;
            final float = math.sin(_ambient.value * math.pi * 2) * 4;
            final pop = 1 + 0.06 * math.sin(math.pi * _tap.value);
            final fade = ((entrance - _fadeStart) / (1 - _fadeStart)).clamp(
              0.0,
              1.0,
            );
            final scale = entrance * pop * (_hovered ? 1.03 : 1.0);

            return Opacity(
              opacity: fade,
              child: Transform.translate(
                offset: Offset(0, float),
                child: Transform.scale(
                  scale: scale,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      child!,
                      // Expanding stamp confirming the tap.
                      if (_tap.isAnimating)
                        Opacity(
                          opacity: (1 - _tap.value) * 0.7,
                          child: Transform.scale(
                            scale: 1 + 0.24 * _tap.value,
                            child: CustomPaint(
                              size: const Size(174, 192),
                              painter: IntroLabelFramePainter(
                                color: AppColors.kaveaOrangeDeep,
                                inset: 0,
                                radius: 86,
                                bottomRadius: 16,
                                strokeWidth: 2,
                                dash: 7,
                                gap: 6,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
          child: _buildWindow(),
        ),
      ),
    );
  }

  /// The arched window itself: rust mat, gold hairline, sack artwork.
  Widget _buildWindow() {
    const arch = BorderRadius.vertical(
      top: Radius.circular(86),
      bottom: Radius.circular(16),
    );

    return Container(
      width: 174,
      height: 192,
      decoration: BoxDecoration(
        color: AppColors.darkInk,
        borderRadius: arch,
        border: Border.all(color: AppColors.kaveaOrangeDeep, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkInk.withValues(alpha: 0.32),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: arch,
        child: ColoredBox(
          color: AppColors.darkEspresso,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 20, 14, 12),
            child: const Image(
              image: AssetImage('assets/images/coffee-bag.png'),
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}

// Wax seal stamped over the top edge of the label: gold disc, spinning
// perforation ring, curved stamp copy and a coffee icon.
class IntroSealBadge extends StatefulWidget {
  final Animation<double> animation;

  const IntroSealBadge({super.key, required this.animation});

  @override
  State<IntroSealBadge> createState() => _IntroSealBadgeState();
}

class _IntroSealBadgeState extends State<IntroSealBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _spin;

  @override
  void initState() {
    super.initState();
    _spin = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 14000),
    )..repeat();
  }

  @override
  void dispose() {
    _spin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([widget.animation, _spin]),
      builder: (context, _) {
        final t = widget.animation.value;
        return Opacity(
          opacity: t.clamp(0.0, 1.0),
          child: Transform.scale(
            scale: t.clamp(0.0, 1.12),
            child: SizedBox(
              width: 92,
              height: 92,
              child: CustomPaint(
                painter: IntroSealPainter(
                  progress: _spin.value,
                  topText: 'FRESHLY ROASTED',
                  bottomText: 'SPECIALTY COFFEE',
                  textStyle: GoogleFonts.specialElite(
                    fontSize: 7.5,
                    letterSpacing: 0.7,
                    color: AppColors.darkEspresso,
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.coffee,
                    size: 26,
                    color: AppColors.darkEspresso,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// Brand name, ornament, subtitle and tagline — each line reveals in a
// staggered cascade so the block reads like a printed label.
class IntroBrandSection extends StatelessWidget {
  final Animation<double> animation;

  const IntroBrandSection({super.key, required this.animation});

  /// Maps [value] onto the 0..1 window where a given line appears.
  static double _window(double start, double end, double value) {
    return ((value - start) / (end - start)).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        final value = animation.value.clamp(0.0, 1.0);
        final title = Curves.easeOutCubic.transform(_window(0.0, 0.5, value));
        final rule = Curves.easeOutCubic.transform(_window(0.2, 0.7, value));
        final subtitle = Curves.easeOutCubic.transform(
          _window(0.35, 0.85, value),
        );
        final tagline = Curves.easeOutCubic.transform(_window(0.5, 1.0, value));

        return Column(
          children: [
            Opacity(
              opacity: title,
              child: Transform.translate(
                offset: Offset(0, 20 * (1 - title)),
                child: Text(
                  'ركن القهوة',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cairo(
                    fontSize: 38,
                    fontWeight: FontWeight.w900,
                    color: AppColors.darkEspresso,
                    height: 1.15,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            _ornament(rule),
            const SizedBox(height: 10),
            Opacity(
              opacity: subtitle,
              child: Transform.translate(
                offset: Offset(0, 12 * (1 - subtitle)),
                child: Text(
                  'Specialty Coffee House',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.specialElite(
                    fontSize: 12,
                    color: AppColors.darkEspresso.withValues(alpha: 0.7),
                    letterSpacing: 3,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Opacity(
              opacity: tagline,
              child: Transform.translate(
                offset: Offset(0, 10 * (1 - tagline)),
                child: Text(
                  'Every cup tells a story',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.caveat(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: AppColors.coffeeLight,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Golden rule with a cup mark in the middle; the wings sweep outward as
  /// [t] grows.
  Widget _ornament(double t) {
    Widget wing({required bool leading}) {
      return Transform.scale(
        scaleX: t,
        alignment: leading ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: 58,
          height: 1.4,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            gradient: LinearGradient(
              begin: leading ? Alignment.centerRight : Alignment.centerLeft,
              end: leading ? Alignment.centerLeft : Alignment.centerRight,
              colors: [
                AppColors.kaveaOrangeDeep.withValues(alpha: 0.95),
                AppColors.kaveaOrangeDeep.withValues(alpha: 0.0),
              ],
            ),
          ),
        ),
      );
    }

    return Opacity(
      opacity: t,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          wing(leading: true),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Transform.scale(
              scale: 0.6 + 0.4 * t,
              child: const Icon(
                Icons.coffee,
                size: 15,
                color: AppColors.darkEspresso,
              ),
            ),
          ),
          wing(leading: false),
        ],
      ),
    );
  }
}

// Navigation buttons: Explore Menu and Our Story — both wake up on hover
// (lift, glow, arrow slide) and press down under the finger.
class IntroNavigationButtons extends StatefulWidget {
  final Animation<double> animation;

  const IntroNavigationButtons({super.key, required this.animation});

  @override
  State<IntroNavigationButtons> createState() => _IntroNavigationButtonsState();
}

class _IntroNavigationButtonsState extends State<IntroNavigationButtons> {
  bool _primaryHovered = false;
  bool _primaryPressed = false;
  bool _secondaryHovered = false;
  bool _secondaryPressed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.animation,
      builder: (context, child) {
        final t = widget.animation.value.clamp(0.0, 1.0);
        return Opacity(
          opacity: t,
          child: Transform.translate(
            offset: Offset(0, 18 * (1 - Curves.easeOutCubic.transform(t))),
            child: child,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 340),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Primary CTA button
              _primaryButton(),
              const SizedBox(height: 10),

              // Secondary button
              _secondaryButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _primaryButton() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _primaryHovered = true),
      onExit: (_) => setState(() {
        _primaryHovered = false;
        _primaryPressed = false;
      }),
      child: Listener(
        onPointerDown: (_) => setState(() => _primaryPressed = true),
        onPointerUp: (_) => setState(() => _primaryPressed = false),
        onPointerCancel: (_) => setState(() => _primaryPressed = false),
        child: AnimatedScale(
          scale: _primaryPressed ? 0.96 : (_primaryHovered ? 1.03 : 1.0),
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.creamPaper, AppColors.pastelPink],
              ),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: AppColors.pastelPink.withValues(
                  alpha: _primaryHovered ? 0.95 : 0.5,
                ),
                width: 1.6,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.pastelPink.withValues(
                    alpha: _primaryHovered ? 0.5 : 0.24,
                  ),
                  blurRadius: _primaryHovered ? 28 : 12,
                  spreadRadius: _primaryHovered ? 1 : 0,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () => _navigateToMenu(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: AppColors.darkInk,
                shadowColor: Colors.transparent,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'المنيو',
                    style: GoogleFonts.specialElite(
                      fontSize: 15,
                      letterSpacing: 2,
                      color: AppColors.darkInk,
                    ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedSlide(
                    offset: _primaryHovered
                        ? const Offset(0.3, 0)
                        : Offset.zero,
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOutCubic,
                    child: const Icon(
                      Icons.arrow_forward,
                      size: 16,
                      color: AppColors.darkInk,
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

  Widget _secondaryButton() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _secondaryHovered = true),
      onExit: (_) => setState(() {
        _secondaryHovered = false;
        _secondaryPressed = false;
      }),
      child: Listener(
        onPointerDown: (_) => setState(() => _secondaryPressed = true),
        onPointerUp: (_) => setState(() => _secondaryPressed = false),
        onPointerCancel: (_) => setState(() => _secondaryPressed = false),
        child: AnimatedScale(
          scale: _secondaryPressed ? 0.97 : (_secondaryHovered ? 1.02 : 1.0),
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            width: double.infinity,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.powderBlue.withValues(
                alpha: _secondaryHovered ? 0.12 : 0.0,
              ),
              borderRadius: BorderRadius.circular(13),
              border: Border.all(
                color: AppColors.powderBlue.withValues(
                  alpha: _secondaryHovered ? 0.85 : 0.45,
                ),
                width: 1.2,
              ),
            ),
            child: OutlinedButton(
              onPressed: () => _navigateToMenu(context),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.powderBlue,
                side: BorderSide.none,
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Our Story',
                    style: GoogleFonts.specialElite(
                      fontSize: 12,
                      letterSpacing: 2,
                      color: AppColors.powderBlue,
                    ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedOpacity(
                    opacity: _secondaryHovered ? 1 : 0,
                    duration: const Duration(milliseconds: 220),
                    child: AnimatedSlide(
                      offset: _secondaryHovered
                          ? Offset.zero
                          : const Offset(-0.6, 0),
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOutCubic,
                      child: const Icon(
                        Icons.arrow_forward_ios,
                        size: 10,
                        color: AppColors.powderBlue,
                      ),
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

  void _navigateToMenu(BuildContext context) {
    openMenuPage(context);
  }
}
