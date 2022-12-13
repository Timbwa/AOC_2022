import 'package:equatable/equatable.dart';

import '../utils/index.dart';

const MAX_COST = 999999999999;

class Node extends Equatable {
  Node({
    this.parentNode,
    this.gCost = MAX_COST,
    this.distance = 0,
    required this.character,
  });

  factory Node.fromCharacter(String character) => Node(character: character);

  /// Actual Path Cost
  int gCost;

  /// Heuristic Cost [ManhattanDistance]
  int distance;
  String character;
  Node? parentNode;
  late Position position;

  @override
  List<Object?> get props => [position];

  int get x => position.x;

  int get y => position.y;

  int get height => character.codeUnitAt(0);

  @override
  String toString() {
    return '[$character] $position ($distance)|';
  }

  int characterDistance(Node other) {
    return (height - other.height);
  }
}

class Day12 extends GenericDay {
  Day12() : super(12);

  @override
  Field<Node> parseInput() {
    final lines = input.getPerLine();
    final elevations = lines.map((e) => e.split('')).toList();
    final heightMapCharacters = Field<String>(elevations);

    final heightMapNodes = heightMapCharacters.field.map((e) => e.map(Node.fromCharacter).toList()).toList();
    final heightMap = Field(heightMapNodes);

    // set positions
    heightMap.forEachWithPosition((e, p0, p1) {
      e.position = Position(p0, p1);
    });

    return heightMap;
  }

  int findShortestPathBFS(Node startNode, Node goalNode, Field<Node> heightMap, {bool p1 = true}) {
    final visitedNodes = <Node>{};
    final queue = QueueList<Node>();

    queue.add(startNode);
    visitedNodes.add(startNode);

    while (queue.isNotEmpty) {
      final currentNode = queue.removeFirst();
      final neighbors = heightMap.adjacent(currentNode.x, currentNode.y);
      for (var neighbor in neighbors) {
        final neighborNode = heightMap.getValueAtPosition(neighbor);
        if (visitedNodes.contains(neighborNode)) {
          continue;
        }
        if (((neighborNode.characterDistance(currentNode) > 1) && p1) ||
            ((neighborNode.characterDistance(currentNode) < -1) && !p1)) {
          continue;
        }
        if (((neighborNode == goalNode) && p1) || ((neighborNode.character == 'a') && !p1)) {
          return currentNode.distance + 1;
        }
        neighborNode.distance = currentNode.distance + 1;
        visitedNodes.add(neighborNode);
        queue.addLast(neighborNode);
      }
    }

    throw Exception('No path found');
  }

  @override
  int solvePart1() {
    final heightMap = parseInput();

    final goalNode = heightMap.getValueBy((element) => element.character == 'E');
    final startNode = heightMap.getValueBy((element) => element.character == 'S');
    goalNode.character = 'z';
    startNode.character = 'a';

    final shortestPathDistance = findShortestPathBFS(startNode, goalNode, heightMap);

    return shortestPathDistance;
  }

  @override
  int solvePart2() {
    final heightMap = parseInput();

    final goalNode = heightMap.getValueBy((element) => element.character == 'E');
    final startNode = heightMap.getValueBy((element) => element.character == 'S');
    goalNode.character = 'z';
    startNode.character = 'a';

    // starting from goal node backwards
    return findShortestPathBFS(goalNode, startNode, heightMap, p1: false);
  }
}
