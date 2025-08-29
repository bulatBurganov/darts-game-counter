sealed class Points {
  final int value;

  const Points({required this.value});
}

class RegularPoints extends Points {
  const RegularPoints({required super.value});
}

class DoublePoints extends Points {
  const DoublePoints({required super.value});
}

class TriplePoints extends Points {
  const TriplePoints({required super.value});
}

class EmptyPoints extends Points {
  const EmptyPoints() : super(value: -1);
}

extension PointsStringExt on Points {
  String getString() {
    return switch (this) {
      RegularPoints() => value.toString(),
      DoublePoints() => 'D$value',
      TriplePoints() => 'T$value',
      EmptyPoints() => '',
    };
  }
}
