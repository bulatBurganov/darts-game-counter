import 'package:darts_counter/features/x01/domain/constants/x01_constants.dart';
import 'package:darts_counter/features/x01/domain/models/player_model.dart';
import 'package:darts_counter/features/x01/domain/models/points_model.dart';
import 'package:darts_counter/features/x01/domain/models/x01_settings_model.dart';
import 'package:flutter/material.dart';

enum GameStatus { playing, finished }

class X01GameViewModel extends ChangeNotifier {
  final X01SettingsModel settings;
  X01GameViewModel({required this.settings}) {
    print(settings.inMode);
    print(settings.outMode);
    print(settings.mode);
    print(settings.playersCount);
    _initNewGame();
  }
  static const int maxHistoryLength = 100;

  final List<GameState> _history = [];
  int _historyIndex = -1;
  GameStatus _status = GameStatus.playing;
  String? _winner;

  List<PlayerModel> get players => _currentState.players;
  int get currentPlayerIndex => _currentState.currentPlayerIndex;
  int get currentShot => _currentState.currentShot;
  int get currentRound => _currentState.currentRound;
  bool get canUndo => _historyIndex > 0;
  GameStatus get status => _status;
  String? get winner => _winner;

  GameState get _currentState => _history[_historyIndex];

  void _initNewGame() {
    final initialState = GameState(
      players: [PlayerModel('Player 1'), PlayerModel('Player 2')],
      currentPlayerIndex: 0,
      currentShot: 0,
      currentRound: 1,
    );

    _history.add(initialState);
    _historyIndex = 0;
    _status = GameStatus.playing;
    _winner = null;
  }

  Future<void> addPoints(Points points) async {
    if (_status == GameStatus.finished) return;

    final currentState = _currentState;
    final newPlayers = currentState.players.map((p) => p.copyWith()).toList();
    final currentPlayer = newPlayers[currentState.currentPlayerIndex];

    final pointsValue = switch (points) {
      RegularPoints() => points.value,
      DoublePoints() => points.value * 2,
      TriplePoints() => points.value * 3,
      EmptyPoints() => 0,
    };

    var newRoundPoints = [...currentPlayer.currentRoundPoints];
    newRoundPoints[currentState.currentShot] = points;

    final newScore = currentPlayer.score - pointsValue;

    // Проверка на завершение игры
    if (newScore == 0) {
      _finishGame(newPlayers, currentState, currentPlayer.name);
      return;
    }

    // Проверка на перебор
    if (newScore < 0) {
      _handleBust(newPlayers, currentState);
      return;
    }

    // Обычный ход
    newPlayers[currentState.currentPlayerIndex] = currentPlayer.copyWith(
      score: newScore,
      currentRoundPoints: newRoundPoints,
    );

    int newCurrentShot = currentState.currentShot + 1;
    int newCurrentPlayerIndex = currentState.currentPlayerIndex;
    int newCurrentRound = currentState.currentRound;

    if (newCurrentShot == X01Constants.shotsCount) {
      newCurrentShot = 0;
      newCurrentPlayerIndex = (newCurrentPlayerIndex + 1) % newPlayers.length;

      if (newCurrentPlayerIndex == 0) {
        newCurrentRound++;
      }

      newPlayers[newCurrentPlayerIndex] = newPlayers[newCurrentPlayerIndex]
          .copyWith(
            currentRoundPoints: const [
              EmptyPoints(),
              EmptyPoints(),
              EmptyPoints(),
            ],
          );
    }

    _addNewState(
      GameState(
        players: newPlayers,
        currentPlayerIndex: newCurrentPlayerIndex,
        currentShot: newCurrentShot,
        currentRound: newCurrentRound,
      ),
    );
  }

  void _finishGame(
    List<PlayerModel> newPlayers,
    GameState currentState,
    String winnerName,
  ) {
    newPlayers[currentState.currentPlayerIndex] =
        newPlayers[currentState.currentPlayerIndex].copyWith(
          score: 0,
          currentRoundPoints: const [
            EmptyPoints(),
            EmptyPoints(),
            EmptyPoints(),
          ],
        );

    _status = GameStatus.finished;
    _winner = winnerName;

    _addNewState(
      GameState(
        players: newPlayers,
        currentPlayerIndex: currentState.currentPlayerIndex,
        currentShot: currentState.currentShot,
        currentRound: currentState.currentRound,
      ),
    );
  }

  void _handleBust(List<PlayerModel> newPlayers, GameState currentState) {
    // Сбрасываем очки текущего раунда и переходим к следующему игроку
    newPlayers[currentState.currentPlayerIndex] =
        newPlayers[currentState.currentPlayerIndex].copyWith(
          currentRoundPoints: const [
            EmptyPoints(),
            EmptyPoints(),
            EmptyPoints(),
          ],
        );

    int newCurrentPlayerIndex =
        (currentState.currentPlayerIndex + 1) % newPlayers.length;
    int newCurrentRound = currentState.currentRound;

    if (newCurrentPlayerIndex == 0) {
      newCurrentRound++;
    }

    _addNewState(
      GameState(
        players: newPlayers,
        currentPlayerIndex: newCurrentPlayerIndex,
        currentShot: 0,
        currentRound: newCurrentRound,
      ),
    );
  }

  void _addNewState(GameState newState) {
    // Удаляем все состояния после текущего индекса
    if (_historyIndex < _history.length - 1) {
      _history.removeRange(_historyIndex + 1, _history.length);
    }

    _history.add(newState);

    // Ограничиваем размер истории
    if (_history.length > maxHistoryLength) {
      _history.removeAt(0);
    }

    _historyIndex = _history.length - 1;
    notifyListeners();
  }

  Future<void> undo() async {
    if (!canUndo) return;

    _historyIndex--;

    // Восстанавливаем состояние игры
    if (_historyIndex == 0) {
      _status = GameStatus.playing;
      _winner = null;
    } else {
      // Проверяем, был ли завершен game в предыдущем состоянии
      final previousState = _history[_historyIndex - 1];
      _status = previousState.status;
      _winner = previousState.winner;
    }

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
  final GameStatus status;
  final String? winner;

  GameState({
    required this.players,
    required this.currentPlayerIndex,
    required this.currentShot,
    required this.currentRound,
    this.status = GameStatus.playing,
    this.winner,
  });
}
