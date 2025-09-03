import 'package:flutter/material.dart';

class AppRoundedButton extends StatelessWidget {
  final VoidCallback onTap;
  final String? text;
  final Color? textColor;
  final Widget? prefix;
  final Widget? suffix;
  final Color? color;
  final double? height;

  final double borderRadius;
  const AppRoundedButton({
    this.text,
    super.key,
    this.suffix,
    this.prefix,
    this.color,
    this.textColor,
    this.height = 50,
    required this.onTap,
    this.borderRadius = 50,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(borderRadius),
      ),
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: height,
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              prefix ?? const Offstage(),
              Text(
                text ?? '',
                style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              suffix ?? const Offstage(),
            ],
          ),
        ),
      ),
    );
  }
}
