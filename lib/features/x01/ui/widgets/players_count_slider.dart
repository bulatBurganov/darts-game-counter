import 'package:flutter/material.dart';

class PlayerCountSlider extends StatefulWidget {
  final Function(int count) onChanged;
  final double? initialValue;
  const PlayerCountSlider({
    super.key,
    required this.onChanged,
    this.initialValue,
  });

  @override
  State<PlayerCountSlider> createState() => _PlayerCountSliderState();
}

class _PlayerCountSliderState extends State<PlayerCountSlider> {
  late double count;

  @override
  void initState() {
    count = widget.initialValue ?? 2;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          count.toInt().toString(),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Slider(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          min: 1,
          max: 16,
          divisions: 15,
          value: count,
          onChanged: (value) {
            setState(() {
              count = value;
              widget.onChanged(value.toInt());
            });
          },
        ),
      ],
    );
  }
}
