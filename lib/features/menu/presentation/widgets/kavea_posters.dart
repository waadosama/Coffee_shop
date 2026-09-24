import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/coffe.dart';
import 'kavea_painters.dart';


class EnergyMachinePoster extends StatelessWidget {
  const EnergyMachinePoster({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.powderBlue,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.fromLTRB(12, 16, 12, 14),
        child: Column(
          children: [
            const Expanded(
              child: CustomPaint(
                painter: EspressoMachinePainter(color: AppColors.darkEspresso),
                child: SizedBox.expand(),
              ),
            ),
            Text(
              'ENERGY LOADING...',
              style: GoogleFonts.caveat(
                color: AppColors.darkEspresso,
                fontSize: 26,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class DrinkPosterCard extends StatelessWidget {
  const DrinkPosterCard({
    super.key,
    required this.coffee,
    required this.index,
  });

  final Coffee coffee;
  final int index;

  @override
  Widget build(BuildContext context) {
    final isEven = index.isEven;

    final cardBg = isEven
        ? const Color.fromARGB(255, 118, 77, 44)
        : const Color.fromARGB(255, 163, 121, 107);

    const borderAccent = Color.fromARGB(255, 108, 76, 64);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.creamPaper,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: borderAccent,
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: AppColors.darkEspresso,
            offset: Offset(2, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(7),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image
            Expanded(
              flex: 5,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    coffee.image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return ColoredBox(
                        color: cardBg,
                        child: const Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CustomPaint(
                              painter: EspressoMachinePainter(
                                color: AppColors.darkEspresso,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            const Color.fromARGB(
                              255,
                              172,
                              69,
                              28,
                            ).withValues(alpha: 0.2),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Text
            Expanded(
              flex: 2,
              child: Container(
                color: cardBg,
                padding: const EdgeInsets.symmetric(
                  horizontal: 5,
                  vertical: 4,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
  Center(
    child: Text(
      coffee.name.toUpperCase(),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
      style: GoogleFonts.specialElite(
        color: AppColors.darkEspresso,
        fontSize: 20,
        height: 1,
        letterSpacing: 0.2,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),

  const Spacer(),

  const SizedBox(height: 2),
],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}