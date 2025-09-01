import 'package:darts_counter/features/x01/domain/constants/x01_params.dart';

class X01SettingsModel {
  final X01Modes mode;
  final InOutModes inMode;
  final InOutModes outMode;
  final int playersCount;

  const X01SettingsModel({
    this.mode = X01Modes.x301,
    this.inMode = InOutModes.simple,
    this.outMode = InOutModes.simple,
    this.playersCount = 2,
  });

  X01SettingsModel copyWith({
    X01Modes? mode,
    InOutModes? inMode,
    InOutModes? outMode,
    int? playersCount,
  }) => X01SettingsModel(
    mode: mode ?? this.mode,
    inMode: inMode ?? this.inMode,
    outMode: outMode ?? this.outMode,
    playersCount: playersCount ?? this.playersCount,
  );
}
