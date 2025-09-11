import 'package:darts_counter/features/x01/domain/models/game_state.dart';
import 'package:darts_counter/features/x01/domain/models/points_model.dart';
import 'package:darts_counter/features/x01/domain/models/x01_settings_model.dart';
import 'package:darts_counter/features/x01/domain/x01_game_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('X01ViewModel', () {
    test('should initialize with correct default values', () {
      const settings = X01GameSettingsModel(
        mode: X01Modes.x501,
        playersCount: 2,
        inMode: InOutModes.straight,
        outMode: InOutModes.double,
      );
      final viewModel = X01ViewModel(settings: settings);

      expect(viewModel.players.length, 2);
      expect(viewModel.players[0].score, 501);
      expect(viewModel.players[1].score, 501);
      expect(viewModel.currentPlayerIndex, 0);
      expect(viewModel.currentShot, 0);
      expect(viewModel.currentRound, 1);
      expect(viewModel.status, GameStatus.playing);
      expect(viewModel.winner, isNull);
      expect(viewModel.canUndo, false);
    });

    test('should add points correctly in straight mode', () async {
      const settings = X01GameSettingsModel(
        mode: X01Modes.x501,
        playersCount: 2,
        inMode: InOutModes.straight,
        outMode: InOutModes.double,
      );
      final viewModel = X01ViewModel(settings: settings);

      await viewModel.addPoints(const RegularPoints(value: 20));
      expect(viewModel.players[0].score, 481);
      expect(viewModel.currentShot, 1);

      await viewModel.addPoints(const TriplePoints(value: 20));
      expect(viewModel.players[0].score, 421);
      expect(viewModel.currentShot, 2);

      await viewModel.addPoints(const DoublePoints(value: 20));
      expect(viewModel.players[0].score, 381);
      expect(viewModel.currentShot, 0);
      expect(viewModel.currentPlayerIndex, 1);
    });

    test('should handle double in mode correctly', () async {
      const settings = X01GameSettingsModel(
        mode: X01Modes.x501,
        playersCount: 2,
        inMode: InOutModes.double,
        outMode: InOutModes.double,
      );
      final viewModel = X01ViewModel(settings: settings);

      // Regular points shouldn't count before double in
      await viewModel.addPoints(const RegularPoints(value: 20));
      expect(viewModel.players[0].score, 501);
      expect(viewModel.players[0].isInGame, false);

      // Double should allow entry
      await viewModel.addPoints(const DoublePoints(value: 10));
      expect(viewModel.players[0].score, 501 - 20);
      expect(viewModel.players[0].isInGame, true);
    });

    test('should handle bust correctly', () async {
      const settings = X01GameSettingsModel(
        mode: X01Modes.x101,
        playersCount: 2,
        inMode: InOutModes.straight,
        outMode: InOutModes.double,
      );
      final viewModel = X01ViewModel(settings: settings);

      // Set up a bust scenario
      await viewModel.addPoints(const DoublePoints(value: 25));
      expect(viewModel.players[0].score, 51);
      expect(viewModel.currentShot, 1);

      await viewModel.addPoints(const DoublePoints(value: 25));
      expect(
        viewModel.players[0].score,
        101,
      ); // Should reset to start of turn score
      expect(viewModel.currentPlayerIndex, 1); // Should move to next player
    });

    test('should finish game correctly with double out', () async {
      const settings = X01GameSettingsModel(
        mode: X01Modes.x101,
        playersCount: 2,
        inMode: InOutModes.straight,
        outMode: InOutModes.double,
      );
      final viewModel = X01ViewModel(settings: settings);

      // Set up finish scenario: 101 - 51 = 50, then finish with double 25
      await viewModel.addPoints(const RegularPoints(value: 51));
      expect(viewModel.players[0].score, 50);
      expect(viewModel.currentShot, 1);

      // Finish with double 25
      await viewModel.addPoints(const DoublePoints(value: 25));
      expect(viewModel.status, GameStatus.finished);
      expect(viewModel.winner, '1');
      expect(viewModel.players[0].score, 0);
    });

    test('should not finish with invalid out shot ', () async {
      const settings = X01GameSettingsModel(
        mode: X01Modes.x101,
        playersCount: 2,
        inMode: InOutModes.straight,
        outMode: InOutModes.double,
      );
      final viewModel = X01ViewModel(settings: settings);

      // Set up finish scenario: 101 - 81 = 20
      await viewModel.addPoints(const RegularPoints(value: 81));
      expect(viewModel.players[0].score, 20);
      expect(viewModel.currentShot, 1);

      // Try to finish with single 20
      await viewModel.addPoints(const RegularPoints(value: 20));
      expect(viewModel.status, GameStatus.playing);
      expect(viewModel.players[0].score, 101); // Should bust and reset
      expect(viewModel.currentPlayerIndex, 1); // Should move to next player
    });

    test('should provide finish hints', () async {
      const settings = X01GameSettingsModel(
        mode: X01Modes.x101,
        playersCount: 2,
        inMode: InOutModes.straight,
        outMode: InOutModes.double,
      );
      final viewModel = X01ViewModel(settings: settings);

      // Set up a finish scenario
      await viewModel.addPoints(const RegularPoints(value: 51));
      expect(viewModel.finishHint, isNotNull);
    });

    test('should undo correctly', () async {
      const settings = X01GameSettingsModel(
        mode: X01Modes.x101,
        playersCount: 2,
        inMode: InOutModes.straight,
        outMode: InOutModes.double,
      );
      final viewModel = X01ViewModel(settings: settings);

      final initialScore = viewModel.players[0].score;

      await viewModel.addPoints(const RegularPoints(value: 20));
      expect(viewModel.players[0].score, initialScore - 20);
      expect(viewModel.canUndo, true);

      await viewModel.undo();
      expect(viewModel.players[0].score, initialScore);
      expect(viewModel.currentShot, 0);
    });

    test('should handle triple in mode correctly', () async {
      const settings = X01GameSettingsModel(
        mode: X01Modes.x501,
        playersCount: 2,
        inMode: InOutModes.triple,
        outMode: InOutModes.double,
      );
      final viewModel = X01ViewModel(settings: settings);

      // Regular and double points shouldn't count before triple in
      await viewModel.addPoints(const RegularPoints(value: 20));
      expect(viewModel.players[0].score, 501);
      expect(viewModel.players[0].isInGame, false);

      await viewModel.addPoints(const DoublePoints(value: 10));
      expect(viewModel.players[0].score, 501);
      expect(viewModel.players[0].isInGame, false);

      // Triple should allow entry
      await viewModel.addPoints(const TriplePoints(value: 10));
      expect(viewModel.players[0].score, 501 - 30);
      expect(viewModel.players[0].isInGame, true);
    });

    test('should handle game with different modes', () {
      const modes = [
        X01Modes.x101,
        X01Modes.x201,
        X01Modes.x301,
        X01Modes.x501,
        X01Modes.x701,
        X01Modes.x901,
        X01Modes.x1101,
        X01Modes.x1501,
      ];

      for (final mode in modes) {
        final settings = X01GameSettingsModel(
          mode: mode,
          playersCount: 2,
          inMode: InOutModes.straight,
          outMode: InOutModes.double,
        );
        final viewModel = X01ViewModel(settings: settings);

        expect(
          viewModel.players[0].score,
          int.parse(mode.name.replaceAll('x', '')),
        );
        expect(
          viewModel.players[1].score,
          int.parse(mode.name.replaceAll('x', '')),
        );
      }
    });
  });
}
