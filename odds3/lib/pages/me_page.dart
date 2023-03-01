import 'package:flutter/material.dart';
import 'package:odds3/widgets/me_feed_list.dart';
import 'package:provider/provider.dart';
import '../classes/bets_provider.dart';
import '../widgets/me_toggle_bar.dart';
import '../widgets/profile_headder.dart';

class MePage extends StatefulWidget {
  const MePage({super.key});

  @override
  State<MePage> createState() => _MePageState();
}

class _MePageState extends State<MePage> {
  int _toggleValue = 0;
  void _updateToggleValue(int index) {
    setState(() {
      _toggleValue = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final betsState = Provider.of<BetsProvider>(context);
    return Column(
      children: [
        UserProfile(),
        MeToggle(
            toggleValue: _toggleValue, updateToggleValue: _updateToggleValue),
        Expanded(
          child: Consumer<BetsProvider>(
            builder: (context, state, _) {
              return MeFeedList(state.bets, _toggleValue);
            },
          ),
        ),
      ],
    );
  }
}
