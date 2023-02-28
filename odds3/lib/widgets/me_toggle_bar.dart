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
        [Colors.blue[100]!],
        [Colors.blue[100]!],
        [Colors.blue[100]!]
      ],
      activeFgColor: Colors.white,
      inactiveBgColor: Colors.grey,
      inactiveFgColor: Colors.white,
      initialLabelIndex: toggleValue,
      totalSwitches: 3,
      labels: const ['All', 'Pending', 'Resolved'],
      radiusStyle: true,
      onToggle: (index) => {updateToggleValue(index!)},
    );
  }
}