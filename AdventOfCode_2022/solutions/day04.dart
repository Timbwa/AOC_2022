import '../utils/index.dart';

class Day04 extends GenericDay {
  Day04() : super(4);

  @override
  Iterable<Tuple4<int, int, int, int>> parseInput() {
    final lines = input.getPerLine().map((e) {
      final range1X = int.parse(e.split(',')[0].split('-')[0]);
      final range1Y = int.parse(e.split(',')[0].split('-')[1]);
      final range2X = int.parse(e.split(',')[1].split('-')[0]);
      final range2Y = int.parse(e.split(',')[1].split('-')[1]);

      return Tuple4(range1X, range1Y, range2X, range2Y);
    });

    return lines;
  }

  @override
  int solvePart1() {
    final lines = parseInput();
    print(lines);

    final total = lines.fold<int>(0, (acc, e) {
      final val = checkIfRangeContainsOther(e) ? 1 : 0;
      return acc + val;
    });

    return total;
  }

  @override
  int solvePart2() {
    final lines = parseInput();

    final total = lines.fold<int>(0, (acc, e) {
      final val = checkForAnyOverlap(e) ? 1 : 0;
      return acc + val;
    });

    return total;
  }

  bool checkIfRangeContainsOther(Tuple4<int, int, int, int> ids) {
    return ids.item1 <= ids.item3 && ids.item2 >= ids.item4 || ids.item3 <= ids.item1 && ids.item4 >= ids.item2;
  }

  bool checkForAnyOverlap(Tuple4<int, int, int, int> ids) {
    final set1 = <int>{};
    final set2 = <int>{};

    for (var x = ids.item1; x <= ids.item2;) {
      set1.add(x++);
    }

    for (var x = ids.item3; x <= ids.item4;) {
      set2.add(x++);
    }

    return set1.intersection(set2).isNotEmpty;
  }
}
