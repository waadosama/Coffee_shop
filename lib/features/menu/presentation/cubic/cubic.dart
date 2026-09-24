import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/use.dart';
import 'state.dart';

class CoffeeCubit extends Cubit<CoffeeState> {
  final GetHotCoffee getHotCoffee;

  CoffeeCubit(this.getHotCoffee)
      : super(CoffeeInitial());

  Future<void> fetchHotCoffee() async {
    emit(CoffeeLoading());

    try {
      final result = await getHotCoffee();

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