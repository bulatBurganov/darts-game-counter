import 'package:darts_counter/features/main_menu/main_menu_screen.dart';
import 'package:darts_counter/features/x01/domain/models/x01_settings_model.dart';
import 'package:darts_counter/features/x01/domain/x01_game_view_model.dart';
import 'package:darts_counter/features/x01/ui/x01_game_screen.dart';
import 'package:darts_counter/features/x01/ui/x01_settings_screen.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MainMenuScreen(),
      routes: [
        GoRoute(
          path: 'x01settings',
          builder: (context, state) =>
              X01SettingsScreen(viewModel: X01SettingsViewModel()),
        ),
        GoRoute(
          path: 'x01game',
          builder: (context, state) {
            final settings = state.extra as X01SettingsModel;
            return X01GameScreen(
              viewModel: X01GameViewModel(settings: settings),
            );
          },
        ),
      ],
    ),
  ],
);
