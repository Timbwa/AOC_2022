import 'package:args/args.dart';
import 'package:day_1/day_1.dart';

Future<void> main(List<String> arguments) async {
  final parser = ArgParser()
    ..addOption(
      'filename',
      abbr: 'f',
      help: 'Input file',
      mandatory: true,
    );

  final results = parser.parse(arguments);
  final filename = results['filename'];

  final elves = await parseAndConvertInputToElves(filename);
  final topElfCalories = getTopElfCalories(elves);

  print('Top Elf Calories: $topElfCalories');
}
