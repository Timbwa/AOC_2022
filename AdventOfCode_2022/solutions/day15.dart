import '../utils/index.dart';

extension Tuple2X on Tuple2<int, int> {
  int compareTo(Tuple2<int, int> other) {
    if (x == other.x) {
      return y.compareTo(other.y);
    }

    return x.compareTo(other.x);
  }
}

class Day15 extends GenericDay {
  Day15() : super(15);

  @override
  List<List<Position>> parseInput() {
    final lines = input.getPerLine();
    final sensorsAndBeacons = lines
        .map((e) => [
              Position(
                int.parse(e.split(':')[0].split(', ')[0].split(' ')[2].split('=')[1]),
                int.parse(e.split(':')[0].split(', ')[1].split('=')[1]),
              ),
              Position(
                int.parse(e.split(':')[1].split(', ')[0].trim().split(' ')[4].split('=')[1]),
                int.parse(e.split(':')[1].split(', ')[1].split('=')[1]),
              ),
            ])
        .toList();

    return sensorsAndBeacons;
  }

  Iterable<Position> neighbours(int x, int y, {int range = 1, int beaconDistance = 0}) {
    final sensorPosition = Position(x, y);
    final immediateNeighbors = <Position>{
      // positions are added in a circle, starting at the top middle
      Position(x, y - range), // up
      Position(x + range, y - range), // diagonal up right
      Position(x + range, y), // right
      Position(x + range, y + range), // diagonal down right
      Position(x, y + range), // down
      Position(x - range, y + range), // diagonal down left
      Position(x - range, y),
      Position(x - range, y - range),
    }..where((e) => manhattanDistance(sensorPosition, e) <= beaconDistance);

    if (range > 1) {
      final topLeft = Position(x - range, y - range);
      final bottomRight = Position(x + range, y + range);

      for (var x = topLeft.x; x < bottomRight.x; x++) {
        final pos = Position(x, topLeft.y);
        if (manhattanDistance(sensorPosition, pos) > beaconDistance) {
          continue;
        }
        immediateNeighbors.add(Position(x, topLeft.y));
      }
      for (var y = topLeft.y; y < bottomRight.y; y++) {
        final pos = Position(topLeft.x, y);
        if (manhattanDistance(sensorPosition, pos) > beaconDistance) {
          continue;
        }
        immediateNeighbors.add(pos);
      }

      for (var x = bottomRight.x; x > topLeft.x; x--) {
        final pos = Position(x, bottomRight.y);
        if (manhattanDistance(sensorPosition, pos) > beaconDistance) {
          continue;
        }
        immediateNeighbors.add(pos);
      }

      for (var y = bottomRight.y; y > topLeft.y; y--) {
        final pos = Position(bottomRight.x, y);
        if (manhattanDistance(sensorPosition, pos) > beaconDistance) {
          continue;
        }
        immediateNeighbors.add(pos);
      }
    }

    return immediateNeighbors;
  }

  int manhattanDistance(Position p1, Position p2) {
    return (p1.x - p2.x).abs() + (p1.y - p2.y).abs();
  }

