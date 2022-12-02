import 'package:day_2_rock_paper_scissors/models/models.dart';

class OpponentElf extends PlayerElf {
  @override
  void makeMove(String character) {
    switch (character) {
      case 'A':
        move = Move.rock;
        break;
      case 'B':
        move = Move.paper;
        break;
      case 'C':
        move = Move.scissors;
        break;
    }
    madeMove = true;
  }
}
