import 'dart:io';

import '../utils/index.dart';

class RockFormation {
  RockFormation({
    required this.units,
  });

  // top-left is marked as (0, 0)
  Set<Complex> units;

  factory RockFormation.fromShape(RockShape rockShape) {
    switch (rockShape) {
      case RockShape.horizontalLine:
        return RockFormation.horizontalLine();
      case RockShape.star:
        return RockFormation.star();
      case RockShape.mirroredL:
        return RockFormation.mirroredL();
      case RockShape.verticalLine:
        return RockFormation.verticalLine();
      case RockShape.box:
        return RockFormation.box();
    }
  }

  factory RockFormation.horizontalLine() {
    return RockFormation(units: {
      Complex(0, 0),
      Complex(1, 0),
      Complex(2, 0),
      Complex(3, 0),
    });
  }

  factory RockFormation.star() {
    return RockFormation(units: {
      Complex(1, 0),
      Complex(0, 1),
      Complex(1, 1),
      Complex(2, 1),
      Complex(1, 2),
    });
  }

  factory RockFormation.mirroredL() {
    return RockFormation(units: {
      Complex(2, 0),
      Complex(2, 1),
      Complex(0, 0),
      Complex(1, 0),
      Complex(2, 2),
    });
  }

  factory RockFormation.verticalLine() {
    return RockFormation(units: {
      Complex(0, 0),
      Complex(0, 1),
      Complex(0, 2),
      Complex(0, 3),
    });
  }

  factory RockFormation.box() {
    return RockFormation(units: {
      Complex(0, 0),
      Complex(1, 0),
      Complex(0, 1),
      Complex(1, 1),
    });
  }

/*  int get maxY => max(units.map((e) => e.y))!;
  int get maxX => max(units.map((e) => e.x))!;
  int get minY => min(units.map((e) => e.y))!;
  int get minX => min(units.map((e) => e.x))!;*/
/*  int get bottomY => maxY;
  int get topY => minY;*/
/*
  Iterable<Complex> get leftMostUnits => units.where((element) => element.x == minX);
  Iterable<Complex> get rightMostUnits => units.where((element) => element.x == maxX);
  Iterable<Complex> get bottomMostUnits => units.where((element) => element.y == maxY);

  bool hasUnit(int x, int y) => units.contains(Complex(x, y));*/

  /*void setStartPosition([int highestBottomRockUnit = 0]) {
    // shift all x by two & y by 3 + highestBottomRockUnit after mirroring on the x-axis
    units = units.map((unit) => unit = Complex(unit.x + 2, ((-1 * unit.y) + (highestBottomRockUnit - 3)) - 1)).toList();
  }*/

  void setStart([double height = 0]) {
    units = units.map((e) => Complex(e.x + 2, (height + 3) + e.j)).toSet();
  }

  void shift(int delta) {
    units = units.map((e) => Complex(e.x + delta, e.j)).toSet();
  }

  void moveDown() {
    units = units.map((e) => Complex(e.x, e.j - 1)).toSet();
  }

/*  void shiftLeft() {
    if (minX > 0) {
      units = units.map((unit) => unit.withItem1(unit.x - 1)).toList();
    }
  }

  void shiftRight() {
    if (maxX < 6) {
      units = units.map((unit) => unit.withItem1(unit.x + 1)).toList();
    }
  }

  void moveDown([int highestBottomRockUnit = 0]) {
    units = units.map((unit) => unit.withItem2(unit.y + 1)).toList();
    */ /*if (bottomY < highestBottomRockUnit) {
      units = units.map((unit) => unit.withItem2(unit.y + 1)).toList();
    }*/ /*
  }

  void moveUp() {
    units = units.map((unit) => unit.withItem2(unit.y - 1)).toList();
  }*/

  /*void display([int leastY = -3]) {
    for (var y = leastY; y <= maxY; y++) {
      for (var x = 0; x <= maxX; x++) {
        if (this.hasUnit(x, y)) {
          stdout.write('#');
        } else {
          stdout.write('.');
        }
      }
      stdout.writeln();
    }
  }*/

