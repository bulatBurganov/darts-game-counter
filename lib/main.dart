import 'package:darts_counter/features/navigation/router.dart';
import 'package:darts_counter/features/ui-core/theme/app_theme.dart';
import 'package:darts_counter/features/ui-core/theme/theme_provier.dart';
import 'package:darts_counter/flavors.dart';
import 'package:darts_counter/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void mainRunApp(Flavor flavor) async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final themeProvider = ThemeProvier();
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        S.delegate,
      ],
      title: 'Flutter Demo',
      locale: const Locale('ru', 'RU'),

      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}
