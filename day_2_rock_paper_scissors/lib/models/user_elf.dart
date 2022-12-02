import 'package:day_2_rock_paper_scissors/models/models.dart';

class UserElf extends PlayerElf {
  /// {Part-2} Make Move according to opponents character
  void makeMove(String character, Move opponentMove) {
    switch (character) {
      case 'X': // lose
        switch (opponentMove) {
          case Move.rock:
            move = Move.scissors;
            break;
          case Move.paper:
            move = Move.rock;
            break;
          case Move.scissors:
            move = Move.paper;
            break;
        }
        break;
      case 'Y': // draw
        move = opponentMove;
        break;
      case 'Z': // win
        switch (opponentMove) {
          case Move.rock:
            move = Move.paper;
            break;
          case Move.paper:
            move = Move.scissors;
            break;
          case Move.scissors:
            move = Move.rock;
            break;
        }
        break;
    }
    madeMove = true;
  }
}
