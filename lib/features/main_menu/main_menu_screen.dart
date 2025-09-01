import 'package:darts_counter/features/navigation/routes.dart';
import 'package:flutter/material.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Main menu')),

      body: Column(
        children: [
          GestureDetector(
            onTap: () => router.go('/x01settings'),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(8),
              child: Text('X01'),
            ),
          ),
        ],
      ),
    );
  }
}
