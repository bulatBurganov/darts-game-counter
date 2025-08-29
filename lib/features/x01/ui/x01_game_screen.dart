import 'package:darts_counter/features/x01/domain/x01_view_model.dart';
import 'package:darts_counter/features/x01/ui/player_tile.dart';
import 'package:darts_counter/features/x01/ui/score_pad.dart';
import 'package:flutter/material.dart';

class X01GameScreen extends StatefulWidget {
  final X01ViewModel viewModel;
  const X01GameScreen({super.key, required this.viewModel});

  @override
  State<X01GameScreen> createState() => _X01GameScreenState();
}

class _X01GameScreenState extends State<X01GameScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('X01 game')),
      bottomNavigationBar: ScoreInputSection(
        onScoreAdded: (points) {
          widget.viewModel.addPoints(points);
        },
        onUndo: () {},
      ),
      body: ListenableBuilder(
        listenable: widget.viewModel,
        builder: (context, _) {
          return Padding(
            padding: EdgeInsets.only(left: 8, right: 8),
            child: Column(
              children: [
                Text('Current round: ${widget.viewModel.currentRound}'),
                ...List.generate(
                  widget.viewModel.players.length,
                  (i) => PlayerTile(
                    player: widget.viewModel.players[i],
                    isSelected: widget.viewModel.currentPlayerIndex == i,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
