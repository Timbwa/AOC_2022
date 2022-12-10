import '../utils/index.dart';

class Day10 extends GenericDay {
  Day10() : super(10);

  @override
  List<String> parseInput() {
    final lines = input.getPerLine();
    return lines;
  }

  @override
  int solvePart1() {
    final instructions = parseInput();
    final totalCycles = instructions.fold(0, (acc, e) {
      final instruction = e.split(' ');
      if (instruction.length == 1) {
        return acc + 1;
      }
      return acc + 2;
    });

    int cycleCount = 0;
    int x = 1;
    int instructionIndex = 0;
    Map<String, int> instructionCycleCount = {};
    Map<int, int> cycleValues = {
      20: 0,
      60: 0,
      100: 0,
      140: 0,
      180: 0,
      220: 0,
    };

    int total = 0;

    while (cycleCount < totalCycles) {
      final instruction = instructions[instructionIndex].split(' ');
      if (instruction.length == 1) {
        instructionIndex++;
        cycleCount++;
      } else {
        if (!instructionCycleCount.containsKey('${instructionIndex}_${instruction}')) {
          instructionCycleCount['${instructionIndex}_$instruction'] = 1;
          cycleCount++;
        } else {
          instructionCycleCount['${instructionIndex}_$instruction'] = 2;
          x += int.parse(instruction[1]);
          instructionIndex++;
          cycleCount++;
        }
      }

      if (cycleValues.containsKey(cycleCount + 1)) {
        cycleValues[cycleCount + 1] = (cycleCount + 1) * x;
      }
    }

    total = cycleValues.values.fold(0, (previousValue, element) => previousValue + element);
    return total;
  }

  @override
  int solvePart2() {
    final instructions = parseInput();
    final totalCycles = instructions.fold(0, (acc, e) {
      final instruction = e.split(' ');
      if (instruction.length == 1) {
        return acc + 1;
      }
      return acc + 2;
    });

    int cycleCount = 0;
    int x = 1;
    int instructionIndex = 0;
    int crtPosition = 0;
    int crtRowIndex = 0;
    String crtOutput = '';

    Map<String, int> instructionCycleCount = {};
    Map<int, String> rows = {};

    while (cycleCount < totalCycles) {
      final instruction = instructions[instructionIndex].split(' ');
      final spriteRange = <int>[x - 1, x, x + 1];

      if (crtOutput.length % 40 == 0) {
        crtOutput = '';
        crtRowIndex = 0;
      }
      if (spriteRange.contains(crtRowIndex)) {
        crtOutput = '$crtOutput#';
        rows[crtPosition ~/ 40] = crtOutput;
      } else {
        crtOutput = '$crtOutput.';
        rows[crtPosition ~/ 40] = crtOutput;
      }

      crtPosition++;
      crtRowIndex++;

      if (instruction.length == 1) {
        instructionIndex++;
        cycleCount++;
      } else {
        if (!instructionCycleCount.containsKey('${instructionIndex}_${instruction}')) {
          instructionCycleCount['${instructionIndex}_$instruction'] = 1;
          cycleCount++;
        } else {
          instructionCycleCount['${instructionIndex}_$instruction'] = 2;
          x += int.parse(instruction[1]);
          instructionIndex++;
          cycleCount++;
        }
      }
    }

    rows.forEach((key, value) {
      print(value);
    });

    return 0;
  }
}
