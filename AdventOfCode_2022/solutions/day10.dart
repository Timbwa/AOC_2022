import '../utils/index.dart';

typedef Register = int;
typedef Instructions = List<String>;
typedef Instruction = String;

class CRT {
  CRT();

  int crtPosition = 0;
  int crtRowIndex = 0;
  String crtOutput = '';
  Map<int, String> rows = {};

  void updateOutput(Register x) {
    final spriteRange = <int>[x - 1, x, x + 1];

    if (crtOutput.length % 40 == 0) {
      crtOutput = '';
      crtRowIndex = 0;
    }
    if (spriteRange.contains(crtRowIndex)) {
      crtOutput = '$crtOutput#';
      rows[crtPosition ~/ 40] = crtOutput;
    } else {
      crtOutput = '$crtOutput ';
      rows[crtPosition ~/ 40] = crtOutput;
    }

    crtPosition++;
    crtRowIndex++;
  }

  void display() {
    rows.forEach((key, value) {
      print(value);
    });
  }
}

class CPU {
  CPU(
    this.totalCycles,
    this.instructions, {
    this.crt,
  });

  Register x = 1;
  int totalCycles;
  int cycleCount = 0;
  int instructionIndex = 0;
  Instructions instructions;
  CRT? crt;

  Map<int, int> cycleValues = {
    20: 0,
    60: 0,
    100: 0,
    140: 0,
    180: 0,
    220: 0,
  };

  Map<String, int> instructionCycleCount = {};

  void executeInstructions() {
    int cycleCount = 0;

    while ((cycleCount < totalCycles) && (instructionIndex < instructions.length)) {
      final instruction = instructions[instructionIndex].split(' ');

      crt?.updateOutput(x);

      if (instruction.length == 1) {
        noop();
      } else {
        if (!instructionCycleCount.containsKey('${instructionIndex}_${instruction}')) {
          instructionCycleCount['${instructionIndex}_$instruction'] = 1;
          addx(isFirstCycle: true);
        } else {
          instructionCycleCount['${instructionIndex}_$instruction'] = 2;
          final value = int.parse(instruction[1]);
          addx(isFirstCycle: false, value: value);
        }
      }
      updateCycleValuesOfInterest();
    }
  }

  void noop() {
    instructionIndex++;
    cycleCount++;
  }

  void addx({bool isFirstCycle = true, int value = 0}) {
    if (!isFirstCycle) {
      x += value;
      instructionIndex++;
    }
    cycleCount++;
  }

  void updateCycleValuesOfInterest() {
    if (cycleValues.containsKey(cycleCount + 1)) {
      cycleValues[cycleCount + 1] = (cycleCount + 1) * x;
    }
  }

  int get cycleValuesTotal => cycleValues.values.fold(0, (previousValue, element) => previousValue + element);
}

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

    final cpu = CPU(totalCycles, instructions);
    cpu.executeInstructions();

    return cpu.cycleValuesTotal;
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

    final crt = CRT();
    final cpu = CPU(totalCycles, instructions, crt: crt);

    cpu.executeInstructions();
    crt.display();

    return 0;
  }
}
