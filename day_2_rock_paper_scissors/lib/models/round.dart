import 'dart:io';

import 'package:day_2_rock_paper_scissors/models/models.dart';

class Round {
  Round({
    required this.number,
    this.userElfScore = 0,
    this.opponentElfScore = 0,
    this.winningElf,
    this.userMove,
    this.opponentMove,
  });

  final int number;
  int userElfScore;
  int opponentElfScore;
  PlayerElf? winningElf;
  Move? userMove;
  Move? opponentMove;

  @override
  String toString() {
    return '=== ROUND $number ===\n'
        'UserMove: $userMove\n'
        'OpponentMove: $opponentMove\n'
        'UserElf(You) Score: $userElfScore\n'
        'Opponent Score:     $opponentElfScore\n'
        'Winning Elf: ${winningElf.runtimeType}\n';
  }

  void playRound(UserElf userElf, OpponentElf opponentElf) {
    // ensure the elves have made their moves first
    if (!userElf.madeMove && !opponentElf.madeMove) {
      print('The elves have not played their moves yet');
      exit(2);
    }

    // determine win, draw or loss
    final userPlayerResult = userElf.getRoundResult(opponentElf);
    final opponentPlayerResult = opponentElf.getRoundResult(userElf);

    userMove = userElf.move;
    opponentMove = opponentElf.move;

    userElfScore = userPlayerResult.score + userElf.move.score;
    opponentElfScore = opponentPlayerResult.score + opponentElf.move.score;

    userElf.updateTotalScore(userElfScore);
    opponentElf.updateTotalScore(opponentElfScore);

    switch (userPlayerResult) {
      case PlayerRoundResult.win:
        winningElf = userElf;
        break;
      case PlayerRoundResult.draw:
        winningElf = null;
        break;
      case PlayerRoundResult.lose:
        winningElf = opponentElf;
        break;
    }
  }
}