  @override
  int solvePart1() {
    final sensorsAndBeacons = parseInput();

    final known = <int>{};
    final cannot = <int>{};

    final xIntervals = <Tuple2<int, int>>[];
    final y = 2000000;
    for (var sensorAndBeacon in sensorsAndBeacons) {
      final sensor = sensorAndBeacon[0];
      final beacon = sensorAndBeacon[1];
      final distance = manhattanDistance(sensor, beacon);

      // Y = 10
      // looking fr all x such that abs(sensor.x - x) + abs(sensor.y - Y) <= distance
      // we know abs(sensor.y - Y)
      // so
      // we need to find x: abs(sensor.x - x) <= distance - abs(sensor.y - Y)
      // boundary will lie at minimum and maximum values
      // where: abs(sensor.x - x) == distance - abs(sensor.y - Y)
      // or sensor.x - x == +/- distance - abs(sensor.y - Y)

      final offset = distance - (sensor.y - y).abs();
      // if offset is negative, means distance is less than (sensor.y - y).abs()
      // => means point is less than point to beacon (unimportant)
      if (offset < 0) {
        continue;
      }
      final lowerx = sensor.x - offset;
      final upperx = sensor.x + offset;

      // intervals tell us all the x points that can't exist
      xIntervals.add(Tuple2<int, int>(lowerx, upperx));
      if (beacon.y == y) {
        known.add(beacon.x);
      }
    }
    xIntervals.sort((a, b) => a.x == b.x ? a.y.compareTo(b.y) : a.x.compareTo(b.x));
    final nonOverlappingIntervals = <List<int>>[];

    for (var interval in xIntervals) {
      if (nonOverlappingIntervals.isEmpty) {
        nonOverlappingIntervals.add([interval.x, interval.y]);
      }
      final firstInterval = nonOverlappingIntervals.first;
      if (interval.item1 > firstInterval[1] + 1) {
        nonOverlappingIntervals.add([interval.x, interval.y]);
        continue;
      }

      nonOverlappingIntervals.first[1] = max([firstInterval[1], interval.item2])!;
    }

    for (var interval in xIntervals) {
      for (var x in range(interval.x, interval.y + 1)) {
        cannot.add(x as int);
      }
    }

    return cannot.difference(known).length;
  }

  @override
  int solvePart2() {
    final sensorsAndBeacons = parseInput();

    final searchBoundary = 4000000;

    for (var y in range(searchBoundary + 1)) {
      final xIntervals = <Tuple2<int, int>>[];
      for (var sensorAndBeacon in sensorsAndBeacons) {
        final sensor = sensorAndBeacon[0];
        final beacon = sensorAndBeacon[1];
        final distance = manhattanDistance(sensor, beacon);
        // Y = 10
        // looking fr all x such that abs(sensor.x - x) + abs(sensor.y - Y) <= distance
        // we know abs(sensor.y - Y)
        // so
        // we need to find x: abs(sensor.x - x) <= distance - abs(sensor.y - Y)
        // boundary will lie at minimum and maximum values
        // where: abs(sensor.x - x) == distance - abs(sensor.y - Y)
        // or sensor.x - x == +/- distance - abs(sensor.y - Y)

        final offset = distance - (sensor.y - y).abs() as int;
        // if offset is negative, means distance is less than (sensor.y - y).abs()
        // => means point is less than point to beacon (unimportant)
        if (offset < 0) {
          continue;
        }
        final lowerx = sensor.x - offset;
        final upperx = sensor.x + offset;

        // intervals tell us all the x points that can't exist
        xIntervals.add(Tuple2<int, int>(lowerx, upperx));
      }
      xIntervals.sort((a, b) => a.x == b.x ? a.y.compareTo(b.y) : a.x.compareTo(b.x));
      final nonOverlappingIntervals = <List<int>>[];

      for (var interval in xIntervals) {
        if (nonOverlappingIntervals.isEmpty) {
          nonOverlappingIntervals.add([interval.x, interval.y]);
        }
        final firstInterval = nonOverlappingIntervals.first;
        if (interval.item1 > firstInterval[1] + 1) {
          nonOverlappingIntervals.add([interval.x, interval.y]);
          continue;
        }

        nonOverlappingIntervals.first[1] = max([firstInterval[1], interval.item2])!;
      }
      // print('$y $nonOverlappingIntervals');

      var x = 0;
      var beaconCoordinate = Position(0, 0);
      for (var interval in nonOverlappingIntervals) {
        if (x < interval[0]) {
          beaconCoordinate = Position(x, y as int);
          print('Distress Beacon is at: $x $y');
          return beaconCoordinate.x * 4000000 + beaconCoordinate.y;
        }
        x = interval[1] + 1;
        if (x > searchBoundary) {
          break;
        }
      }
    }

    return 0;
  }
}
