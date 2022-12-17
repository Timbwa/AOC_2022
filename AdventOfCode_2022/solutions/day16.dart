import 'package:equatable/equatable.dart';

import '../utils/index.dart';

class Graph {
  Graph({
    required this.valves,
  });

  Map<String, Valve> valves;

  void addEdge(String valveName, Valve neighbor) {
    valves[valveName]!.neighbors.add(neighbor);
  }
}

class Valve extends Equatable {
  Valve({
    required this.name,
    required this.rate,
    this.valvesToNames = const [],
  });

  final int rate;
  final String name;
  final List<String> valvesToNames;
  Set<Valve> neighbors = {};

  @override
  List<Object?> get props => [name, rate];

  @override
  String toString() {
    return '$name';
  }
}

class DFSState extends Equatable {
  final int minutes;

  /// Used to represent opened and closed valves
  final int bitMask;
  final Valve currentValve;

  const DFSState({
    required this.minutes,
    required this.bitMask,
    required this.currentValve,
  });

  @override
  List<Object?> get props => [minutes, currentValve, bitMask];
}

class Day16 extends GenericDay {
  Day16() : super(16);

  @override
  List<Valve> parseInput() {
    final lines = input.getPerLine();
    final valves = lines.map((e) {
      final name = e.split(';')[0].split(' ')[1];
      final rate = int.parse(e.split(';')[0].split(' ')[4].split('=')[1]);
      final valvesTo = [e.split(';')[1].split(', ')[0].split(' ').last, ...e.split(';')[1].split(', ').sublist(1)];

      return Valve(
        name: name,
        rate: rate,
        valvesToNames: valvesTo,
      );
    }).toList();

    return valves;
  }

  @override
  int solvePart1() {
    final valves = parseInput();
    final valveMap = valves.asMap().map((key, value) => MapEntry(value.name, value));
    final graph = Graph(valves: valveMap);

    // connect neighbors
    for (var valve in valves) {
      for (var neighborName in valve.valvesToNames) {
        graph.addEdge(valve.name, graph.valves[neighborName]!);
        // graph.addEdge(neighborName, valve);
      }
    }
    List<Valve> nonEmpty = [];

    final AAValve = valves.where((e) => e.name == 'AA').first;

    Map<Valve, Map<Valve, int>> distances = {};
    // find shortest distance of non empty valves to every other non empty valve
    for (var valve in valves) {
      List<Valve> visitedValves = [];
      // skip valves with flow rate 0
      if (valve.name != 'AA' && valve.rate == 0) {
        continue;
      }

      if (valve.name != 'AA') {
        nonEmpty.add(valve);
      }

      distances[valve] = {valve: 0, AAValve: 0};
      visitedValves.add(valve);

      final queue = QueueList<Tuple2<int, Valve>>();
      queue.add(Tuple2(0, valve));

      while (queue.isNotEmpty) {
        final currentValveDistancePair = queue.removeFirst();
        final currentDistance = currentValveDistancePair.item1;
        final currentValve = currentValveDistancePair.item2;

        for (var neighbor in currentValve.neighbors) {
          if (!visitedValves.contains(neighbor)) {
            visitedValves.add(neighbor);
            if (neighbor.rate > 0) {
              distances[valve]![neighbor] = currentDistance + 1;
            }
            queue.add(Tuple2(currentDistance + 1, neighbor));
          }
        }
      }
      // remove self-valve and distance to AA valve
      distances[valve]!.removeWhere((key, value) => key == valve);
      if (valve != AAValve) {
        distances[valve]!.removeWhere((key, value) => key == AAValve);
      }
    }
    // map non-empty valves to indices to be used by bitmask
    Map<Valve, int> indices = {};
    nonEmpty.forEachIndexed((index, element) {
      indices[element] = index;
    });

    // use memoization to optimize DFS
    Map<DFSState, int> cache = {};

    int depthFirstSearch(DFSState state) {
      int maxValue = 0;
      if (cache.containsKey(state)) {
        return cache[state]!;
      }

      distances[state.currentValve]!.forEach((neighbor, distance) {
        // left shift the neighbor index to check if it's closed
        final bit = 1 << indices[neighbor]!;
        if (state.bitMask & bit == 0) {
          final remainingMinutes = state.minutes - distances[state.currentValve]![neighbor]! - 1;

          if (remainingMinutes > 0) {
            maxValue = max([
              maxValue,
              depthFirstSearch(DFSState(
                    minutes: remainingMinutes,
                    bitMask: state.bitMask | bit, // open the valve
                    currentValve: neighbor,
                  )) +
                  neighbor.rate * remainingMinutes,
            ])!;
          }
        }
      });

      cache[state] = maxValue;
      return maxValue;
    }

    final initialState = DFSState(minutes: 30, bitMask: 0, currentValve: AAValve);
    return depthFirstSearch(initialState);
  }

