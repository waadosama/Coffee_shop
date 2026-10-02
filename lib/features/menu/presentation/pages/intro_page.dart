import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../widgets/intro_painters.dart';
import '../widgets/intro_widgets.dart';

/// Intro screen: a roastery label resting on a calm rust backdrop.
///
/// The label (paper card + wax seal + arched hero window) settles into place
/// with a short press-print entrance, over a plain rust-to-espresso wash with
/// a soft glow behind the label — painted once and never moving. The pointer
/// nudges the whole label for a soft parallax, and the two buttons at the
/// bottom are unchanged.
class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _cardScale;
  late final Animation<double> _cardFade;
  late final Animation<double> _heroIn;
  late final Animation<double> _sealIn;
  late final Animation<double> _brandFade;
  late final Animation<double> _buttonsFade;

  /// Normalised pointer position (-0.5..0.5) driving the soft parallax.
  final ValueNotifier<Offset> _pointer = ValueNotifier(Offset.zero);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // The paper drops in first, the seal is stamped over it, then the copy
    // and finally the buttons.
    _cardScale = Tween<double>(begin: 0.93, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.55, curve: Curves.easeOutBack),
      ),
    );

    _cardFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.3, curve: Curves.easeOutCubic),
    );

    _heroIn = Tween<double>(begin: 0.86, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.1, 0.6, curve: Curves.easeOutCubic),
      ),
    );

    _sealIn = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.3, 0.75, curve: Curves.easeOutBack),
    );

    _brandFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.4, 0.9, curve: Curves.easeOutCubic),
    );

    _buttonsFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.6, 1.0, curve: Curves.easeOutCubic),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _pointer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: AppColors.darkEspresso,
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Calm rust backdrop — painted once onto the canvas.
            const CustomPaint(painter: IntroBackgroundPainter()),
            // Foreground content, nudged gently toward the pointer.
            MouseRegion(
              onHover: (event) {
                if (size.width == 0 || size.height == 0) return;
                _pointer.value = Offset(
                  (event.localPosition.dx / size.width - 0.5).clamp(-0.5, 0.5),
                  (event.localPosition.dy / size.height - 0.5).clamp(-0.5, 0.5),
                );
              },
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    // Push content toward center
                    Expanded(
                      child: Center(
                        // Scales the label down only on very short screens so
                        // nothing overflows; identical on normal phones.
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 360),
                            child: ValueListenableBuilder<Offset>(
                              valueListenable: _pointer,
                              builder: (context, pointer, child) =>
                                  Transform.translate(
                                    offset: Offset(
                                      pointer.dx * 14,
                                      pointer.dy * 8,
                                    ),
                                    child: child,
                                  ),
                              child: _buildLabel(),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Buttons pinned to bottom
                    IntroNavigationButtons(animation: _buttonsFade),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// The paper label: dashed frame, arched hero window, brand copy and the
  /// wax seal biting into the top edge.
  Widget _buildLabel() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _cardFade.value.clamp(0.0, 1.0),
          child: Transform.scale(
            scale: _cardScale.value,
            // A degree of tilt keeps the card feeling like it was stamped by
            // hand rather than laid out by a grid.
            child: Transform.rotate(angle: -0.014, child: child),
          ),
        );
      },
      // The seal hangs 44px above the card, so the padding keeps that strip
      // inside the layout and short screens scale the whole block instead of
      // clipping the stamp off the top.
      child: Padding(
        padding: const EdgeInsets.only(top: 44),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 312,
              decoration: BoxDecoration(
                color: AppColors.creamPaper,
                borderRadius: BorderRadius.circular(26),
                border: Border.all(
                  color: AppColors.darkEspresso.withValues(alpha: 0.4),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.darkInk.withValues(alpha: 0.45),
                    blurRadius: 30,
                    offset: const Offset(0, 16),
                  ),
                ],
              ),
              child: CustomPaint(
                foregroundPainter: IntroLabelFramePainter(),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 74, 24, 26),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IntroHeroSection(animation: _heroIn),
                      const SizedBox(height: 16),
                      IntroBrandSection(animation: _brandFade),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: -44,
              left: 0,
              right: 0,
              child: Center(child: IntroSealBadge(animation: _sealIn)),
            ),
          ],
        ),
      ),
    );
  }
}
