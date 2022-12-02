import 'package:day_2_rock_paper_scissors/models/models.dart';
import 'package:day_2_rock_paper_scissors/models/player_round_result.dart';

import 'move.dart';

abstract class PlayerElf {
  PlayerElf({
    this.totalScore = 0,
    this.move = Move.rock,
    this.madeMove = false,
    this.playerLastRoundResult = PlayerRoundResult.draw,
  });

  Move move;
  bool madeMove;
  int totalScore;
  PlayerRoundResult playerLastRoundResult;

  @override
  String toString() {
    return '$runtimeType: \n'
        'Last round result: $playerLastRoundResult\n'
        'Total Score: $totalScore\n';
  }

  void updateTotalScore(int score) {
    totalScore += score;
  }

  PlayerRoundResult getRoundResult(PlayerElf other) {
    switch (move) {
      case Move.rock:
        switch (other.move) {
          case Move.rock:
            return PlayerRoundResult.draw;
          case Move.paper:
            return PlayerRoundResult.lose;
          case Move.scissors:
            return PlayerRoundResult.win;
        }
      case Move.paper:
        switch (other.move) {
          case Move.rock:
            return PlayerRoundResult.win;
          case Move.paper:
            return PlayerRoundResult.draw;
          case Move.scissors:
            return PlayerRoundResult.lose;
        }
      case Move.scissors:
        switch (other.move) {
          case Move.rock:
            return PlayerRoundResult.lose;
          case Move.paper:
            return PlayerRoundResult.win;
          case Move.scissors:
            return PlayerRoundResult.draw;
        }
    }
  }
}
