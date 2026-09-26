import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../cubic/cubic.dart';
import '../cubic/state.dart';
import '../pages/menu_navigator.dart';
import 'kavea_posters.dart';

/// Round logo + title block shared by every menu section.
/// Shows a back button whenever the route can be popped.
class MenuHeader extends StatelessWidget {
  const MenuHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.of(context).canPop();

    return Row(
      children: [
        if (canPop)
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(Icons.arrow_back, size: 22),
            color: AppColors.darkEspresso,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 34, minHeight: 34),
          ),
        if (canPop) const SizedBox(width: 6),
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
                title,
                style: GoogleFonts.cairo(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                  color: AppColors.darkEspresso,
                ),
              ),
              Text(
                subtitle,
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
    );
  }
}

/// Shared scaffold used by every menu section (hot / cold / breakfast):
/// cream sheet, section title, tab bar and the state-driven content.
class MenuShell extends StatelessWidget {
  const MenuShell({
    super.key,
    required this.header,
    required this.sectionTitle,
    required this.onRetry,
    required this.activeTab,
  });

  final Widget header;
  final String sectionTitle;
  final VoidCallback onRetry;
  final int activeTab;

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
                  child: header,
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
                  child: Center(
                    child: Text(
                      sectionTitle,
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
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                  child: MenuTabBar(activeIndex: activeTab),
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
                                color: const Color.fromARGB(
                                  255,
                                  233,
                                  186,
                                  169,
                                ),
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
                              onPressed: onRetry,
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
                        return DrinkPosterCard(coffee: drinks[index]);
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

/// Switches between the three menu sections.
class MenuTabBar extends StatelessWidget {
  const MenuTabBar({super.key, required this.activeIndex});

  /// 0 = hot drinks, 1 = cold drinks, 2 = breakfast.
  final int activeIndex;

  static const List<String> _labels = ['Hot', 'Cold', 'Breakfast'];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 0; i < _labels.length; i++) ...[
          if (i > 0) const SizedBox(width: 8),
          Expanded(child: _TabPill(
            label: _labels[i],
            selected: i == activeIndex,
            onTap: i == activeIndex
                ? null
                : () => _openSection(context, i),
          )),
        ],
      ],
    );
  }

  void _openSection(BuildContext context, int index) {
    switch (index) {
      case 0:
        openMenuPage(context, replace: true);
      case 1:
        openColdDrinksPage(context, replace: true);
      case 2:
        openBreakfastPage(context, replace: true);
    }
  }
}

class _TabPill extends StatelessWidget {
  const _TabPill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? AppColors.darkEspresso
          : AppColors.darkEspresso.withValues(alpha: 0.04),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          height: 34,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.darkEspresso.withValues(alpha: 0.35),
              width: 1,
            ),
          ),
          child: Text(
            label,
            style: GoogleFonts.specialElite(
              fontSize: 12,
              letterSpacing: 1.6,
              color: selected
                  ? AppColors.creamPaper
                  : AppColors.darkEspresso,
            ),
          ),
        ),
      ),
    );
  }
}
