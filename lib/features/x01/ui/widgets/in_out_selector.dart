import 'package:darts_counter/features/x01/domain/models/x01_settings_model.dart';
import 'package:flutter/material.dart';

class InOutModeSelector extends StatefulWidget {
  const InOutModeSelector({
    super.key,
    required this.onCahnged,
    this.swithDuration = const Duration(milliseconds: 500),
    this.height = 50,
    this.padding = 4,
    this.initialValue,
    this.selectorColor,
    this.backgroundColor,
  });
  final Duration swithDuration;
  final double height;
  final double padding;
  final InOutModes? initialValue;
  final Function(InOutModes mode) onCahnged;
  final Color? selectorColor;
  final Color? backgroundColor;

  @override
  State<InOutModeSelector> createState() => _InOutModeSelectorState();
}

class _InOutModeSelectorState extends State<InOutModeSelector> {
  int _selectedIndex = 0;
  @override
  void initState() {
    if (widget.initialValue != null) {
      _selectedIndex = InOutModes.values.indexOf(widget.initialValue!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth =
            constraints.maxWidth / InOutModes.values.length -
            widget.padding / 2;
        return Column(
          children: [
            Material(
              elevation: 4,
              clipBehavior: Clip.antiAlias,
              borderRadius: BorderRadius.circular(24),
              child: Container(
                height: widget.height,
                padding: EdgeInsets.all(widget.padding),
                decoration: BoxDecoration(color: widget.backgroundColor),
                child: Stack(
                  children: [
                    AnimatedPositioned(
                      curve: Curves.easeInOutCubicEmphasized,
                      duration: widget.swithDuration,
                      left: itemWidth * _selectedIndex,
                      child: Container(
                        width: itemWidth,
                        height: widget.height - widget.padding * 2,
                        decoration: BoxDecoration(
                          color: widget.selectorColor ?? Colors.blue,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    Row(
                      children: List.generate(
                        InOutModes.values.length,
                        (index) => Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() {
                              _selectedIndex = index;
                              widget.onCahnged(InOutModes.values[index]);
                            }),
                            child: Container(
                              color: Colors.transparent,
                              height: widget.height - widget.padding * 2,
                              alignment: Alignment.center,
                              child: AnimatedDefaultTextStyle(
                                curve: Curves.easeInOutCubicEmphasized,
                                duration: widget.swithDuration,
                                style: TextStyle(
                                  color: (_selectedIndex == index)
                                      ? Colors.white
                                      : Theme.of(context).colorScheme.onSurface,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                child: Text(
                                  key: ValueKey<String>(
                                    InOutModes.values[index].name,
                                  ),
                                  textAlign: TextAlign.center,
                                  _getModeName(
                                    InOutModes.values[index],
                                    context,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  String _getModeName(InOutModes mode, BuildContext context) {
    return switch (mode) {
      InOutModes.straight => 'Straight',
      InOutModes.double => 'Double',
      InOutModes.triple => 'Triple',
    };
  }
}
