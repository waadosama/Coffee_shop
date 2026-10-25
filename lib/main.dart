import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/network/dio_client.dart';
import 'core/notifications/fcm_service.dart';
import 'core/theme/app_theme.dart';
import 'features/cart/data/datasources/order_remote.dart';
import 'features/cart/data/repositories/order_repository_impl.dart';
import 'features/cart/presentation/cubic/cubic.dart';
import 'features/menu/data/datasources/remote.dart';
import 'features/menu/data/repositories/coffe_imp.dart';
import 'features/menu/domain/usecases/use.dart';
import 'features/menu/presentation/cubic/cubic.dart';
import 'features/menu/presentation/pages/intro_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // FCM must be up before the first frame so this device's token exists by
  // the time the first order is placed. Pushes are a nice-to-have, so a
  // failure here is logged instead of blocking the whole app.
  try {
    await FcmService.init();
  } catch (error, stackTrace) {
    debugPrint('FCM failed to start: $error\n$stackTrace');
  }

  runApp(const RwaqApp());
}

class RwaqApp extends StatelessWidget {
  const RwaqApp({super.key});

  @override
  Widget build(BuildContext context) {
    // The cart lives above the Navigator so every page shares one instance.
    return BlocProvider(
      create: (_) => CartCubit(
        orders: OrderRepositoryImpl(OrderRemoteDataSourceImpl()),
      ),
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
