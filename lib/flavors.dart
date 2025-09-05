enum Flavor { prod, dev, stage }

class F {
  static late final Flavor appFlavor;

  static String get name => appFlavor.name;

  static String get title {
    switch (appFlavor) {
      case Flavor.prod:
        return 'Счетчик дартс';
      case Flavor.dev:
        return 'Счетчик дартс Dev';
      case Flavor.stage:
        return 'Счетчик дартс Stage';
    }
  }
}
