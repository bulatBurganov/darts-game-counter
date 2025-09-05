// finish_calculator.dart
import 'package:darts_counter/features/x01/domain/models/points_model.dart';
import 'package:darts_counter/features/x01/domain/models/x01_settings_model.dart';

class FinishCalculator {
  static List<Points>? calculateFinish(
    int score,
    InOutModes outMode,
    int darts,
  ) {
    if (score <= 0) return null;

    final allThrows = _generateAllPossibleThrows();
    final results = _findFinishCombinations(score, outMode, darts, allThrows);

    return results.isNotEmpty ? results.first : null;
  }

  static List<List<Points>> _findFinishCombinations(
    int score,
    InOutModes outMode,
    int darts,
    List<Points> allThrows,
  ) {
    final results = <List<Points>>[];

    void find(
      int currentScore,
      int dartsLeft,
      List<Points> currentCombination,
    ) {
      if (dartsLeft == 0) {
        if (currentScore == 0 && _isValidFinish(currentCombination, outMode)) {
          results.add([...currentCombination]);
        }
        return;
      }

      for (final thro in allThrows) {
        final value = _calculatePointsValue(thro);
        if (currentScore - value < 0) continue;

        currentCombination.add(thro);
        find(currentScore - value, dartsLeft - 1, currentCombination);
        currentCombination.removeLast();
      }
    }

    find(score, darts, []);
    return results;
  }

  static bool _isValidFinish(List<Points> combination, InOutModes outMode) {
    final lastThrow = combination.last;

    return switch (outMode) {
      InOutModes.straight => true,
      InOutModes.double => lastThrow is DoublePoints,
      InOutModes.triple => lastThrow is TriplePoints,
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

  static List<Points> _generateAllPossibleThrows() {
    final t = <Points>[];

    // Add regular points (1-20, 25)
    for (int i = 1; i <= 20; i++) {
      t.add(RegularPoints(value: i));
    }
    t.add(const RegularPoints(value: 25));

    // Add double points (D1-D20, D25)
    for (int i = 1; i <= 20; i++) {
      t.add(DoublePoints(value: i));
    }
    t.add(const DoublePoints(value: 25));

    // Add triple points (T1-T20)
    for (int i = 1; i <= 20; i++) {
      t.add(TriplePoints(value: i));
    }

    return t;
  }
}
