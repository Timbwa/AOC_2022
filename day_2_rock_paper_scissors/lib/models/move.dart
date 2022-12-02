enum Move {
  rock(score: 1),
  paper(score: 2),
  scissors(score: 3);

  final int score;

  const Move({
    required this.score,
  });
}
