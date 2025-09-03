import 'package:darts_counter/features/x01/domain/x01_game_view_model.dart';
import 'package:darts_counter/features/x01/ui/widgets/player_tile.dart';
import 'package:darts_counter/features/x01/ui/widgets/score_pad.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class X01GameScreen extends StatefulWidget {
  final X01ViewModel viewModel;
  const X01GameScreen({super.key, required this.viewModel});

  @override
  State<X01GameScreen> createState() => _X01GameScreenState();
}

class _X01GameScreenState extends State<X01GameScreen> {
  @override
  void initState() {
    widget.viewModel.addListener(_onViewModelChanged);
    super.initState();
  }

  @override
  void dispose() {
    widget.viewModel.removeListener(_onViewModelChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('X01 game')),
      bottomNavigationBar: ScoreInputSection(
        onScoreAdded: (points) {
          widget.viewModel.addPoints(points);
        },
        onUndo: () {
          widget.viewModel.undo();
        },
      ),
      body: ListenableBuilder(
        listenable: widget.viewModel,
        builder: (context, _) {
          return Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    'Current round: ${widget.viewModel.currentRound}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Column(
                    spacing: 8,
                    children: List.generate(
                      widget.viewModel.players.length,
                      (i) => PlayerTile(
                        player: widget.viewModel.players[i],
                        isSelected: widget.viewModel.currentPlayerIndex == i,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _onViewModelChanged() {
    if (widget.viewModel.winner != null) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text('${widget.viewModel.winner} wins'),
            children: [
              FilledButton(
                onPressed: () {
                  context.pop();
                },
                child: const Text('Finish'),
              ),
            ],
          );
        },
      );
    }
  }
}
