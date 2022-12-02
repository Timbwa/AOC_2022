import 'package:day_2_rock_paper_scissors/models/models.dart';

class OpponentElf extends PlayerElf {
  /// Decrypts Player Moves by taking the [character] and translates it to the [Move]
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
