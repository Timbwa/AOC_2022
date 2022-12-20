import '../utils/index.dart';

class Day18 extends GenericDay {
  Day18() : super(18);

  List<Tuple3<double, double, double>> offsets = [
    Tuple3(0, 0, 0.5),
    Tuple3(0, 0.5, 0),
    Tuple3(0.5, 0, 0),
    Tuple3(0, 0, -0.5),
    Tuple3(0, -0.5, 0),
    Tuple3(-0.5, 0, 0),
  ];

  @override
  List<Tuple3<double, double, double>> parseInput() {
    List<Tuple3<double, double, double>> cubes = [];
    final lines = input.getPerLine();
    for (var line in lines) {
      final values = line.split(',').map(double.parse).toList();
      cubes.add(Tuple3(values[0], values[1], values[2]));
    }

    return cubes;
  }

  @override
  int solvePart1() {
    final cubes = parseInput();

    Map<Tuple3<double, double, double>, int> faces = {};

    for (var cube in cubes) {
      for (var offset in offsets) {
        final key = Tuple3(
          cube.item1 + offset.item1,
          cube.item2 + offset.item2,
          cube.item3 + offset.item3,
        );

        if (!faces.keys.contains(key)) {
          faces[key] = 0;
        }
        faces[key] = faces[key]! + 1;
      }
    }

    return faces.values.where((e) => e == 1).length;
  }

  @override
  int solvePart2() {
    final cubes = parseInput();

    Map<Tuple3<double, double, double>, int> faces = {};

    Tuple3<double, double, double> maxBoundary = Tuple3(-double.infinity, -double.infinity, -double.infinity);
    Tuple3<double, double, double> minBoundary = Tuple3(double.infinity, double.infinity, double.infinity);

    for (var cube in cubes) {
      minBoundary = Tuple3(
        min([minBoundary.item1, cube.item1])!,
        min([minBoundary.item2, cube.item2])!,
        min([minBoundary.item3, cube.item3])!,
      );

      maxBoundary = Tuple3(
        max([maxBoundary.item1, cube.item1])!,
        max([maxBoundary.item2, cube.item2])!,
        max([maxBoundary.item3, cube.item3])!,
      );

      for (var offset in offsets) {
        final key = Tuple3(
          cube.item1 + offset.item1,
          cube.item2 + offset.item2,
          cube.item3 + offset.item3,
        );

        if (!faces.keys.contains(key)) {
          faces[key] = 0;
        }
        faces[key] = faces[key]! + 1;
      }
    }

    minBoundary = Tuple3(
      minBoundary.item1 - 1,
      minBoundary.item2 - 1,
      minBoundary.item3 - 1,
    );

    maxBoundary = Tuple3(
      maxBoundary.item1 + 1,
      maxBoundary.item2 + 1,
      maxBoundary.item3 + 1,
    );

    final queue = QueueList<Tuple3<double, double, double>>();
    queue.add(minBoundary);
    final air = {minBoundary};

    while (queue.isNotEmpty) {
      final cube = queue.removeFirst();
      for (var offset in offsets) {
        final key = Tuple3(
          cube.item1 + offset.item1 * 2,
          cube.item2 + offset.item2 * 2,
          cube.item3 + offset.item3 * 2,
        );
        if (!((minBoundary.item1 <= key.item1 && key.item1 <= maxBoundary.item1) &&
            (minBoundary.item2 <= key.item2 && key.item2 <= maxBoundary.item2) &&
            (minBoundary.item3 <= key.item3 && key.item3 <= maxBoundary.item3))) {
          continue;
        }
        if (cubes.contains(key) || air.contains(key)) {
          continue;
        }
        air.add(key);
        queue.addLast(key);
      }
    }

    var free = <Tuple3<double, double, double>>{};
    final facesSet = faces.keys.toSet();

    for (var airSpace in air) {
      for (var offset in offsets) {
        free.add(Tuple3(
          airSpace.item1 + offset.item1,
          airSpace.item2 + offset.item2,
          airSpace.item3 + offset.item3,
        ));
      }
    }

    return facesSet.intersection(free).length;
  }
}
