import 'package:darts_counter/features/x01/domain/models/points_model.dart';
import 'package:darts_counter/generated/l10n.dart';
import 'package:flutter/material.dart';

class ScoreInputSection extends StatefulWidget {
  final Function(Points score) onScoreAdded;
  final Function() onUndo;

  const ScoreInputSection({
    super.key,
    required this.onScoreAdded,
    required this.onUndo,
  });

  @override
  State<ScoreInputSection> createState() => _ScoreInputSectionState();
}

class _ScoreInputSectionState extends State<ScoreInputSection> {
  bool _isDoublingEnabled = false;
  bool _isTriplingEnabled = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 4,
              runSpacing: 4,
              children: [
                for (int i = 0; i <= 21; i++)
                  ScoreButton(
                    value: i == 21 ? 25 : i,
                    onPressed: (points) {
                      if (_isDoublingEnabled) {
                        if (i != 0) {
                          widget.onScoreAdded(DoublePoints(value: points));
                        }
                      } else if (_isTriplingEnabled) {
                        if (i != 21 && i != 0) {
                          widget.onScoreAdded(TriplePoints(value: points));
                        }
                      } else {
                        widget.onScoreAdded(RegularPoints(value: points));
                      }
                      setState(() {
                        _isDoublingEnabled = false;
                        _isTriplingEnabled = false;
                      });
                    },
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isTriplingEnabled = false;
                      _isDoublingEnabled = !_isDoublingEnabled;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isDoublingEnabled ? Colors.red : null,
                  ),
                  child: Text(S.of(context).double),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isDoublingEnabled = false;
                      _isTriplingEnabled = !_isTriplingEnabled;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isTriplingEnabled ? Colors.blue : null,
                  ),
                  child: Text(S.of(context).triple),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isDoublingEnabled = false;
                      _isTriplingEnabled = false;
                    });
                    widget.onUndo();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                  ),
                  child: const Icon(Icons.undo),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ScoreButton extends StatelessWidget {
  final int value;
  final Function(int) onPressed;

  const ScoreButton({super.key, required this.value, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onPressed(value),
      style: ElevatedButton.styleFrom(
        minimumSize: Size(MediaQuery.of(context).size.width / 8, 40),
      ),
      child: Text(value.toString()),
    );
  }
}
