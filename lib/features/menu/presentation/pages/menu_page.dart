import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubic/cubic.dart';
import '../widgets/menu_shell.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MenuShell(
      header: const MenuHeader(
        title: 'ركن القهوه',
        subtitle: ' specialty drinks',
      ),
      sectionTitle: 'المنيو',
      activeTab: 0,
      onRetry: () => context.read<CoffeeCubit>().fetchHotCoffee(),
    );
  }
}
