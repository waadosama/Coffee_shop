import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubic/cubic.dart';
import '../widgets/menu_shell.dart';

class BreakfastPage extends StatelessWidget {
  const BreakfastPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MenuShell(
      header: const MenuHeader(title: 'الفطور', subtitle: ' breakfast meal'),
      sectionTitle: 'الفطور',
      activeTab: 2,
      onRetry: () => context.read<CoffeeCubit>().fetchBreakfast(),
    );
  }
}
