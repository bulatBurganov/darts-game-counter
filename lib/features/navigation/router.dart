import 'package:darts_counter/features/main_menu/main_menu_screen.dart';
import 'package:darts_counter/features/navigation/routes.dart';
import 'package:darts_counter/features/x01/domain/models/x01_settings_model.dart';
import 'package:darts_counter/features/x01/domain/x01_game_view_model.dart';
import 'package:darts_counter/features/x01/ui/x01_game_screen.dart';
import 'package:darts_counter/features/x01/ui/x01_settings_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: Routes.mainMenu,
      builder: (context, state) => const MainMenuScreen(),
      routes: [
        ShellRoute(
          builder: (context, state, child) =>
              ChangeNotifierProvider<X01SettingsViewModel>(
                create: (context) => X01SettingsViewModel(),
                child: child,
              ),
          routes: [
            GoRoute(
              path: Routes.x01settings,
              builder: (context, state) => X01SettingsScreen(
                viewModel: context.read<X01SettingsViewModel>(),
              ),
            ),
            GoRoute(
              path: Routes.x01game,
              builder: (context, state) {
                final settings = state.extra as X01GameSettingsModel;
                return X01GameScreen(
                  viewModel: X01ViewModel(settings: settings),
                );
              },
            ),
          ],
        ),
      ],
    ),
  ],
);
