import 'package:darts_counter/features/x01/domain/models/points_model.dart';

class PlayerModel {
  final String name;
  final int score;
  final List<Points> currentRoundPoints;
  final bool isInGame;
  final int
  entryShotIndex; // Индекс броска, которым игрок вошел в игру (-1 если еще не вошел)
  final int startOfTurnScore; // Счет в начале хода

  const PlayerModel(
    this.name, {
    required this.score,
    this.currentRoundPoints = const [
      EmptyPoints(),
      EmptyPoints(),
      EmptyPoints(),
    ],
    this.isInGame = false,
    this.entryShotIndex = -1,
    required this.startOfTurnScore,
  });

  PlayerModel copyWith({
    String? name,
    int? score,
    List<Points>? currentRoundPoints,
    bool? isInGame,
    int? entryShotIndex,
    int? startOfTurnScore,
  }) {
    return PlayerModel(
      name ?? this.name,
      score: score ?? this.score,
      currentRoundPoints: currentRoundPoints ?? this.currentRoundPoints,
      isInGame: isInGame ?? this.isInGame,
      entryShotIndex: entryShotIndex ?? this.entryShotIndex,
      startOfTurnScore: startOfTurnScore ?? this.startOfTurnScore,
    );
  }
}