  @override
  String toString() {
    return 'RockFormation{units: $units}';
  }
}

enum JetDirection {
  left,
  right,
}

enum RockShape {
  horizontalLine,
  star,
  mirroredL,
  verticalLine,
  box,
}

class Floor {
  List<Position> units;

  Floor({
    this.units = const [
      Position(0, 0),
      Position(1, 0),
      Position(2, 0),
      Position(3, 0),
      Position(4, 0),
      Position(5, 0),
      Position(6, 0),
      Position(7, 0),
    ],
  });

  bool contains(Position position) => units.contains(position);

  bool isDirectlyBelow(Position position) => units.any((e) => (e.y - position.y).abs() == 1);
}

class Day17 extends GenericDay {
  Day17() : super(17);

  @override
  List<JetDirection> parseInput() {
    return input.asString.split('').map((e) => e == '<' ? JetDirection.left : JetDirection.right).toList();
  }

  @override
  int solvePart1() {
    final jetDirections = parseInput().map((e) => e == JetDirection.left ? -1 : 1).toList();
    final settled = <Complex>{};
    // add floor
    for (var x in range(7)) {
      settled.add(Complex(x * 1.0, -1));
    }

    final floor = RockFormation(units: {...settled});

    const maxRocks = 2022;
    double totalHeight = 0;
    int totalRocks = 0;
    int rockIndex = 0;
    int jetIndex = 0;

    RockFormation currentRock = RockFormation.fromShape(RockShape.values[rockIndex % 5]);
    currentRock.setStart();
    RockFormation tempMovedRock = RockFormation(units: {...currentRock.units});

    void showState(Set<Complex> unsettledRockPositions, [int step = 0]) {
      // return;
      if (step != maxRocks) {
        return;
      }
      print('------------------------');

      final totalUnits = {...settled, ...floor.units, ...unsettledRockPositions};
      final leastY = min(totalUnits.map((e) => e.j))! - 1;
      final maxY = max(totalUnits.map((e) => e.j))! + 1;
      final maxX = 8;
      for (var y = maxY; y > leastY; y--) {
        for (var x = -1; x < maxX; x++) {
          if (x == -1 || x == maxX - 1) {
            stdout.write('|');
          } else if (floor.units.contains(Complex(x * 1.0, y))) {
            stdout.write('o');
          } else if (settled.contains(Complex(x * 1.0, y))) {
            stdout.write('#');
          } else if (unsettledRockPositions.contains(Complex(x * 1.0, y))) {
            stdout.write('@');
          } else {
            stdout.write('.');
          }
        }
        stdout.writeln();
      }
    }

    showState(currentRock.units);
    while (totalRocks < maxRocks) {
      tempMovedRock = RockFormation(units: {...currentRock.units});
      final jetDelta = jetDirections[jetIndex++ % jetDirections.length];
      tempMovedRock.shift(jetDelta);
      final canShiftRock =
          tempMovedRock.units.every((e) => 0 <= e.x && e.x < 7) && settled.intersection(tempMovedRock.units).isEmpty;
      if (canShiftRock) {
        currentRock.shift(jetDelta);
      }
      showState(currentRock.units);
      tempMovedRock = RockFormation(units: {...currentRock.units});
      tempMovedRock.moveDown();
      if (tempMovedRock.units.intersection(settled).isNotEmpty) {
        settled.addAll(currentRock.units);
        totalRocks += 1;
        totalHeight = max(settled.map((e) => e.j))! + 1;
        if (totalRocks >= maxRocks) {
          break;
        }
        currentRock = RockFormation.fromShape(RockShape.values[++rockIndex % 5]);
        currentRock.setStart(totalHeight);
      } else {
        currentRock = RockFormation(units: {...tempMovedRock.units});
      }
      // tempMovedRock = RockFormation(units: {...currentRock.units});
      // showState(currentRock.units, totalRocks);
      // print(currentRock);
    }
    // showState(currentRock.units, totalRocks);
    return totalHeight ~/ 1;
  }

