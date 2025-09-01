import 'package:darts_counter/features/x01/domain/models/game_state.dart';
import 'package:darts_counter/features/x01/domain/models/x01_settings_model.dart';
import 'package:flutter/material.dart';
import 'package:darts_counter/features/x01/domain/constants/x01_constants.dart';
import 'package:darts_counter/features/x01/domain/models/player_model.dart';
import 'package:darts_counter/features/x01/domain/models/points_model.dart';

class X01ViewModel extends ChangeNotifier {
  static const int maxHistoryLength = 100;

  final List<GameState> _history = [];
  int _historyIndex = -1;
  GameStatus _status = GameStatus.playing;
  String? _winner;
  X01GameSettingsModel _settings;

  List<PlayerModel> get players => _currentState.players;
  int get currentPlayerIndex => _currentState.currentPlayerIndex;
  int get currentShot => _currentState.currentShot;
  int get currentRound => _currentState.currentRound;
  bool get canUndo => _historyIndex > 0;
  GameStatus get status => _status;
  String? get winner => _winner;
  X01GameSettingsModel get settings => _settings;

  GameState get _currentState => _history[_historyIndex];

  X01ViewModel({required X01GameSettingsModel settings})
    : _settings = settings {
    _initNewGame();
  }

  void _initNewGame() {
    final initialScore = _getInitialScore();

    final players = List<PlayerModel>.generate(
      _settings.playersCount,
      (index) => PlayerModel(
        'Player ${index + 1}',
        score: initialScore,
        isInGame: _settings.inMode == InOutModes.straight,
        startOfTurnScore: initialScore,
        entryShotIndex: _settings.inMode == InOutModes.straight ? 0 : -1,
      ),
    );

    final initialState = GameState(
      players: players,
      currentPlayerIndex: 0,
      currentShot: 0,
      currentRound: 1,
      settings: _settings,
    );

    _history.add(initialState);
    _historyIndex = 0;
    _status = GameStatus.playing;
    _winner = null;
  }

  int _getInitialScore() {
    return switch (_settings.mode) {
      X01Modes.x101 => 101,
      X01Modes.x201 => 201,
      X01Modes.x301 => 301,
      X01Modes.x501 => 501,
      X01Modes.x701 => 701,
      X01Modes.x901 => 901,
      X01Modes.x1101 => 1101,
      X01Modes.x1501 => 1501,
    };
  }

  Future<void> addPoints(Points points) async {
    if (_status == GameStatus.finished) return;

    final currentState = _currentState;
    final newPlayers = currentState.players.map((p) => p.copyWith()).toList();
    final currentPlayer = newPlayers[currentState.currentPlayerIndex];

    // Обновляем текущие броски раунда
    var newRoundPoints = [...currentPlayer.currentRoundPoints];
    newRoundPoints[currentState.currentShot] = points;

    // Проверяем, можно ли засчитать очки
    final canCount = _canCountPoints(currentPlayer, points);
    final pointsValue = canCount ? _calculatePointsValue(points) : 0;
    final newScore = currentPlayer.score - pointsValue;

    // Проверяем, вошел ли игрок в игру
    final isEntryShot = !currentPlayer.isInGame && _isValidEntry(points);
    final newIsInGame = currentPlayer.isInGame || isEntryShot;

    // Обновляем состояние игрока
    newPlayers[currentState.currentPlayerIndex] = currentPlayer.copyWith(
      score: newIsInGame ? newScore : currentPlayer.score,
      currentRoundPoints: newRoundPoints,
      isInGame: newIsInGame,
      entryShotIndex: isEntryShot
          ? currentState.currentShot
          : currentPlayer.entryShotIndex,
    );

    final updatedPlayer = newPlayers[currentState.currentPlayerIndex];

    // Если игрок только что вошел в игру, обрабатываем отдельно
    if (isEntryShot) {
      _handleNextShot(newPlayers, currentState);
      return;
    }

    // Если игрок уже в игре, проверяем условия завершения
    if (newIsInGame) {
      // Проверяем победу
      if (updatedPlayer.score == 0 &&
          _isValidFinish(
            updatedPlayer.currentRoundPoints,
            currentPlayer.startOfTurnScore,
          )) {
        _finishGame(newPlayers, currentState, currentPlayer.name);
        return;
      }

      // Проверяем буст
      final isBust =
          updatedPlayer.score < 0 || _hasUnfinishableScore(updatedPlayer.score);

      if (isBust) {
        // Восстанавливаем счет до начала хода
        newPlayers[currentState.currentPlayerIndex] = updatedPlayer.copyWith(
          score: updatedPlayer.startOfTurnScore,
          currentRoundPoints: const [
            EmptyPoints(),
            EmptyPoints(),
            EmptyPoints(),
          ],
        );

        // Переходим к следующему игроку
        _handleNextTurn(newPlayers, currentState);
        return;
      }
    }

    // Если не было специальных условий, переходим к следующему броску
    _handleNextShot(newPlayers, currentState);
  }

