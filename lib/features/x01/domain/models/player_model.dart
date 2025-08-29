import 'package:darts_counter/features/x01/domain/models/points_model.dart';

class PlayerModel {
  final String name;
  final int score;
  final List<Points> currentRoundPoints;

  PlayerModel(
    this.name, {
    this.score = 301,
    this.currentRoundPoints = const [
      EmptyPoints(),
      EmptyPoints(),
      EmptyPoints(),
    ],
  });

  PlayerModel copyWith({int? score, List<Points>? currentRoundPoints}) =>
      PlayerModel(
        name,
        score: score ?? this.score,
        currentRoundPoints: currentRoundPoints ?? this.currentRoundPoints,
      );
}
