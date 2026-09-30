import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/dio_client.dart';
import '../../../cart/presentation/cubic/cubic.dart';
import '../../data/datasources/remote.dart';
import '../../data/repositories/coffe_imp.dart';
import '../../domain/entities/coffe.dart';
import '../../domain/usecases/use.dart';
import '../cubic/cubic.dart';
import 'breakfast_page.dart';
import 'cold_drinks_page.dart';
import 'menu_page.dart';
import 'product_details_page.dart';

/// Central place that builds a page together with the [CoffeeCubit]
/// it needs, so wiring stays identical for every menu section.
void _open(
  BuildContext context,
  Widget page,
  void Function(CoffeeCubit) fetch, {
  required bool replace,
}) {
  final route = MaterialPageRoute(
    builder: (_) => BlocProvider(
      create: (_) {
        final dio = DioClient().dio;
        final remote = CoffeeRemoteDataSourceImpl(dio);
        final repo = CoffeeRepositoryImpl(remote);
        final cubit = CoffeeCubit(GetHotCoffee(repo));
        fetch(cubit);
        return cubit;
      },
      child: page,
    ),
  );

  if (replace) {
    Navigator.pushReplacement(context, route);
  } else {
    Navigator.push(context, route);
  }
}

void openMenuPage(BuildContext context, {bool replace = false}) {
  _open(context, const MenuPage(), (cubit) => cubit.fetchHotCoffee(),
      replace: replace);
}

void openColdDrinksPage(BuildContext context, {bool replace = false}) {
  _open(context, const ColdDrinksPage(), (cubit) => cubit.fetchColdDrinks(),
      replace: replace);
}

void openBreakfastPage(BuildContext context, {bool replace = false}) {
  _open(context, const BreakfastPage(), (cubit) => cubit.fetchBreakfast(),
      replace: replace);
}

/// Opens the product details page for one drink: tasting note, price in EGP
/// and the add-to-cart action. The page only needs the drink itself, the
/// shared [CartCubit] is already provided above the app.
void openProductDetailsPage(BuildContext context, Coffee coffee) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => ProductDetailsPage(coffee: coffee)),
  );
}
