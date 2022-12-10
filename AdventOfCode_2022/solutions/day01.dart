import 'package:equatable/equatable.dart';

import '../utils/index.dart';

class Day01 extends GenericDay {
  Day01() : super(1);

  @override
  List<Elf> parseInput() {
    final lines = input.getPerLine();

    var elfNumber = 0;
    List<Elf> elves = [];
    List<FoodItem> elfFoodItems = [];

    void addElf() {
      final elf = Elf(
        number: elfNumber++,
        foodItems: [...elfFoodItems],
      );
      elves.add(elf);
      elfFoodItems.clear();
    }

    for (var line in lines) {
      if (line.isNotEmpty) {
        final foodItemCalories = int.parse(line);
        final foodItem = FoodItem(calories: foodItemCalories);

        elfFoodItems.add(foodItem.copyWith());
      } else {
        addElf();
      }
    }
    // add last elf food item group
    addElf();

    return elves;
  }

  @override
  int solvePart1() {
    final elves = parseInput();
    elves.sort();

    return elves.last.calories;
  }

  @override
  int solvePart2() {
    final elves = parseInput();
    elves.sort();

    final topElfIndex = elves.length - 1;

    return (elves[topElfIndex] + elves[topElfIndex - 1]) + elves[topElfIndex - 2].calories;
  }
}

class FoodItem extends Equatable {
  const FoodItem({
    required this.calories,
  });

  final int calories;

  @override
  List<Object?> get props => [calories];

  FoodItem copyWith({
    int? calories,
  }) {
    return FoodItem(
      calories: calories ?? this.calories,
    );
  }
}

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
        '[ ${foodItems.fold('', (prev, e) => '$prev ${e.calories} ')}] Total: ${calories}';
  }

  int get calories => foodItems.fold<int>(0, (previousValue, foodItem) => previousValue + foodItem.calories);

  @override
  int compareTo(Elf other) {
    final thisCalories = calories;
    final otherCalories = other.calories;

    return thisCalories.compareTo(otherCalories);
  }

  int operator +(Elf other) {
    return calories + other.calories;
  }
}
