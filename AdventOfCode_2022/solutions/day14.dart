import 'dart:io';

import '../utils/index.dart';

class Day14 extends GenericDay {
  Day14() : super(14);

  @override
  Set<Tuple2<int, int>> parseInput() {
    final lines = input
        .getPerLine()
        .map((e) => e
            .split(' -> ')
            .map(
              (e) => Tuple2(
                int.parse(e.split(',')[0]),
                int.parse(e.split(',')[1]),
              ),
            )
            .toList())
        .toList();

    var rockPathSet = <Tuple2<int, int>>{};

    for (var path in lines) {
      for (var pair in zip([path, path.sublist(1)])) {
        var xCoordinates = [pair[0].item1, pair[1].item1].sorted((a, b) => a.compareTo(b));
        var yCoordinates = [pair[0].item2, pair[1].item2].sorted((a, b) => a.compareTo(b));

        for (var x in range(xCoordinates[0], xCoordinates[1] + 1)) {
          for (var y in range(yCoordinates[0], yCoordinates[1] + 1)) {
            rockPathSet.add(Tuple2<int, int>(x as int, y as int));
          }
        }
      }
    }

    return rockPathSet;
  }

  @override
  int solvePart1() {
    var rockPathSet = parseInput();

    var rockPathVerticallySortedList = rockPathSet.sorted((a, b) => a.item2.compareTo(b.item2));
    var BottomMostRock = rockPathVerticallySortedList.last;

    bool withinBounds(Tuple2<int, int> unit) => unit.item2 <= BottomMostRock.item2;

    var unitsAtRest = <Tuple2<int, int>>{};

    bool isBlocked(Tuple2<int, int> unit) => rockPathSet.contains(unit) || unitsAtRest.contains(unit);

    var sandUnit = Tuple2(500, 0);
    var diagonalLeftDown = Tuple2(sandUnit.item1 - 1, sandUnit.item2 + 1);
    var diagonalRightDown = Tuple2(sandUnit.item1 + 1, sandUnit.item2 + 1);
    var nextPosition = sandUnit.withItem2(sandUnit.item2 + 1);
    var sandUnits = 0;

    while (withinBounds(nextPosition)) {
      if (isBlocked(nextPosition)) {
        diagonalLeftDown = Tuple2(nextPosition.item1 - 1, nextPosition.item2);
        if (isBlocked(diagonalLeftDown)) {
          diagonalRightDown = Tuple2(nextPosition.item1 + 1, nextPosition.item2);
          if (isBlocked(diagonalRightDown) && withinBounds(diagonalRightDown)) {
            unitsAtRest.add(sandUnit);
            sandUnit = Tuple2(500, 0);
            nextPosition = sandUnit.withItem2(sandUnit.item2 + 1);
            sandUnits++;
          } else {
            sandUnit = diagonalRightDown;
            nextPosition = sandUnit.withItem2(sandUnit.item2 + 1);
          }
        } else {
          sandUnit = diagonalLeftDown;
          nextPosition = sandUnit.withItem2(sandUnit.item2 + 1);
        }
      } else {
        sandUnit = nextPosition;
        nextPosition = sandUnit.withItem2(sandUnit.item2 + 1);
      }
    }

    return sandUnits;
  }

  @override
  int solvePart2() {
    var rockPathSet = parseInput();

    var rockPathVerticallySortedList = rockPathSet.sorted((a, b) => a.item2.compareTo(b.item2));
    var rockPathHorizontallySortedList = rockPathSet.sorted((a, b) => a.item1.compareTo(b.item1));
    var bottomMostRock = rockPathVerticallySortedList.last;

    var leftMostRock = rockPathHorizontallySortedList.first;
    var rightMostRock = rockPathHorizontallySortedList.last;

    for (var i = leftMostRock.item1 - 200; i < rightMostRock.item1 + 200; i++) {
      rockPathSet.add(Tuple2<int, int>(i, bottomMostRock.item2 + 2));
    }

    var unitsAtRest = <Tuple2<int, int>>{};

    bool isBlocked(Tuple2<int, int> unit) => rockPathSet.contains(unit) || unitsAtRest.contains(unit);

    var sandUnits = 0;

    while (!isBlocked(Tuple2(500, 0))) {
      var sandUnit = Tuple2(500, 0);
      while (true) {
        if (sandUnit.item2 >= bottomMostRock.item2 + 2) {
          break;
        }
        var nextPosition = sandUnit.withItem2(sandUnit.item2 + 1);
        if (!isBlocked(nextPosition)) {
          sandUnit = nextPosition;
          continue;
        }
        var diagonalLeftDown = Tuple2(sandUnit.item1 - 1, sandUnit.item2 + 1);
        if (!isBlocked(diagonalLeftDown)) {
          sandUnit = diagonalLeftDown;
          continue;
        }
        var diagonalRightDown = Tuple2(sandUnit.item1 + 1, sandUnit.item2 + 1);
        if (!isBlocked(diagonalRightDown)) {
          sandUnit = diagonalRightDown;
          continue;
        }
        break;
      }
      unitsAtRest.add(sandUnit);
      sandUnits++;
    }

    for (var j = 0; j < 175; j++) {
      for (var i = 0; i < 180; i++) {
        final currentPosition = Tuple2(i + 400, j);
        if (rockPathSet.contains(currentPosition)) {
          stdout.write('#');
          continue;
        }
        if (unitsAtRest.contains(currentPosition)) {
          stdout.write('o');
          continue;
        }
        stdout.write('.');
      }
      stdout.writeln();
    }
    return sandUnits;
  }
}
