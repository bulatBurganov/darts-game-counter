import 'package:darts_counter/features/navigation/routes.dart';
import 'package:darts_counter/features/x01/domain/x01_game_view_model.dart';
import 'package:darts_counter/features/x01/ui/widgets/player_tile.dart';
import 'package:darts_counter/features/x01/ui/widgets/score_pad.dart';
import 'package:darts_counter/generated/l10n.dart';
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
      appBar: AppBar(title: Text(S.of(context).x01)),
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
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        S.of(context).currentRound,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        widget.viewModel.currentRound.toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
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
        context: context,
        builder: (context) {
          return SimpleDialog(
            contentPadding: const EdgeInsetsGeometry.all(8),
            title: Text(
              S
                  .of(context)
                  .playerWins(S.of(context).playerN(widget.viewModel.winner!)),
            ),
            children: [
              FilledButton(
                onPressed: () {
                  context.pop();
                  context.go(Routes.mainMenu);
                },
                child: Text(S.of(context).finish),
              ),
            ],
          );
        },
      );
    }
  }
}
