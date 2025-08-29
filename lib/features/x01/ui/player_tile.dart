import 'package:darts_counter/features/x01/domain/models/player_model.dart';
import 'package:darts_counter/features/x01/domain/models/points_model.dart';
import 'package:flutter/material.dart';

class PlayerTile extends StatelessWidget {
  final bool isSelected;
  final PlayerModel player;
  const PlayerTile({super.key, this.isSelected = false, required this.player});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: isSelected ? Border.all(width: 1, color: Colors.red) : null,
      ),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Text(
                  player.score.toString(),
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(player.name, style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Row(
                  spacing: 4,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: player.currentRoundPoints
                      .map((e) => _ScoreField(points: e))
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ScoreField extends StatelessWidget {
  final Points points;
  const _ScoreField({required this.points});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      width: 35,
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Text(points.getString()),
    );
  }
}
