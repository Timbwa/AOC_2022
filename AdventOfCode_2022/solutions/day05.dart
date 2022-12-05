import 'package:stack/stack.dart';

import '../utils/index.dart';

class Operation {
  List<Stack<String>> stacks;
  Iterable<Move> moves;

  Operation({
    required this.stacks,
    required this.moves,
  });
}

class Move {
  int amount;
  int source;
  int destination;

  Move({
    required this.amount,
    required this.source,
    required this.destination,
  });

  @override
  String toString() {
    return 'Move{amount: $amount, source: $source, destination: $destination}';
  }
}

class Day05 extends GenericDay {
  Day05() : super(5);

  @override
  Operation parseInput() {
    final int range = isTest ? 4 : 8;
    final int maxChar = isTest ? 11 : 35;
    final int totalStacks = isTest ? 3 : 9;
    final int moveStartIndex = isTest ? 5 : 10;

    final lines = input.getPerLine();
    var filtered = lines.getRange(0, range);
    List<List<String>> stacks = List.generate(totalStacks, (index) => <String>[]);

    filtered.forEach((element) {
      var splitInput = element.split('').toList();
      var index = 0;
      for (var x = 1; x < maxChar; x++) {
        if (x % 4 == 1 || x % 4 == 3) {
          if (splitInput[x] != ' ') {
            stacks[index].add(splitInput[x]);
          }
        }
        index = (x ~/ 4);
      }
    });

    final orderedStacks = stacks.map((e) {
      final ordered = e.reversed;
      final s = Stack<String>();
      ordered.forEach((element) {
        s.push(element);
      });
      return s;
    });

    final lineMoves = lines.getRange(moveStartIndex, lines.length);
    final moves = lineMoves.map((e) {
      final pattern = RegExp(r'[0-9]{1,3}');
      final digits = pattern.allMatches(e).toList();
      final move = Move(
        amount: int.parse(digits[0].group(0)!),
        source: int.parse(digits[1].group(0)!),
        destination: int.parse(digits[2].group(0)!),
      );

      pattern.allMatches(e);
      return move;
    });
    return Operation(
      stacks: orderedStacks.toList(),
      moves: moves,
    );
  }

  @override
  int solvePart1() {
    final operation = parseInput();

    for (var move in operation.moves) {
      final sourceStack = operation.stacks[move.source - 1];
      final destinationStack = operation.stacks[move.destination - 1];

      if (move.amount == 1) {
        destinationStack.push(sourceStack.pop());
      } else {
        List<String> popped = [];

        for (var x = 0; x < move.amount; x++) {
          popped.add(sourceStack.pop());
        }

        final reversed = popped.reversed;
        for (var char in reversed) {
          destinationStack.push(char);
        }
      }
    }

    for (var stack in operation.stacks) {
      print(stack.top());
    }

    return 0;
  }

  @override
  int solvePart2() {
    return 0;
  }
}
