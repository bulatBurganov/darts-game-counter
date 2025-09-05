import 'package:darts_counter/features/x01/domain/models/points_model.dart';
import 'package:flutter/material.dart';

class HintPanel extends StatelessWidget {
  final List<Points>? hints;
  const HintPanel({super.key, required this.hints});

  @override
  Widget build(BuildContext context) {
    return hints == null
        ? const Offstage()
        : Material(
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(8),
            ),
            elevation: 4,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainer,
              ),
              child: Row(
                spacing: 8,
                mainAxisSize: MainAxisSize.min,
                children: hints!
                    .map(
                      (e) => Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width / 10,
                        padding: const EdgeInsets.all(4),

                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        child: Text(
                          e.getString(),
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Theme.of(
                              context,
                            ).colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          );
  }
}
