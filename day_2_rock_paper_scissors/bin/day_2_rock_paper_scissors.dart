import 'dart:io';

import 'package:args/args.dart';
import 'package:day_2_rock_paper_scissors/day_2_rock_paper_scissors.dart';

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

  final rounds = await parseAndConvertToRounds(filename);
  for (var round in rounds) {
    print(round);
  }

  final userTotalScore = await getUserTotalScore(rounds);
  final opponentTotalScore = await getOpponentTotalScore(rounds);

  print('User Score: $userTotalScore');
  print('Opponent Score: $opponentTotalScore');

  exit(0);
}
