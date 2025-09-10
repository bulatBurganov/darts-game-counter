import 'package:darts_counter/features/x01/domain/models/game_state.dart';

class GameHistoryRepository {
  static const int maxHistoryLength = 100;
  final List<GameState> _history = [];
  int _currentIndex = -1;

  bool get canUndo => _currentIndex > 0;

  GameState get currentState => _history[_currentIndex];

  void initialize(GameState initialState) {
    _history.clear();
    _history.add(initialState);
    _currentIndex = 0;
  }

  void addState(GameState newState) {
    // Remove any future states if we're not at the end
    if (_currentIndex < _history.length - 1) {
      _history.removeRange(_currentIndex + 1, _history.length);
    }

    _history.add(newState);

    // Limit history size
    if (_history.length > maxHistoryLength) {
      _history.removeAt(0);
    }

    _currentIndex = _history.length - 1;
  }

  GameState undo() {
    if (canUndo) {
      _currentIndex--;
    }
    return _history[_currentIndex];
  }

  void clear() {
    _history.clear();
    _currentIndex = -1;
  }
}
