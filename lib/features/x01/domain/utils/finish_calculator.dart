import 'package:darts_counter/features/x01/domain/models/points_model.dart';
import 'package:darts_counter/features/x01/domain/models/x01_settings_model.dart';

class FinishCalculator {
  static List<Points>? calculateFinish(
    int score,
    InOutModes outMode,
    int remainingShots,
    InOutModes inMode,
    bool isInGame,
  ) {
    if (score <= 0 || remainingShots == 0) return null;

    // Получаем все возможные варианты финиша
    final allFinishes = _findAllFinishes(
      score,
      remainingShots,
      outMode,
      inMode,
      isInGame,
    );

    if (allFinishes.isEmpty) return null;

    // Сортируем по приоритету: меньше дротиков -> проще сегменты
    allFinishes.sort((a, b) {
      // Приоритет: меньше дротиков
      if (a.length != b.length) {
        return a.length.compareTo(b.length);
      }

      // Затем: меньше сложных сегментов (кроме последнего)
      final aComplexity = _calculateComplexity(a, outMode);
      final bComplexity = _calculateComplexity(b, outMode);
      return aComplexity.compareTo(bComplexity);
    });

    return allFinishes.first;
  }

  static List<List<Points>> _findAllFinishes(
    int score,
    int maxDarts,
    InOutModes outMode,
    InOutModes inMode,
    bool isInGame,
  ) {
    final finishes = <List<Points>>[];

    void findFinishes(
      int currentScore,
      int dartsLeft,
      List<Points> currentPath,
      bool currentInGame,
    ) {
      if (dartsLeft == 0 || currentScore < 0) return;

      // Определяем доступные броски для текущего состояния
      final availableDarts = _getAvailableDarts(
        currentScore,
        currentInGame ? InOutModes.straight : inMode,
      );

      for (final dart in availableDarts) {
        final dartValue = _calculatePointsValue(dart);
        final newScore = currentScore - dartValue;
        final newInGame = currentInGame || _isValidEntry(dart, inMode);
        final newPath = [...currentPath, dart];

        if (newScore == 0 && newInGame) {
          // Проверяем валидность финиша
          if (_isValidFinish(newPath, outMode)) {
            finishes.add(newPath);
          }
        } else if (newScore > 0 && dartsLeft > 1) {
          // Продолжаем поиск рекурсивно
          findFinishes(newScore, dartsLeft - 1, newPath, newInGame);
        }
      }
    }

    findFinishes(score, maxDarts, [], isInGame);
    return finishes;
  }

  static List<Points> _getAvailableDarts(int score, InOutModes mode) {
    final darts = <Points>[];

    // Добавляем возможные броски в зависимости от режима
    switch (mode) {
      case InOutModes.straight:
        // Все сегменты от 1 до 20
        for (int i = 1; i <= 20; i++) {
          if (i <= score) darts.add(RegularPoints(value: i));
          if (i * 2 <= score) darts.add(DoublePoints(value: i));
          if (i * 3 <= score) darts.add(TriplePoints(value: i));
        }
        // Булл
        if (25 <= score) darts.add(const RegularPoints(value: 25));
        if (50 <= score) darts.add(const DoublePoints(value: 25));
        break;

      case InOutModes.double:
        // Только двойные сегменты
        for (int i = 1; i <= 20; i++) {
          if (i * 2 <= score) darts.add(DoublePoints(value: i));
        }
        // Двойной булл
        if (50 <= score) darts.add(const DoublePoints(value: 25));
        break;

      case InOutModes.triple:
        // Только тройные сегменты
        for (int i = 1; i <= 20; i++) {
          if (i * 3 <= score) darts.add(TriplePoints(value: i));
        }
        break;
    }

    return darts;
  }

  static int _calculateComplexity(List<Points> finish, InOutModes outMode) {
    int complexity = 0;

    // Учитываем сложность всех бросков, кроме последнего
    for (int i = 0; i < finish.length - 1; i++) {
      complexity += _getDartComplexity(finish[i]);
    }

    // Для последнего броска учитываем только если outMode straight
    if (outMode == InOutModes.straight) {
      complexity += _getDartComplexity(finish.last);
    }

    return complexity;
  }

  static int _getDartComplexity(Points dart) {
    return switch (dart) {
      RegularPoints() => 1, // Обычные сегменты - самые простые
      DoublePoints() => 2, // Двойные - средней сложности
      TriplePoints() => 3, // Тройные - самые сложные
      EmptyPoints() => 0,
    };
  }

  static bool _isValidEntry(Points points, InOutModes inMode) {
    return switch (inMode) {
      InOutModes.straight => true,
      InOutModes.double => points is DoublePoints,
      InOutModes.triple => points is TriplePoints,
    };
  }

  static bool _isValidFinish(List<Points> finish, InOutModes outMode) {
    return switch (outMode) {
      InOutModes.straight => true,
      InOutModes.double => finish.last is DoublePoints,
      InOutModes.triple => finish.last is TriplePoints,
    };
  }

  static int _calculatePointsValue(Points points) {
    return switch (points) {
      RegularPoints() => points.value,
      DoublePoints() => points.value * 2,
      TriplePoints() => points.value * 3,
      EmptyPoints() => 0,
    };
  }
}
