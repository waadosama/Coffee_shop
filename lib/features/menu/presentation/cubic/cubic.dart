import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/coffe.dart';
import '../../domain/usecases/use.dart';
import 'state.dart';

class CoffeeCubit extends Cubit<CoffeeState> {
  final GetHotCoffee getHotCoffee;
  final GetColdDrinks getColdDrinks;
  final GetBreakfast getBreakfast;

  CoffeeCubit(
    this.getHotCoffee, {
    GetColdDrinks? getColdDrinks,
    GetBreakfast? getBreakfast,
  }) : getColdDrinks = getColdDrinks ?? GetColdDrinks(getHotCoffee.repository),
       getBreakfast = getBreakfast ?? GetBreakfast(getHotCoffee.repository),
       super(CoffeeInitial());

  Future<void> fetchHotCoffee() => _load(() => getHotCoffee());

  Future<void> fetchColdDrinks() => _load(() => getColdDrinks());

  Future<void> fetchBreakfast() => _load(() => getBreakfast());

  Future<void> _load(Future<List<Coffee>> Function() loader) async {
    emit(CoffeeLoading());

    try {
      final result = await loader();

      emit(CoffeeSuccess(result));
    } catch (e) {
      emit(
        CoffeeError(
          e.toString(),
        ),
      );
    }
  }
}
