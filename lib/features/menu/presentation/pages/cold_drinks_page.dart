import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubic/cubic.dart';
import '../widgets/menu_shell.dart';

class ColdDrinksPage extends StatelessWidget {
  const ColdDrinksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MenuShell(
      header: const MenuHeader(
        title: 'مشروبات بارده',
        subtitle: ' cold drinks',
      ),
      sectionTitle: 'مشروبات باردة',
      activeTab: 1,
      onRetry: () => context.read<CoffeeCubit>().fetchColdDrinks(),
    );
  }
}
