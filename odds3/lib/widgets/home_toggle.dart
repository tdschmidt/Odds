import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

class HomeToggle extends StatelessWidget {
  final void Function(int) updateToggleValue;
  final int toggleValue;
  const HomeToggle(
      {super.key, required this.toggleValue, required this.updateToggleValue});

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
      activeFgColor: Colors.white,
      inactiveBgColor: Colors.grey,
      inactiveFgColor: Colors.white,
      initialLabelIndex: 0,
      totalSwitches: 2,
      labels: ['Feed', 'Leaderboard'],
      radiusStyle: true,
      onToggle: (index) => {updateToggleValue},
    );
  }
}
