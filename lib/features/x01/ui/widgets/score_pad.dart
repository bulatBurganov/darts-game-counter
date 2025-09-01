import 'package:darts_counter/features/x01/domain/models/points_model.dart';
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
    return Container(
      padding: EdgeInsets.only(
        left: 8,
        right: 8,
        top: 8,
        bottom: MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: [
              for (int i = 0; i <= 20; i++)
                ScoreButton(
                  value: i,
                  onPressed: (points) {
                    if (_isDoublingEnabled) {
                      widget.onScoreAdded(DoublePoints(value: points));
                    } else if (_isTriplingEnabled) {
                      widget.onScoreAdded(TriplePoints(value: points));
                    } else {
                      widget.onScoreAdded(RegularPoints(value: points));
                    }
                    setState(() {
                      _isDoublingEnabled = false;
                      _isTriplingEnabled = false;
                    });
                  },
                ),
              ScoreButton(
                value: 25,
                onPressed: (points) =>
                    widget.onScoreAdded(RegularPoints(value: points)),
              ),
            ],
          ),
          SizedBox(height: 8),
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
                child: Text(
                  'Double',
                  style: TextStyle(
                    color: _isDoublingEnabled ? Colors.white : Colors.black,
                  ),
                ),
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
                child: Text(
                  'Triple',
                  style: TextStyle(
                    color: _isTriplingEnabled ? Colors.white : Colors.black,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: widget.onUndo,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                child: Icon(Icons.undo),
              ),
            ],
          ),
        ],
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
      style: ElevatedButton.styleFrom(minimumSize: Size(40, 40)),
      child: Text(value.toString(), style: TextStyle(fontSize: 16)),
    );
  }
}
