import 'package:args/args.dart';
import 'package:day_3_rucksack_reorganization/day_3_rucksack_reorganization.dart';

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

  final lines = await parseInputToLines(filename);
  var sum = 0;

  for (var line in lines) {
    final commonCharacterPriority = getPriorityOfCommonItem(line);
    sum += commonCharacterPriority;
  }

  print(sum);
}
