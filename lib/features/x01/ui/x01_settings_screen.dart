import 'package:darts_counter/features/ui-core/app_rounded_button.dart';
import 'package:darts_counter/features/x01/domain/models/x01_settings_model.dart';
import 'package:darts_counter/features/x01/ui/widgets/in_out_selector.dart';
import 'package:darts_counter/features/x01/ui/widgets/players_count_slider.dart';
import 'package:darts_counter/features/x01/ui/widgets/x01_mode_selector.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class X01SettingsScreen extends StatelessWidget {
  final X01SettingsViewModel viewModel;
  X01SettingsScreen({super.key, required this.viewModel}) {
    print('object');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) {
          return Padding(
            padding: EdgeInsets.only(
              left: 8,
              right: 8,
              bottom: MediaQuery.of(context).padding.bottom,
            ),
            child: Builder(
              builder: (context) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    X01ModeSelector(
                      initialValue: viewModel.settings.mode,
                      onModeChanged: (mode) {
                        print('on mode changed $mode');
                        viewModel.updateMode(mode);
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'In mode',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    InOutModeSelector(
                      initialValue: viewModel.settings.inMode,
                      selectorColor: Theme.of(context).colorScheme.primary,
                      onCahnged: (mode) {
                        viewModel.updateInMode(mode);
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Out mode',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    InOutModeSelector(
                      initialValue: viewModel.settings.outMode,
                      selectorColor: Theme.of(context).colorScheme.primary,

                      onCahnged: (mode) {
                        viewModel.updateOutMode(mode);
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Players',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    PlayerCountSlider(
                      initialValue: viewModel.settings.playersCount.toDouble(),
                      onChanged: (count) {
                        viewModel.updatePlayersCount(count);
                      },
                    ),
                    const Spacer(),
                    AppRoundedButton(
                      text: 'Start',
                      color: Theme.of(context).colorScheme.primary,

                      textColor: Colors.white,
                      onTap: () {
                        context.push('/x01game', extra: viewModel.settings);
                      },
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class X01SettingsViewModel extends ChangeNotifier {
  X01SettingsViewModel() {
    print('constructor');
  }
  var _currentState = const X01GameSettingsModel();

  X01GameSettingsModel get settings => _currentState;

  Future<void> updateMode(X01Modes mode) async {
    _currentState = _currentState.copyWith(mode: mode);
    notifyListeners();
  }

  Future<void> updateInMode(InOutModes mode) async {
    _currentState = _currentState.copyWith(inMode: mode);
    notifyListeners();
  }

  Future<void> updateOutMode(InOutModes mode) async {
    _currentState = _currentState.copyWith(outMode: mode);
    notifyListeners();
  }

  Future<void> updatePlayersCount(int count) async {
    _currentState = _currentState.copyWith(playersCount: count);
    notifyListeners();
  }
}
