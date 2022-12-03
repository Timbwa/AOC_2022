import '../utils/index.dart';

Map<String, int> priorities = {};

class Day03 extends GenericDay {
  Day03() : super(3);

  @override
  List<String> parseInput() {
    final lines = input.getPerLine();

    return lines;
  }

  @override
  int solvePart1() {
    final lines = parseInput();
    final total = lines.fold<int>(0, (acc, line) => acc + _getPriorityForCommonItem(line));

    return total;
  }

  @override
  int solvePart2() {
    final lines = input.getPerLine();
    var index = 0;
    var value = 1;
    final groups = lines.groupListsBy((element) => value++ % 3 == 0 ? index++ : index);

    var total = 0;
    groups.forEach((key, group) {
      final l1 = group[0].split('').toSet();
      final l2 = group[1].split('').toSet();
      final l3 = group[2].split('').toSet();

      final char = l1.intersection(l2).intersection(l3).first;
      total += _getPriority(char);
    });

    return total;
  }

  int _getPriorityForCommonItem(String rucksack) {
    var comp1 = rucksack.split('').sublist(0, (rucksack.length ~/ 2)).toSet();
    var comp2 = rucksack.split('').sublist((rucksack.length ~/ 2), rucksack.length).toSet();

    return _getPriority(comp1.intersection(comp2).first);
  }

  int _getPriority(String character) {
    final asciiValue = character.codeUnitAt(0);

    if (asciiValue >= 65 && asciiValue <= 90) {
      // A (Priority 1) -> Z (Priority 26)
      return (asciiValue - 64) + 26;
    } else if (asciiValue >= 97 && asciiValue <= 122) {
      return asciiValue - 96;
    }

    throw 'Could not parse character: $character';
  }
}
