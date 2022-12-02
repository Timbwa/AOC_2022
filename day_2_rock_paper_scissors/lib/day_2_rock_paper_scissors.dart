import 'dart:convert';
import 'dart:io';

import 'package:day_2_rock_paper_scissors/models/models.dart';

Future<List<Round>> parseAndConvertToRounds(String filename) async {
  final lines = utf8.decoder.bind(File(filename).openRead()).transform(const LineSplitter());

  try {
    var index = 0;
    List<Round> rounds = [];

    final userElf = UserElf();
    final opponentElf = OpponentElf();

    await for (final line in lines) {
      final userCharacter = line[2];
      final opponentCharacter = line[0];

      final round = Round(number: index++);

      userElf.makeMove(userCharacter);
      opponentElf.makeMove(opponentCharacter);

      // calculates round result and score
      round.playRound(userElf, opponentElf);

      rounds.add(round);
    }

    return rounds;
  } catch (_) {
    stderr.writeln('Could not read file. Error: $_');
    exit(2);
  }
}

Future<int> getUserTotalScore(List<Round> rounds) async {
  final totalUserScore = rounds.fold<int>(0, (previousValue, round) {
    return previousValue + round.userElfScore;
  });

  return totalUserScore;
}

Future<int> getOpponentTotalScore(List<Round> rounds) async {
  final totalUserScore = rounds.fold<int>(0, (previousValue, round) {
    return previousValue + round.opponentElfScore;
  });

  return totalUserScore;
}
