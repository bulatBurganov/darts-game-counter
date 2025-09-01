import 'package:darts_counter/features/x01/domain/constants/x01_constants.dart';
import 'package:darts_counter/features/x01/domain/models/player_model.dart';
import 'package:darts_counter/features/x01/domain/models/points_model.dart';
import 'package:flutter/material.dart';

class X01ViewModel extends ChangeNotifier {
  static const int maxHistoryLength = 100;

  final List<GameState> _history = [];
  int _historyIndex = -1;

  List<PlayerModel> get players => _currentState.players;
  int get currentPlayerIndex => _currentState.currentPlayerIndex;
  int get currentShot => _currentState.currentShot;
  int get currentRound => _currentState.currentRound;
  bool get canUndo => _historyIndex > 0;

  GameState get _currentState => _history[_historyIndex];

  X01ViewModel() {
    _initNewGame();
  }

  void _initNewGame() {
    final initialState = GameState(
      players: [PlayerModel('Player 1'), PlayerModel('Player 2')],
      currentPlayerIndex: 0,
      currentShot: 0,
      currentRound: 1,
    );

    _history.add(initialState);
    _historyIndex = 0;
  }

  Future<void> addPoints(Points points) async {
    final currentState = _currentState;

    final newPlayers = currentState.players.map((p) => p.copyWith()).toList();
    final currentPlayer = newPlayers[currentState.currentPlayerIndex];

    final p = switch (points) {
      RegularPoints() => points.value,
      DoublePoints() => points.value * 2,
      TriplePoints() => points.value * 3,
      EmptyPoints() => 0,
    };

    var newRoundPoints = [...currentPlayer.currentRoundPoints];
    newRoundPoints[currentState.currentShot] = points;

    newPlayers[currentState.currentPlayerIndex] = currentPlayer.copyWith(
      score: currentPlayer.score - p,
      currentRoundPoints: newRoundPoints,
    );

    int newCurrentShot = currentState.currentShot + 1;
    int newCurrentPlayerIndex = currentState.currentPlayerIndex;
    int newCurrentRound = currentState.currentRound;

    if (newCurrentShot == X01Constants.shotsCount) {
      newCurrentShot = 0;
      newCurrentPlayerIndex++;

      if (newCurrentPlayerIndex >= newPlayers.length) {
        newCurrentPlayerIndex = 0;
        newCurrentRound++;
      }

      newPlayers[newCurrentPlayerIndex] = newPlayers[newCurrentPlayerIndex]
          .copyWith(
            currentRoundPoints: [EmptyPoints(), EmptyPoints(), EmptyPoints()],
          );
    }

    final newState = GameState(
      players: newPlayers,
      currentPlayerIndex: newCurrentPlayerIndex,
      currentShot: newCurrentShot,
      currentRound: newCurrentRound,
    );

    if (_historyIndex < _history.length - 1) {
      _history.removeRange(_historyIndex + 1, _history.length);
    }

    _history.add(newState);

    if (_history.length > maxHistoryLength) {
      _history.removeAt(0);
    }

    _historyIndex = _history.length - 1;

    notifyListeners();
  }

  Future<void> undo() async {
    if (!canUndo) return;

    _historyIndex--;
    notifyListeners();
  }

  void restartGame() {
    _initNewGame();
    notifyListeners();
  }
}

class GameState {
  final List<PlayerModel> players;
  final int currentPlayerIndex;
  final int currentShot;
  final int currentRound;

  GameState({
    required this.players,
    required this.currentPlayerIndex,
    required this.currentShot,
    required this.currentRound,
  });
}
