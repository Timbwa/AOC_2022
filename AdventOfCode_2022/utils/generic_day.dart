import 'input_util.dart';

/// Provides the [InputUtil] for given day and a [printSolution] method to show
/// the puzzle solutions for given day.
abstract class GenericDay {
  final int day;
  final InputUtil input;

  GenericDay(int day, {InputUtil? inputUtil})
      : day = day,
        input = inputUtil ?? InputUtil(day);

  dynamic parseInput();
  int solvePart1();
  int solvePart2();

  void printSolutions() {
    print("-------------------------");
    print("         Day $day        ");
    final stopWatch = Stopwatch()..start();

    final part1Solution = solvePart1();
    stopWatch.stop();
    final part1ElapsedTime = stopWatch.elapsedMilliseconds;
    print("Solution for puzzle one: $part1Solution. Completed in $part1ElapsedTime ms");

    stopWatch.reset();
    stopWatch.start();

    final part2Solution = solvePart2();
    stopWatch.stop();
    final part2ElapsedTime = stopWatch.elapsedMilliseconds;
    print("Solution for puzzle two: $part2Solution. Completed in $part2ElapsedTime ms");
    print("\n");
  }
}
