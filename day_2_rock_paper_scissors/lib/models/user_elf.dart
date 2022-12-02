import 'package:day_2_rock_paper_scissors/models/models.dart';

class UserElf extends PlayerElf {
  @override
  void makeMove(String character) {
    switch (character) {
      case 'X':
        move = Move.rock;
        break;
      case 'Y':
        move = Move.paper;
        break;
      case 'Z':
        move = Move.scissors;
        break;
    }
    madeMove = true;
  }
}
