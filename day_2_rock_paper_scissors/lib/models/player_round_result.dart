enum PlayerRoundResult {
  win(score: 6),
  draw(score: 3),
  lose(score: 0);

  final int score;

  const PlayerRoundResult({required this.score});
}
