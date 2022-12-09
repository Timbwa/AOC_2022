import '../utils/index.dart';

class Knot {
  Position position;

  Knot(this.position);

  @override
  String toString() {
    return 'Knot{position: $position}';
  }

  void moveUp([int step = 1]) {
    position = position.withItem2(position.y - step);
  }

  void moveDown([int step = 1]) {
    position = position.withItem2(position.y + step);
  }

  void moveRight([int step = 1]) {
    position = position.withItem1(position.x + step);
  }

  void moveLeft([int step = 1]) {
    position = position.withItem1(position.x - step);
  }

  bool isDiagonalRelativeTo(Knot other) {
    return (position.x != other.position.x && position.y != other.position.y);
  }

  bool isAbove(Knot other) {
    return position.y < other.position.y;
  }

  bool isBelow(Knot other) {
    return position.y > other.position.y;
  }

  bool isRightOf(Knot other) {
    return position.x > other.position.x;
  }

  bool isLeftOf(Knot other) {
    return position.x < other.position.x;
  }

  bool isTwoStepAway(Knot other) {
    return ((position.x - other.position.x).abs() > 1) || ((position.y - other.position.y).abs() > 1);
  }

  void moveDiagonalRightUp([int step = 1]) {
    moveRight(step);
    moveUp(step);
  }

  void moveDiagonalRightDown([int step = 1]) {
    moveRight(step);
    moveDown(step);
  }

  void moveDiagonalLeftUp([int step = 1]) {
    moveLeft(step);
    moveUp(step);
  }

  void moveDiagonalLeftDown([int step = 1]) {
    moveLeft(step);
    moveDown(step);
  }

  void resolvePositionOfKnotPair(Knot thisKnot, Knot otherKnot) {
    if (thisKnot.isDiagonalRelativeTo(otherKnot)) {
      if (!thisKnot.isTwoStepAway(otherKnot)) {
        return;
      }

      if (thisKnot.isRightOf(otherKnot) && thisKnot.isAbove(otherKnot)) {
        otherKnot.moveDiagonalRightUp();
      } else if (thisKnot.isRightOf(otherKnot) && thisKnot.isBelow(otherKnot)) {
        otherKnot.moveDiagonalRightDown();
      } else if (thisKnot.isLeftOf(otherKnot) && thisKnot.isAbove(otherKnot)) {
        otherKnot.moveDiagonalLeftUp();
      } else if (thisKnot.isLeftOf(otherKnot) && thisKnot.isBelow(otherKnot)) {
        otherKnot.moveDiagonalLeftDown();
      }
    } else {
      if (!thisKnot.isTwoStepAway(otherKnot)) {
        return;
      }
      if (thisKnot.isRightOf(otherKnot)) {
        otherKnot.moveRight();
      } else if (thisKnot.isLeftOf(otherKnot)) {
        otherKnot.moveLeft();
      } else if (thisKnot.isAbove(otherKnot)) {
        otherKnot.moveUp();
      } else if (thisKnot.isBelow(otherKnot)) {
        otherKnot.moveDown();
      }
    }
  }
}

class Head extends Knot {
  Head(super.position, {int numberOfTails = 9}) : tails = List.generate(numberOfTails, (index) => Tail(position));
  List<Tail> tails;

  void resolveTailPositions() {
    late Knot head;
    late Tail tail;
    for (var i = 0; i < tails.length; i++) {
      if (i == 0) {
        head = this;
        tail = tails[i];
      } else {
        head = tail;
        tail = tails[i];
      }

      resolvePositionOfKnotPair(head, tail);
    }
  }
}

class Tail extends Knot {
  Tail(super.position);
}

class Day09 extends GenericDay {
  Day09() : super(9);

  @override
  Iterable<Tuple2<String, int>> parseInput() {
    final lines = input.getPerLine();
    return lines.map((e) => Tuple2(e.split(' ')[0], int.parse(e.split(' ')[1])));
  }

  @override
  int solvePart1() {
    final headSteps = parseInput();

    final head = Head(Tuple2(0, 0), numberOfTails: 1);

    Set<Position> tailPositions = {};

    for (var headStep in headSteps) {
      final move = headStep.item1;
      final steps = headStep.item2;

      if (move == 'R') {
        for (var step = 0; step < steps;) {
          head.moveRight();
          head.resolveTailPositions();
          tailPositions.add(head.tails.last.position);
          step++;
        }
      } else if (move == 'L') {
        for (var step = 0; step < steps;) {
          head.moveLeft();
          head.resolveTailPositions();
          tailPositions.add(head.tails.last.position);
          step++;
        }
      } else if (move == 'U') {
        for (var step = 0; step < steps;) {
          head.moveUp();
          head.resolveTailPositions();
          tailPositions.add(head.tails.last.position);
          step++;
        }
      } else if (move == 'D') {
        for (var step = 0; step < steps;) {
          head.moveDown();
          head.resolveTailPositions();
          tailPositions.add(head.tails.last.position);
          step++;
        }
      }
    }

    return tailPositions.length;
  }

  @override
  int solvePart2() {
    final headSteps = parseInput();

    final head = Head(Tuple2(0, 0));

    Set<Position> tailPositions = {};

    for (var headStep in headSteps) {
      final move = headStep.item1;
      final steps = headStep.item2;

      if (move == 'R') {
        for (var step = 0; step < steps;) {
          head.moveRight();
          head.resolveTailPositions();
          tailPositions.add(head.tails.last.position);
          step++;
        }
      } else if (move == 'L') {
        for (var step = 0; step < steps;) {
          head.moveLeft();
          head.resolveTailPositions();
          tailPositions.add(head.tails.last.position);
          step++;
        }
      } else if (move == 'U') {
        for (var step = 0; step < steps;) {
          head.moveUp();
          head.resolveTailPositions();
          tailPositions.add(head.tails.last.position);
          step++;
        }
      } else if (move == 'D') {
        for (var step = 0; step < steps;) {
          head.moveDown();
          head.resolveTailPositions();
          tailPositions.add(head.tails.last.position);
          step++;
        }
      }
    }
    return tailPositions.length;
  }
}
