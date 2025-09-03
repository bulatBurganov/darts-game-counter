import 'package:darts_counter/features/x01/domain/models/x01_settings_model.dart';

import '../models/player_model.dart';

enum GameStatus { playing, finished }

class GameState {
  final List<PlayerModel> players;
  final int currentPlayerIndex;
  final int currentShot;
  final int currentRound;
  final GameStatus status;
  final String? winner;
  final X01GameSettingsModel settings;

  const GameState({
    required this.players,
    required this.currentPlayerIndex,
    required this.currentShot,
    required this.currentRound,
    this.status = GameStatus.playing,
    this.winner,
    required this.settings,
  });

  GameState copyWith({
    List<PlayerModel>? players,
    int? currentPlayerIndex,
    int? currentShot,
    int? currentRound,
    GameStatus? status,
    String? winner,
    X01GameSettingsModel? settings,
  }) {
    return GameState(
      players: players ?? this.players,
      currentPlayerIndex: currentPlayerIndex ?? this.currentPlayerIndex,
      currentShot: currentShot ?? this.currentShot,
      currentRound: currentRound ?? this.currentRound,
      status: status ?? this.status,
      winner: winner ?? this.winner,
      settings: settings ?? this.settings,
    );
  }
}
