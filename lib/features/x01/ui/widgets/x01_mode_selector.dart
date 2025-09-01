import 'package:darts_counter/features/x01/domain/constants/x01_params.dart';
import 'package:flutter/material.dart';

class X01ModeSelector extends StatefulWidget {
  final X01Modes? initialValue;
  final Function(X01Modes mode) onModeChanged;

  const X01ModeSelector({
    super.key,
    required this.onModeChanged,
    this.initialValue,
  });

  @override
  State<X01ModeSelector> createState() => _X01ModeSelectorState();
}

class _X01ModeSelectorState extends State<X01ModeSelector> {
  late X01Modes selected;

  @override
  void initState() {
    selected = widget.initialValue ?? X01Modes.x301;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Mode',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: () async {
            final res = await showModalBottomSheet<X01Modes>(
              context: context,
              builder: (context) => const X01ModeSelectorBottomSheet(),
            );
            if (res != null) {
              setState(() {
                selected = res;
                widget.onModeChanged(res);
              });
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.black),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selected.name.replaceAll('x', ''),
                  style: const TextStyle(fontSize: 16),
                ),
                const Icon(Icons.keyboard_arrow_down_outlined),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class X01ModeSelectorBottomSheet extends StatelessWidget {
  const X01ModeSelectorBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 8),
        Container(
          height: 8,
          width: 64,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        ListView.separated(
          shrinkWrap: true,
          itemBuilder: (context, index) => GestureDetector(
            onTap: () {
              Navigator.of(context).pop(X01Modes.values[index]);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                X01Modes.values[index].name.replaceAll('x', ''),
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
          separatorBuilder: (context, index) => const SizedBox(height: 4),
          itemCount: X01Modes.values.length,
        ),
        SizedBox(height: MediaQuery.of(context).padding.bottom),
      ],
    );
  }
}