  @override
  int solvePart2() {
    final valves = parseInput();
    final valveMap = valves.asMap().map((key, value) => MapEntry(value.name, value));
    final graph = Graph(valves: valveMap);

    // connect neighbors
    for (var valve in valves) {
      for (var neighborName in valve.valvesToNames) {
        graph.addEdge(valve.name, graph.valves[neighborName]!);
        // graph.addEdge(neighborName, valve);
      }
    }
    List<Valve> nonEmpty = [];

    final AAValve = valves.where((e) => e.name == 'AA').first;

    Map<Valve, Map<Valve, int>> distances = {};
    // find shortest distance of non empty valves to every other non empty valve
    for (var valve in valves) {
      List<Valve> visitedValves = [];
      // skip valves with flow rate 0
      if (valve.name != 'AA' && valve.rate == 0) {
        continue;
      }

      if (valve.name != 'AA') {
        nonEmpty.add(valve);
      }

      distances[valve] = {valve: 0, AAValve: 0};
      visitedValves.add(valve);

      final queue = QueueList<Tuple2<int, Valve>>();
      queue.add(Tuple2(0, valve));

      while (queue.isNotEmpty) {
        final currentValveDistancePair = queue.removeFirst();
        final currentDistance = currentValveDistancePair.item1;
        final currentValve = currentValveDistancePair.item2;

        for (var neighbor in currentValve.neighbors) {
          if (!visitedValves.contains(neighbor)) {
            visitedValves.add(neighbor);
            if (neighbor.rate > 0) {
              distances[valve]![neighbor] = currentDistance + 1;
            }
            queue.add(Tuple2(currentDistance + 1, neighbor));
          }
        }
      }
      // remove self-valve and distance to AA valve
      distances[valve]!.removeWhere((key, value) => key == valve);
      if (valve != AAValve) {
        distances[valve]!.removeWhere((key, value) => key == AAValve);
      }
    }
    // map non-empty valves to indices to be used by bitmask
    Map<Valve, int> indices = {};
    nonEmpty.forEachIndexed((index, element) {
      indices[element] = index;
    });

    // use memoization to optimize DFS
    Map<DFSState, int> cache = {};

    int depthFirstSearch(DFSState state) {
      int maxValue = 0;
      if (cache.containsKey(state)) {
        return cache[state]!;
      }

      distances[state.currentValve]!.forEach((neighbor, distance) {
        // left shift the neighbor index to check if it's closed
        final bit = 1 << indices[neighbor]!;
        if (state.bitMask & bit == 0) {
          final remainingMinutes = state.minutes - distances[state.currentValve]![neighbor]! - 1;

          if (remainingMinutes > 0) {
            maxValue = max([
              maxValue,
              depthFirstSearch(DFSState(
                    minutes: remainingMinutes,
                    bitMask: state.bitMask | bit, // open the valve
                    currentValve: neighbor,
                  )) +
                  neighbor.rate * remainingMinutes,
            ])!;
          }
        }
      });

      cache[state] = maxValue;
      return maxValue;
    }

    final allValvesOpenValue = (1 << nonEmpty.length) - 1;

    int maximum = 0;
    // bruteforce to check what two combinations of open & closed valves will give the maximum pressure released
    for (var i in range(0, (allValvesOpenValue + 1) ~/ 2)) {
      // elephant valves
      final elephantBitmask = i as int;
      // user valves are valves the elephant has closed. So we XOR
      final userBitmask = elephantBitmask ^ allValvesOpenValue;
      final elephantState = DFSState(minutes: 26, bitMask: elephantBitmask, currentValve: AAValve);
      final userState = DFSState(minutes: 26, bitMask: userBitmask, currentValve: AAValve);

      maximum = max([maximum, (depthFirstSearch(elephantState) + depthFirstSearch(userState))])!;
    }

    return maximum;
  }
}