  @override
  int solvePart2() {
    return 0;
  }
}

/*int p1() {
  final directions = Day17().parseInput();
  final floor = Floor();

  List<int> topRockHeights = [];

  var rockIndex = 0;
  var directionIndex = 0;
  var shouldMoveDown = true;
  var steps = 0;
  var highestBottomRockUnit = 0;
  RockFormation? topRock = null;
  Set<Position> settledRockUnits = {};
  Set<Position> totalRockPositions = {};

  var currentRock = RockFormation.fromShape(RockShape.values[rockIndex % 4]);
  var tempRock = RockFormation(units: [...currentRock.units]);
  int minValue = currentRock.topY;
  totalRockPositions.addAll(currentRock.units);

  void showState(Set<Position> unsettledRockPositions, [int step = 0]) {
    if (step != 2022) {
      return;
    }
    print('------------------------');

    final totalUnits = {...settledRockUnits, ...floor.units, ...unsettledRockPositions};
    final leastY = min(totalUnits.map((e) => e.item2))! - 4;
    final maxY = max(totalUnits.map((e) => e.item2))! + 1;
    final maxX = 8;
    for (var y = leastY; y < maxY; y++) {
      for (var x = -1; x < maxX; x++) {
        if (x == -1 || x == maxX - 1) {
          stdout.write('|');
        } else if (settledRockUnits.contains(Position(x, y))) {
          stdout.write('#');
        } else if (floor.units.contains(Position(x, y))) {
          stdout.write('o');
        } else if (unsettledRockPositions.contains(Position(x, y))) {
          stdout.write('@');
        } else {
          stdout.write('.');
        }
      }
      stdout.writeln();
    }
  }

  while (steps < 2022) {
    currentRock.setStartPosition(highestBottomRockUnit);
    tempRock = RockFormation(units: [...currentRock.units]);
    showState({...currentRock.units});

    while (true) {
      if ((tempRock.units.any((unit) => floor.isDirectlyBelow(unit)) && shouldMoveDown) ||
          settledRockUnits.any((e) => tempRock.bottomMostUnits.contains(e))) {
        settledRockUnits.addAll([...currentRock.units]);
        break;
      }
      if (shouldMoveDown) {
        tempRock = RockFormation(units: [...currentRock.units]);
        tempRock.moveDown(highestBottomRockUnit);
        if (settledRockUnits.any((e) => tempRock.bottomMostUnits.contains(e))) {
          break;
        }
        currentRock.moveDown(highestBottomRockUnit);
        shouldMoveDown = !shouldMoveDown;
        showState({...currentRock.units});
      } else {
        final currentJetDirection = directions[directionIndex % directions.length];
        switch (currentJetDirection) {
          case JetDirection.left:
            tempRock = RockFormation(units: [...currentRock.units]);
            tempRock.shiftLeft();
            if (settledRockUnits.any((e) => tempRock.leftMostUnits.contains(e))) {
              break;
            }
            currentRock.shiftLeft();
            showState({...currentRock.units});
            break;
          case JetDirection.right:
            tempRock = RockFormation(units: [...currentRock.units]);
            tempRock.shiftRight();
            if (settledRockUnits.any((e) => tempRock.rightMostUnits.contains(e))) {
              break;
            }
            currentRock.shiftRight();
            showState({...currentRock.units});
            break;
        }
        shouldMoveDown = !shouldMoveDown;
        directionIndex++;
      }
    }
    topRock = currentRock;
    minValue = min([minValue, currentRock.topY])!;
    highestBottomRockUnit = minValue;
    rockIndex++;
    steps++;
    settledRockUnits.addAll([...topRock.units]);
    currentRock = RockFormation.fromShape(RockShape.values[rockIndex % 5]);
    shouldMoveDown = false;
    showState({...currentRock.units}, steps);
  }

  return highestBottomRockUnit * -1;
}*/
