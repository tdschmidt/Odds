import 'package:flutter/src/widgets/framework.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:flutter/material.dart';

class MyToggleSwitch extends StatelessWidget {
  final Function(int) onChanged;
  final int label;

  const MyToggleSwitch(
      {super.key, required this.onChanged, required this.label});

  @override
  Widget build(BuildContext context) {
    return ToggleSwitch(
      minWidth: 120.0,
      minHeight: 30.0,
      cornerRadius: 10.0,
      activeBgColors: [
        [Theme.of(context).colorScheme.primary],
        [Theme.of(context).colorScheme.primary]
      ],
      activeFgColor: Theme.of(context).colorScheme.onPrimary,
      inactiveBgColor: Color.fromARGB(255, 255, 251, 240),
      inactiveFgColor: Theme.of(context).colorScheme.primary,
      initialLabelIndex: label,
      totalSwitches: 2,
      labels: ['Feed', 'Leaderboard'],
      radiusStyle: true,
      onToggle: (index) => {this.onChanged(index!)},
    );
  }
}
