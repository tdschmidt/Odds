import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

class MeToggle extends StatelessWidget {
  final void Function(int) updateToggleValue;
  final int toggleValue;
  const MeToggle(
      {super.key, required this.toggleValue, required this.updateToggleValue});

  @override
  Widget build(BuildContext context) {
    return ToggleSwitch(
      minWidth: 120.0,
      minHeight: 30.0,
      cornerRadius: 10.0,
      activeBgColors: [
        [Theme.of(context).colorScheme.primary],
        [Theme.of(context).colorScheme.primary],
        [Theme.of(context).colorScheme.primary]
      ],
      activeFgColor: Theme.of(context).colorScheme.onPrimary,
      inactiveBgColor: Color.fromARGB(255, 255, 251, 240),
      inactiveFgColor: Theme.of(context).colorScheme.primary,
      initialLabelIndex: toggleValue,
      totalSwitches: 3,
      labels: const ['All', 'Pending', 'Settled'],
      radiusStyle: true,
      onToggle: (index) => {updateToggleValue(index!)},
    );
  }
}
