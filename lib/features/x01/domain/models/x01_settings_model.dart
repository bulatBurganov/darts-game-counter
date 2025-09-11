enum X01Modes {
  x101(val: 101),
  x201(val: 201),
  x301(val: 301),
  x501(val: 501),
  x701(val: 701),
  x901(val: 901),
  x1101(val: 1101),
  x1501(val: 1501);

  final int val;

  const X01Modes({required this.val});
}

enum InOutModes { straight, double, triple }

class X01GameSettingsModel {
  final X01Modes mode;
  final InOutModes inMode;
  final InOutModes outMode;
  final int playersCount;

  const X01GameSettingsModel({
    this.mode = X01Modes.x301,
    this.inMode = InOutModes.straight,
    this.outMode = InOutModes.straight,
    this.playersCount = 2,
  });

  X01GameSettingsModel copyWith({
    X01Modes? mode,
    InOutModes? inMode,
    InOutModes? outMode,
    int? playersCount,
  }) {
    return X01GameSettingsModel(
      mode: mode ?? this.mode,
      inMode: inMode ?? this.inMode,
      outMode: outMode ?? this.outMode,
      playersCount: playersCount ?? this.playersCount,
    );
  }
}
