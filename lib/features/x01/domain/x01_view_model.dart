import 'package:darts_counter/features/x01/domain/constants/x01_constants.dart';
import 'package:darts_counter/features/x01/domain/models/player_model.dart';
import 'package:darts_counter/features/x01/domain/models/points_model.dart';
import 'package:flutter/material.dart';

class X01ViewModel extends ChangeNotifier {
  final int _playerCount = 2;
  final List<PlayerModel> _players = [
    PlayerModel('Player 1'),
    PlayerModel('Player 2'),
  ];
  int _currentPlayerIndex = 0;
  int _currentShot = 0;
  int _currentRound = 1;

  List<PlayerModel> get players => _players;
  int get currentPlayerIndex => _currentPlayerIndex;
  int get currentShot => _currentShot;
  int get currentRound => _currentRound;

  Future<void> addPoints(Points points) async {
    final currentPlayer = _players[_currentPlayerIndex];

    final p = switch (points) {
      RegularPoints() => points.value,
      DoublePoints() => points.value * 2,
      TriplePoints() => points.value * 3,
      EmptyPoints() => 0,
    };
    var c = [...currentPlayer.currentRoundPoints];
    c[currentShot] = points;

    _players[_currentPlayerIndex] = currentPlayer.copyWith(
      score: currentPlayer.score - p,
      currentRoundPoints: c,
    );

    _currentShot++;

    if (_currentShot == X01Constants.shotsCount) {
      _currentShot = 0;
      _currentPlayerIndex++;

      if (_currentPlayerIndex >= _players.length) {
        _currentPlayerIndex = 0;
        _currentRound++;
      }

      _players[_currentPlayerIndex] = _players[_currentPlayerIndex].copyWith(
        currentRoundPoints: [EmptyPoints(), EmptyPoints(), EmptyPoints()],
      );
    }

    notifyListeners();
  }

  Future<void> undo() async {}
}