  bool _canCountPoints(PlayerModel player, Points points) {
    // Если игрок еще не вошел в игру, проверяем условия входа
    if (!player.isInGame) {
      return _isValidEntry(points);
    }

    // Если игрок уже в игре, засчитываем все очки
    return true;
  }

  bool _isValidEntry(Points points) {
    return switch (_settings.inMode) {
      InOutModes.straight => true,
      InOutModes.double => points is DoublePoints,
      InOutModes.triple => points is TriplePoints,
    };
  }

  bool _isValidFinish(List<Points> roundPoints, int startOfTurnScore) {
    // Рассчитываем сумму всех очков в подходе
    int totalPoints = 0;
    for (Points points in roundPoints) {
      totalPoints += _calculatePointsValue(points);
    }

    // Проверяем, что сумма очков точно равна начальному счету подхода
    if (totalPoints != startOfTurnScore) {
      return false;
    }

    // Для валидного финиша нужно соответствие режиму выхода
    return switch (_settings.outMode) {
      InOutModes.straight => true,
      InOutModes.double => _isDoubleFinish(roundPoints),
      InOutModes.triple => _isTripleFinish(roundPoints),
    };
  }

  bool _isDoubleFinish(List<Points> roundPoints) {
    // Находим последний непустой бросок
    for (int i = roundPoints.length - 1; i >= 0; i--) {
      if (roundPoints[i] is! EmptyPoints) {
        return roundPoints[i] is DoublePoints;
      }
    }
    return false;
  }

  bool _isTripleFinish(List<Points> roundPoints) {
    // Находим последний непустой бросок
    for (int i = roundPoints.length - 1; i >= 0; i--) {
      if (roundPoints[i] is! EmptyPoints) {
        return roundPoints[i] is TriplePoints;
      }
    }
    return false;
  }

  bool _hasUnfinishableScore(int score) {
    if (score < 0) return true;

    return switch (_settings.outMode) {
      InOutModes.straight => false,
      InOutModes.double => score == 1,
      InOutModes.triple => score == 1 || score == 2,
    };
  }

  int _calculatePointsValue(Points points) {
    return switch (points) {
      RegularPoints() => points.value,
      DoublePoints() => points.value * 2,
      TriplePoints() => points.value * 3,
      EmptyPoints() => 0,
    };
  }

  void _handleNextShot(List<PlayerModel> newPlayers, GameState currentState) {
    int newCurrentShot = currentState.currentShot + 1;
    int newCurrentPlayerIndex = currentState.currentPlayerIndex;
    int newCurrentRound = currentState.currentRound;

    // Если это был последний бросок в раунде, переходим к следующему игроку
    if (newCurrentShot == X01Constants.shotsCount) {
      _handleNextTurn(newPlayers, currentState);
    } else {
      // Продолжаем текущий раунд
      _addNewState(
        GameState(
          players: newPlayers,
          currentPlayerIndex: newCurrentPlayerIndex,
          currentShot: newCurrentShot,
          currentRound: newCurrentRound,
          settings: currentState.settings,
        ),
      );
    }
  }

  void _handleNextTurn(List<PlayerModel> newPlayers, GameState currentState) {
    int newCurrentPlayerIndex =
        (currentState.currentPlayerIndex + 1) % newPlayers.length;
    int newCurrentRound = currentState.currentRound;

    // Если переходим к первому игроку, увеличиваем раунд
    if (newCurrentPlayerIndex == 0) {
      newCurrentRound++;
    }

    // Устанавливаем startOfTurnScore для следующего игрока
    newPlayers[newCurrentPlayerIndex] = newPlayers[newCurrentPlayerIndex]
        .copyWith(
          currentRoundPoints: const [
            EmptyPoints(),
            EmptyPoints(),
            EmptyPoints(),
          ],
          startOfTurnScore: newPlayers[newCurrentPlayerIndex].score,
        );

    _addNewState(
      GameState(
        players: newPlayers,
        currentPlayerIndex: newCurrentPlayerIndex,
        currentShot: 0,
        currentRound: newCurrentRound,
        settings: currentState.settings,
      ),
    );
  }

  void _finishGame(
    List<PlayerModel> newPlayers,
    GameState currentState,
    String winnerName,
  ) {
    _status = GameStatus.finished;
    _winner = winnerName;

    _addNewState(
      GameState(
        players: newPlayers,
        currentPlayerIndex: currentState.currentPlayerIndex,
        currentShot: currentState.currentShot,
        currentRound: currentState.currentRound,
        settings: currentState.settings,
        status: GameStatus.finished,
        winner: winnerName,
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
    final previousState = _history[_historyIndex];
    _status = previousState.status;
    _winner = previousState.winner;

    notifyListeners();
  }

  void restartGame() {
    _initNewGame();
    notifyListeners();
  }

  void updateSettings(X01GameSettingsModel newSettings) {
    _settings = newSettings;
    restartGame();
  }
}
