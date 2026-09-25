import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../cubic/cubic.dart';
import '../cubic/state.dart';
import '../widgets/kavea_posters.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkEspresso,
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.creamPaper,
            borderRadius: BorderRadius.circular(16),
          ),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 66, 31, 5),
                              shape: BoxShape.circle,
                            ),
                            child: ClipOval(
                              child: Image(
                                image: AssetImage('assets/images/coffee-beans.png'),
                                width: 44,
                                height: 44,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'ركن القهوه',
                                  style: GoogleFonts.cairo(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w800,
                                    height: 1.1,
                                    color: AppColors.darkEspresso,
                                  ),
                                ),
                                Text(
                                  ' specialty drinks',
                                  style: GoogleFonts.caveat(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.coffeeLight,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                  child: Center(
                    child: Text(
                      'المنيو',
                      textDirection: TextDirection.rtl,
                      style: GoogleFonts.specialElite(
                        fontSize: 18,
                        letterSpacing: 2.5,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkEspresso,
                      ),
                    ),
                  ),
                ),
              ),
              BlocBuilder<CoffeeCubit, CoffeeState>(
                builder: (context, state) {
                  if (state is CoffeeLoading || state is CoffeeInitial) {
                    return const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 48),
                        child: EnergyMachinePoster(),
                      ),
                    );
                  }

                  if (state is CoffeeError) {
                    return SliverFillRemaining(
                      hasScrollBody: false,
                      child: Padding(
                        padding: const EdgeInsets.all(28),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'coffee machine pause.',
                              style: GoogleFonts.caveat(
                                fontSize: 32,
                                color: const Color.fromARGB(255, 233, 186, 169),
                              ),
                            ),
                            const SizedBox(height: 8),

                            Text(
                              state.message,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.cairo(
                                fontSize: 13,
                                color: const Color.fromARGB(255, 79, 41, 22),
                              ),
                            ),

                            const SizedBox(height: 16),

                            TextButton(
                              onPressed: () =>
                                  context.read<CoffeeCubit>().fetchHotCoffee(),
                              child: Text(
                                'TRY AGAIN',
                                style: GoogleFonts.specialElite(
                                  letterSpacing: 2,
                                  color: AppColors.darkEspresso,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final drinks = (state as CoffeeSuccess).coffee;

                  return SliverPadding(
                    padding: const EdgeInsets.fromLTRB(45, 0, 45, 20),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 1.0,
                          ),
                      delegate: SliverChildBuilderDelegate((context, index) {
                        return DrinkPosterCard(
                          coffee: drinks[index],
                        );
                      }, childCount: drinks.length),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
