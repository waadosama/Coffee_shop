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
  });

  final Coffee coffee;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: AppColors.darkEspresso.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image section
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
                      color: AppColors.leather,
                      child: const Center(
                        child: SizedBox(
                          width: 30,
                          height: 30,
                          child: CustomPaint(
                            painter: EspressoMachinePainter(
                              color: AppColors.creamPaper,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                // Subtle gradient overlay
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          AppColors.darkEspresso.withValues(alpha: 0.5),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Name section
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            color: AppColors.creamPaper,
            child: Text(
              coffee.name.toUpperCase(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: GoogleFonts.cairo(
                color: AppColors.darkEspresso,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                height: 1.1,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}