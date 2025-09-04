import 'package:darts_counter/features/x01/ui/x01_settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class X01WrapperScreen extends StatefulWidget {
  final Widget child;
  final X01SettingsViewModel viewModel;
  const X01WrapperScreen({
    super.key,
    required this.child,
    required this.viewModel,
  });

  @override
  State<X01WrapperScreen> createState() => _X01WrapperScreenState();
}

class _X01WrapperScreenState extends State<X01WrapperScreen> {
  late X01SettingsViewModel vm;

  @override
  void initState() {
    vm = widget.viewModel;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(value: vm, child: widget.child);
  }
}
