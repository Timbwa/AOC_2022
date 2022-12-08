import '../utils/index.dart';

class Day08 extends GenericDay {
  Day08() : super(8);

  /// left, right, top, bottom
  Tuple4<List<int>, List<int>, List<int>, List<int>> getNeighborsToEdges(
    Field<String> matrix,
    int x,
    int y,
  ) {
    return Tuple4(
      matrix.getRow(y).map(int.parse).toList().sublist(0, x).reversed.toList(),
      matrix.getRow(y).map(int.parse).toList().sublist(x + 1, matrix.width),
      matrix.getColumn(x).map(int.parse).toList().sublist(0, y).reversed.toList(),
      matrix.getColumn(x).map(int.parse).toList().sublist(y + 1, matrix.height),
    );
  }

  bool isTreeVisible(
    Tuple4<List<int>, List<int>, List<int>, List<int>> treeNeighbors,
    int currentX,
    int currentY,
    int height,
  ) {
    final treesToLeftEdge = treeNeighbors.item1;
    final treesToRightEdge = treeNeighbors.item2;
    final treesToTopEdge = treeNeighbors.item3;
    final treesToBottomEdge = treeNeighbors.item4;

    return treesToLeftEdge.every((treeHeight) => treeHeight < height) ||
        treesToRightEdge.every((treeHeight) => treeHeight < height) ||
        treesToTopEdge.every((treeHeight) => treeHeight < height) ||
        treesToBottomEdge.every((treeHeight) => treeHeight < height);
  }

  @override
  Field<String> parseInput() {
    final lines = input.getPerLine();
    final trees = lines.map((e) => e.split('')).toList();
    final matrix = Field<String>(trees);

    return matrix;
  }

  int getTreeScore(List<int> trees, int treeHeight) {
    int score = 0;

    for (var tree in trees) {
      if (tree < treeHeight) {
        score++;
      } else {
        score++;
        break;
      }
    }

    return score;
  }

  @override
  int solvePart1() {
    final matrix = parseInput();

    int edgeCount = 0;
    int interiorCount = 0;

    matrix.forEach((x, y) {
      final currentHeight = int.parse(matrix.getValueAt(x, y));
      final neighbors = matrix.adjacent(x, y);

      if (neighbors.toList().length < 4) {
        edgeCount++;
      } else {
        final treeNeighbors = getNeighborsToEdges(matrix, x, y);

        if (isTreeVisible(treeNeighbors, x, y, currentHeight)) {
          interiorCount++;
        }
      }
    });

    return edgeCount + interiorCount;
  }

  @override
  int solvePart2() {
    final matrix = parseInput();
    Map<Tuple2<int, int>, int> treeScores = {};

    matrix.forEach((x, y) {
      final currentTreeHeight = int.parse(matrix.getValueAt(x, y));
      final neighbors = matrix.adjacent(x, y);
      int leftScore = 0;
      int topScore = 0;
      int rightScore = 0;
      int bottomScore = 0;

      if (neighbors.toList().length == 4) {
        final treeNeighbors = getNeighborsToEdges(matrix, x, y);
        final treesToLeftEdge = treeNeighbors.item1;
        final treesToRightEdge = treeNeighbors.item2;
        final treesToTopEdge = treeNeighbors.item3;
        final treesToBottomEdge = treeNeighbors.item4;

        leftScore = getTreeScore(treesToLeftEdge, currentTreeHeight);
        rightScore = getTreeScore(treesToRightEdge, currentTreeHeight);
        topScore = getTreeScore(treesToTopEdge, currentTreeHeight);
        bottomScore = getTreeScore(treesToBottomEdge, currentTreeHeight);

        final totalScore = leftScore * topScore * rightScore * bottomScore;
        treeScores.addAll({Tuple2(x, y): totalScore});
      }
    });

    return max(treeScores.values)!;
  }
}
