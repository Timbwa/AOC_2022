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
      final val = checkForOverlap(e, full: true) ? 1 : 0;
      return acc + val;
    });

    return total;
  }

  @override
  int solvePart2() {
    final lines = parseInput();

    final total = lines.fold<int>(0, (acc, e) {
      final val = checkForOverlap(e, full: false) ? 1 : 0;
      return acc + val;
    });

    return total;
  }

  bool checkForOverlap(Tuple4<int, int, int, int> ids, {bool full = false}) {
    final set1 = <int>{};
    final set2 = <int>{};

    for (var x = ids.item1; x <= ids.item2;) {
      set1.add(x++);
    }

    for (var x = ids.item3; x <= ids.item4;) {
      set2.add(x++);
    }

    final union = set1.union(set2);
    final intersection = set1.intersection(set2);

    if (full) {
      return union.length == set1.length || union.length == set2.length;
    }

    return intersection.isNotEmpty;
  }
}
