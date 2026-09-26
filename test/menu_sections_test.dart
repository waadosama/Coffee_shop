import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:coffee_shop_app/core/network/dio_client.dart';
import 'package:coffee_shop_app/features/menu/data/datasources/remote.dart';
import 'package:coffee_shop_app/features/menu/data/repositories/coffe_imp.dart';
import 'package:coffee_shop_app/features/menu/domain/usecases/use.dart';
import 'package:coffee_shop_app/features/menu/presentation/cubic/cubic.dart';
import 'package:coffee_shop_app/features/menu/presentation/pages/breakfast_page.dart';
import 'package:coffee_shop_app/features/menu/presentation/pages/cold_drinks_page.dart';
import 'package:coffee_shop_app/features/menu/presentation/pages/menu_page.dart';

CoffeeCubit _buildCubit() {
  final remote = CoffeeRemoteDataSourceImpl(DioClient().dio);
  final repo = CoffeeRepositoryImpl(remote);
  return CoffeeCubit(GetHotCoffee(repo));
}

Widget _host(Widget page) {
  return MaterialApp(
    home: BlocProvider<CoffeeCubit>(
      create: (_) => _buildCubit(),
      child: page,
    ),
  );
}

void main() {
  testWidgets('MenuPage renders the hot-drink section and tab bar',
      (tester) async {
    await tester.pumpWidget(_host(const MenuPage()));
    await tester.pump();

    expect(find.text('المنيو'), findsOneWidget);
    expect(find.text('Hot'), findsOneWidget);
    expect(find.text('Cold'), findsOneWidget);
    expect(find.text('Breakfast'), findsOneWidget);
  });

  testWidgets('ColdDrinksPage renders its own header and tab bar',
      (tester) async {
    await tester.pumpWidget(_host(const ColdDrinksPage()));
    await tester.pump();

    expect(find.text('مشروبات بارده'), findsOneWidget);
    expect(find.text('مشروبات باردة'), findsOneWidget);
    expect(find.text('Cold'), findsOneWidget);
  });

  testWidgets('BreakfastPage renders its own header and tab bar',
      (tester) async {
    await tester.pumpWidget(_host(const BreakfastPage()));
    await tester.pump();

    expect(find.text('الفطور'), findsNWidgets(2));
    expect(find.text(' breakfast meal'), findsOneWidget);
    expect(find.text('Breakfast'), findsOneWidget);
  });

  testWidgets('tab bar switches from hot drinks to cold drinks',
      (tester) async {
    await tester.pumpWidget(_host(const MenuPage()));
    await tester.pump();

    await tester.tap(find.text('Cold'));
    await tester.pumpAndSettle();

    expect(find.text('مشروبات بارده'), findsOneWidget);
    expect(find.byType(ColdDrinksPage), findsOneWidget);
    expect(find.byType(MenuPage), findsNothing);
  });

  testWidgets('tab bar switches from cold drinks to breakfast',
      (tester) async {
    await tester.pumpWidget(_host(const ColdDrinksPage()));
    await tester.pump();

    await tester.tap(find.text('Breakfast'));
    await tester.pumpAndSettle();

    expect(find.byType(BreakfastPage), findsOneWidget);
    expect(find.byType(ColdDrinksPage), findsNothing);
  });
}
