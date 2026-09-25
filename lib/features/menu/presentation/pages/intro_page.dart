import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../widgets/intro_widgets.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeScale;
  late Animation<double> _brandFade;
  late Animation<double> _buttonsFade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _fadeScale = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );

    _brandFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.7, curve: Curves.easeOutCubic),
      ),
    );

    _buttonsFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOutBack),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkEspresso,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          color: AppColors.darkEspresso,
          child: Column(
            children: [
              // Push content toward center
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Centered photo
                    IntroHeroSection(animation: _fadeScale),
                    const SizedBox(height: 16),
                    // Brand text
                    IntroBrandSection(animation: _brandFade),
                  ],
                ),
              ),
              // Buttons pinned to bottom
              IntroNavigationButtons(animation: _buttonsFade),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
