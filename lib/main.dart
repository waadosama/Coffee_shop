import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/network/dio_client.dart';
import 'core/theme/app_theme.dart';
import 'features/cart/presentation/cubic/cubic.dart';
import 'features/menu/data/datasources/remote.dart';
import 'features/menu/data/repositories/coffe_imp.dart';
import 'features/menu/domain/usecases/use.dart';
import 'features/menu/presentation/cubic/cubic.dart';
import 'features/menu/presentation/pages/intro_page.dart';

void main() {
  runApp(const RwaqApp());
}

class RwaqApp extends StatelessWidget {
  const RwaqApp({super.key});

  @override
  Widget build(BuildContext context) {
    // The cart lives above the Navigator so every page shares one instance.
    return BlocProvider(
      create: (_) => CartCubit(),
      child: MaterialApp(
        title: 'ركن Specialty Coffee',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: BlocProvider(
          create: (_) {
            final dio = DioClient().dio;
            final remote = CoffeeRemoteDataSourceImpl(dio);
            final repo = CoffeeRepositoryImpl(remote);
            return CoffeeCubit(GetHotCoffee(repo))..fetchHotCoffee();
          },
          child: const IntroPage(),
        ),
      ),
    );
  }
}
