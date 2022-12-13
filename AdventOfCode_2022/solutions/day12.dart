import 'package:equatable/equatable.dart';

import '../utils/index.dart';

const MAX_COST = 999999999999;

class Node extends Equatable implements Comparable<Node> {
  Node({
    this.parentNode,
    this.gCost = MAX_COST,
    this.hCost = 0,
    required this.character,
  });

  factory Node.fromCharacter(String character) => Node(character: character);

  /// Actual Path Cost
  int gCost;

  /// Heuristic Cost [ManhattanDistance]
  int hCost;
  String character;
  Node? parentNode;
  late Position position;

  @override
  List<Object?> get props => [position];

  int get totalCost => gCost + hCost;
  int get height => character == 'E' ? 'z'.codeUnitAt(0) - 96 : character.codeUnitAt(0) - 96;

  bool get isGoalNode => character == 'E' && (parentNode != null && parentNode!.character == 'z');

  @override
  String toString() {
    return '[$character] $position (${hCost})|';
  }

  @override
  int compareTo(Node other) {
    return totalCost.compareTo(other.totalCost);
  }

  int characterDistance(Node other) {
    if (character == 'S' || (other.character == 'E' && this.character == 'z')) {
      return 1;
    }
    return (height - other.height).abs();
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

  @override
  int solvePart1() {
    final heightMap = parseInput();

    final goalNode = heightMap.getValueBy((element) => element.character == 'E');
    final startNode = heightMap.getValueBy((element) => element.character == 'S');

    print(heightMap);
    final val = solveAStar(heightMap, startNode, goalNode);
    reconstructPath(startNode, goalNode);
    print(heightMap);
    return val;
  }

  int manhattanHeuristic(Node startNode, Node endNode) {
    return (startNode.position.x - endNode.position.x).abs() + (startNode.position.y - endNode.position.y).abs();
  }

  void reconstructPath(Node startNode, Node goalNode) {
    final totalPath = QueueList<Node?>();
    totalPath.addLast(goalNode);
    Node? currentNode = goalNode.parentNode;
    while (currentNode?.parentNode != null) {
      totalPath.addFirst(currentNode);
      currentNode = currentNode?.parentNode;
    }
    totalPath.addFirst(currentNode);
    print(totalPath);
    print(totalPath.length);
  }

  int solveAStar(Field<Node> heightMap, Node startNode, Node goalNode) {
    /// Path
    List<Tuple3<Node, Node, int>> path = [];

    /// visited nodes
    List<Node> closedSet = [];
    HeapPriorityQueue<Node> fringe = HeapPriorityQueue<Node>();

    startNode.gCost = 0;
    startNode.hCost = manhattanHeuristic(startNode, goalNode);

    fringe.add(startNode);

    while (fringe.isNotEmpty) {
      final currentVertex = fringe.removeFirst();
      closedSet.add(currentVertex);

      if (currentVertex.isGoalNode) {
        print('Reached Goal');
        path.add(Tuple3(startNode, goalNode, goalNode.gCost));
        return goalNode.gCost;
      }

      final neighborPositions = heightMap.adjacent(currentVertex.position.x, currentVertex.position.y);
      for (var neighborPosition in neighborPositions) {
        final neighbor = heightMap.getValueAtPosition(neighborPosition);

        if (!closedSet.contains(neighbor)) {
          final tempGCost = currentVertex.gCost + 1;
          if (tempGCost < neighbor.gCost &&
              ((currentVertex.characterDistance(neighbor) <= 1) || (neighbor.height <= currentVertex.height))) {
            neighbor.parentNode = currentVertex;
            neighbor.gCost = tempGCost;
            neighbor.hCost = manhattanHeuristic(neighbor, goalNode);

            if (!fringe.contains(neighbor)) {
              fringe.add(neighbor);
            }
          }
        }
      }
    }

    throw Exception("No solution");
  }

  @override
  int solvePart2() {
    return 0;
  }
}
