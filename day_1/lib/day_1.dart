import 'dart:convert';
import 'dart:io';

import 'model/models.dart';

int getTopElfCalories(List<Elf> elves) {
  if (elves.isNotEmpty) {
    elves.sort();

    print('=== STATS ===');
    final topElf = elves.last;
    final bottomElf = elves.first;
    final totalElves = elves.length;

    print('Top Elf: $topElf');
    print('Bottom Elf: $bottomElf');
    print('Total Elves: $totalElves');

    return topElf.getCalories();
  }

  stderr.writeln('Error: Input File is empty!');
  exit(2);
}

Future<List<Elf>> parseAndConvertInputToElves(String filename) async {
  final lines = utf8.decoder.bind(File(filename).openRead()).transform(const LineSplitter());
  List<Elf> elves = [];

  try {
    List<FoodItem> elfFoodItems = [];
    var index = 0;

    void addElf() {
      final elf = Elf(
        number: index++,
        foodItems: [...elfFoodItems],
      );
      elves.add(elf);

      elfFoodItems.clear();
    }

    await for (final line in lines) {
      if (line.isNotEmpty) {
        final foodItemCalories = int.parse(line);
        final foodItem = FoodItem(calories: foodItemCalories);

        elfFoodItems.add(foodItem.copyWith());
      } else {
        addElf();
      }
    }
    // Add Elf after reading last line
    addElf();
  } catch (_) {
    stderr.writeln('Could not read file. Error: $_');
    exit(2);
  }

  return elves;
}
