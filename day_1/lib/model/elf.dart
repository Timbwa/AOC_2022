import 'package:equatable/equatable.dart';

import 'food_item.dart';

class Elf extends Equatable implements Comparable<Elf> {
  const Elf({
    required this.number,
    required this.foodItems,
  });

  final int number;
  final Iterable<FoodItem> foodItems;

  @override
  List<Object?> get props => [number, foodItems];

  @override
  String toString() {
    return 'Elf $number: '
        '[ ${foodItems.fold('', (prev, e) => '$prev ${e.calories} ')}] Total: ${getCalories()}';
  }

  int getCalories() {
    return foodItems.fold<int>(0, (previousValue, foodItem) => previousValue + foodItem.calories);
  }

  @override
  int compareTo(Elf other) {
    final thisCalories = getCalories();
    final otherCalories = other.getCalories();

    return thisCalories.compareTo(otherCalories);
  }
}
