import '../utils/index.dart';

class Operation {
  const Operation({
    required this.operand1,
    required this.operand2,
    required this.operation,
  });

  final int operand1;
  final int operand2;
  final String operation;

  factory Operation.fromLine(String line, int old) {
    final operation = line.trim().split(' ')[4];
    final operand2String = line.trim().split(' ')[5];
    final operand1 = old;
    late final int operand2;
    if (operand2String == 'old') {
      operand2 = old;
    } else {
      operand2 = int.parse(operand2String);
    }

    return Operation(
      operand1: operand1,
      operand2: operand2,
      operation: operation,
    );
  }

  @override
  String toString() {
    return '$operand1 $operation $operand2';
  }

  int getResult() {
    switch (operation) {
      case '+':
        return operand1 + operand2;
      case '*':
        return operand1 * operand2;
    }
    throw Exception('operation not supported');
  }
}

class Test {
  const Test({
    required this.divisor,
    required this.monkeyToThrowToWhenTrue,
    required this.monkeyToThrowToWhenFalse,
  });

  factory Test.fromTestLines(List<String> lines) {
    final divisor = int.parse(lines[0].trim().split(' ').last);
    final monkeyToThrowToWhenTrue = int.parse(lines[1].trim().split(' ').last);
    final monkeyToThrowToWhenFalse = int.parse(lines[2].trim().split(' ').last);

    return Test(
      divisor: divisor,
      monkeyToThrowToWhenTrue: monkeyToThrowToWhenTrue,
      monkeyToThrowToWhenFalse: monkeyToThrowToWhenFalse,
    );
  }

  final int divisor;
  final int monkeyToThrowToWhenTrue;
  final int monkeyToThrowToWhenFalse;

  void execute(int operationResult, List<Monkey> monkeys) {
    if ((operationResult % divisor) == 0) {
      monkeys[monkeyToThrowToWhenTrue].startingItems.addLast(operationResult);
    } else {
      monkeys[monkeyToThrowToWhenFalse].startingItems.addLast(operationResult);
    }
  }
}

class Monkey implements Comparable<Monkey> {
  final QueueList<int> startingItems;
  int inspectionTimes;
  final Test test;
  final String name;
  final String operationString;

  Monkey({
    required this.startingItems,
    this.inspectionTimes = 0,
    required this.test,
    required this.name,
    required this.operationString,
  });

  factory Monkey.fromMonkeyBehaviour(List<String> monkeyBehaviour) {
    final name = monkeyBehaviour[0];
    final items = monkeyBehaviour[1].trim().substring(15).split(', ').map((e) => int.parse(e)).toList();
    final test = Test.fromTestLines(monkeyBehaviour.sublist(3));

    return Monkey(
      startingItems: QueueList.from(items),
      test: test,
      name: name,
      operationString: monkeyBehaviour[2],
    );
  }

  void inspectItems(List<Monkey> monkeys, {bool areRelieved = true, int lcm = 1}) {
    final startingItemsLength = startingItems.length;

    for (var i = 0; i < startingItemsLength; i++) {
      final old = startingItems.removeFirst();
      final operation = Operation.fromLine(operationString, old);
      final result = operation.getResult();
      final worryLevel = areRelieved ? result ~/ 3 : result % lcm;
      test.execute(worryLevel, monkeys);
      inspectionTimes++;
    }
  }

  @override
  String toString() {
    return '$name inspected items $inspectionTimes times';
  }

  @override
  int compareTo(Monkey other) {
    return inspectionTimes.compareTo(other.inspectionTimes);
  }
}

class Day11 extends GenericDay {
  Day11() : super(11);

  @override
  Map<int, List<String>> parseInput() {
    final lines = input.getPerLine();
    var index = 0;
    final monkeyBehaviours = lines.groupListsBy((e) => e == '' ? index++ : index);

    monkeyBehaviours.forEach((key, value) {
      value.length == 7 ? value.removeLast() : null;
    });

    return monkeyBehaviours;
  }

  @override
  int solvePart1() {
    final monkeyBehaviours = parseInput();
    final monkeys = <Monkey>[];

    monkeyBehaviours.forEach((key, behaviour) {
      final monkey = Monkey.fromMonkeyBehaviour(behaviour);
      monkeys.add(monkey);
    });

    final int numberOfRounds = 20;

    for (var i = 0; i < numberOfRounds; i++) {
      for (var monkey in monkeys) {
        monkey.inspectItems(monkeys);
      }
    }

    monkeys.sort();
    final monkeyBusiness = monkeys.last.inspectionTimes * monkeys[monkeys.length - 2].inspectionTimes;

    return monkeyBusiness;
  }

  @override
  int solvePart2() {
    final monkeyBehaviours = parseInput();
    final monkeys = <Monkey>[];

    monkeyBehaviours.forEach((key, behaviour) {
      final monkey = Monkey.fromMonkeyBehaviour(behaviour);
      monkeys.add(monkey);
    });

    final int numberOfRounds = 10000;

    int gcd(int a, int b) => a.gcd(b);

    final lcmOfDivisors = monkeys.map((e) => e.test.divisor).reduce((int a, int b) {
      return (a * b) ~/ gcd(a, b);
    });

    for (var i = 1; i <= numberOfRounds; i++) {
      for (var monkey in monkeys) {
        monkey.inspectItems(monkeys, areRelieved: false, lcm: lcmOfDivisors);
      }
      if (i == 1 || i == 20 || i % 1000 == 0) {
        print('\n== After round $i ==');
        monkeys.forEach(print);
      }
    }

    monkeys.sort();
    final monkeyBusiness = monkeys.last.inspectionTimes * monkeys[monkeys.length - 2].inspectionTimes;

    return monkeyBusiness;
  }
}
