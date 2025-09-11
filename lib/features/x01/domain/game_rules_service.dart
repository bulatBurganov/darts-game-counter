import 'package:darts_counter/features/x01/domain/models/player_model.dart';
import 'package:darts_counter/features/x01/domain/models/points_model.dart';
import 'package:darts_counter/features/x01/domain/models/x01_settings_model.dart';

class GameRulesService {
  static bool isValidEntry(Points points, InOutModes inMode) {
    return switch (inMode) {
      InOutModes.straight => true,
      InOutModes.double => points is DoublePoints,
      InOutModes.triple => points is TriplePoints,
    };
  }

  static bool isValidFinish(Points points, InOutModes outMode) {
    return switch (outMode) {
      InOutModes.straight => true,
      InOutModes.double => points is DoublePoints,
      InOutModes.triple => points is TriplePoints,
    };
  }

  static int calculatePointsValue(Points points) {
    return switch (points) {
      RegularPoints() => points.value,
      DoublePoints() => points.value * 2,
      TriplePoints() => points.value * 3,
      EmptyPoints() => 0,
    };
  }

  static bool canCountPoints(
    PlayerModel player,
    Points points,
    InOutModes inMode,
  ) {
    return player.isInGame || isValidEntry(points, inMode);
  }
}
