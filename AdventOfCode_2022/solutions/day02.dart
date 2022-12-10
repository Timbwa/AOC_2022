import 'dart:io';

import '../utils/index.dart';

class Day02 extends GenericDay {
  Day02() : super(2);

  @override
  List<String> parseInput() {
    return input.getPerLine();
  }

  @override
  int solvePart1() {
    final lines = parseInput();
    List<Round> rounds = [];

    int roundNumber = 0;

    final userElf = UserElf();
    final opponentElf = OpponentElf();

    for (var line in lines) {
      final userCharacter = line[2];
      final opponentCharacter = line[0];
      final round = Round(number: roundNumber++);

      opponentElf.makeMove(opponentCharacter);
      userElf.makeMove(userCharacter);

      round.playRound(userElf, opponentElf);

      rounds.add(round);
    }

    return rounds.fold<int>(0, (acc, round) => acc + round.userElfScore);
  }

  @override
  int solvePart2() {
    final lines = parseInput();
    List<Round> rounds = [];

    int roundNumber = 0;

    final userElf = UserElf();
    final opponentElf = OpponentElf();

    for (var line in lines) {
      final userCharacter = line[2];
      final opponentCharacter = line[0];
      final round = Round(number: roundNumber++);

      opponentElf.makeMove(opponentCharacter);
      userElf.makeMoveFromOpponentMove(userCharacter, opponentElf.move);

      round.playRound(userElf, opponentElf);

      rounds.add(round);
    }

    return rounds.fold<int>(0, (acc, round) => acc + round.userElfScore);
  }
}

enum Move {
  rock(score: 1),
  paper(score: 2),
  scissors(score: 3);

  final int score;

  const Move({
    required this.score,
  });
}

enum PlayerRoundResult {
  win(score: 6),
  draw(score: 3),
  lose(score: 0);

  final int score;

  const PlayerRoundResult({required this.score});
}

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

class UserElf extends PlayerElf {
  /// {Part-2} Make Move according to opponents character
  void makeMoveFromOpponentMove(String character, Move opponentMove) {
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
        'Winning Elf: ${winningElf?.runtimeType ?? 'Draw'}\n';
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
