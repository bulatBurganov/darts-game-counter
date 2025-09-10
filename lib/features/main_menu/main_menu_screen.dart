import 'package:darts_counter/features/navigation/router.dart';
import 'package:darts_counter/features/navigation/routes.dart';
import 'package:darts_counter/features/ui-core/app_rounded_button.dart';
import 'package:darts_counter/generated/l10n.dart';
import 'package:flutter/material.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).mainMenu)),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children: [
              const SizedBox(height: 8),

              AppRoundedButton(
                onTap: () => router.push(Routes.x01settings),
                text: S.of(context).x01,
                color: Theme.of(context).colorScheme.primary,
                textColor: Colors.white,
                borderRadius: 8,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
