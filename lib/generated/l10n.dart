// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Счетчик дартс`
  String get appName {
    return Intl.message(
      'Счетчик дартс',
      name: 'appName',
      desc: '',
      args: [],
    );
  }

  /// `Главное меню`
  String get mainMenu {
    return Intl.message(
      'Главное меню',
      name: 'mainMenu',
      desc: '',
      args: [],
    );
  }

  /// `X01`
  String get x01 {
    return Intl.message(
      'X01',
      name: 'x01',
      desc: '',
      args: [],
    );
  }

  /// `Настройки игры`
  String get gameSettings {
    return Intl.message(
      'Настройки игры',
      name: 'gameSettings',
      desc: '',
      args: [],
    );
  }

  /// `Режим`
  String get mode {
    return Intl.message(
      'Режим',
      name: 'mode',
      desc: '',
      args: [],
    );
  }

  /// `Режим входа в игру`
  String get gameInMode {
    return Intl.message(
      'Режим входа в игру',
      name: 'gameInMode',
      desc: '',
      args: [],
    );
  }

  /// `Режим ввыхода из игры`
  String get gameOutMode {
    return Intl.message(
      'Режим ввыхода из игры',
      name: 'gameOutMode',
      desc: '',
      args: [],
    );
  }

  /// `Прямой`
  String get straight {
    return Intl.message(
      'Прямой',
      name: 'straight',
      desc: '',
      args: [],
    );
  }

  /// `Двойной`
  String get double {
    return Intl.message(
      'Двойной',
      name: 'double',
      desc: '',
      args: [],
    );
  }

  /// `Тройной`
  String get triple {
    return Intl.message(
      'Тройной',
      name: 'triple',
      desc: '',
      args: [],
    );
  }

  /// `Количество игроков`
  String get playersCount {
    return Intl.message(
      'Количество игроков',
      name: 'playersCount',
      desc: '',
      args: [],
    );
  }

  /// `Текущий раунд: `
  String get currentRound {
    return Intl.message(
      'Текущий раунд: ',
      name: 'currentRound',
      desc: '',
      args: [],
    );
  }

  /// `Игрок {N}`
  String playerN(Object N) {
    return Intl.message(
      'Игрок $N',
      name: 'playerN',
      desc: '',
      args: [N],
    );
  }

  /// `{player} выиграл!`
  String playerWins(Object player) {
    return Intl.message(
      '$player выиграл!',
      name: 'playerWins',
      desc: '',
      args: [player],
    );
  }

  /// `Завершить`
  String get finish {
    return Intl.message(
      'Завершить',
      name: 'finish',
      desc: '',
      args: [],
    );
  }

  /// `Начать`
  String get start {
    return Intl.message(
      'Начать',
      name: 'start',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ru'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
