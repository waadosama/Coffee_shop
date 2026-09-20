import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(const ProviderScope(child: RwaqApp()));
}

class RwaqApp extends StatelessWidget {
  const RwaqApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ركن Specialty Coffee',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const MenuPage(),
    );
  }
}
