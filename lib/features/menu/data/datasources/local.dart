import '../models/coffe_model.dart';

/// Breakfast has no remote endpoint in the Coffee Shop API,
/// so it is served from a local, built-in data source.
abstract class BreakfastLocalDataSource {
  Future<List<CoffeeModel>> getBreakfast();
}

class BreakfastLocalDataSourceImpl implements BreakfastLocalDataSource {
  const BreakfastLocalDataSourceImpl();

  @override
  Future<List<CoffeeModel>> getBreakfast() async {
    // Simulate a short local read so the loading state stays visible.
    await Future<void>.delayed(const Duration(milliseconds: 350));

    return _items;
  }

  static const List<CoffeeModel> _items = [
    CoffeeModel(
      id: 101,
      name: 'Avocado Toast',
      description: 'Sourdough, smashed avocado, chili flakes, lime',
      image:
          'https://images.unsplash.com/photo-1541519227354-08fa5d50c44d?auto=format&fit=crop&w=700&q=80',
    ),
    CoffeeModel(
      id: 102,
      name: 'Butter Croissant',
      description: 'Flaky, buttery, baked fresh every morning',
      image:
          'https://images.unsplash.com/photo-1555507036-ab1f4038808a?auto=format&fit=crop&w=700&q=80',
    ),
    CoffeeModel(
      id: 103,
      name: 'Pancake Stack',
      description: 'Three buttermilk pancakes, honey and berries',
      image:
          'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?auto=format&fit=crop&w=700&q=80',
    ),
    CoffeeModel(
      id: 104,
      name: 'Cheese Omelette',
      description: 'Three eggs, cheddar, herbs, toast on the side',
      image:
          'https://images.unsplash.com/photo-1510693206972-df098062cb71?auto=format&fit=crop&w=700&q=80',
    ),
    CoffeeModel(
      id: 105,
      name: 'Granola Bowl',
      description: 'Greek yogurt, granola, seasonal fruit, honey',
      image:
          'https://images.unsplash.com/photo-1511690743698-d9d85f2fbf38?auto=format&fit=crop&w=700&q=80',
    ),
    CoffeeModel(
      id: 106,
      name: 'Shakshuka',
      description: 'Eggs poached in spiced tomato, feta, warm bread',
      image:
          'https://images.unsplash.com/photo-1590301157890-4810ed352733?auto=format&fit=crop&w=700&q=80',
    ),
  ];
}
