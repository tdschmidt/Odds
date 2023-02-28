import 'package:flutter/material.dart';
import 'package:odds3/widgets/me_feed_list.dart';
import 'package:odds3/classes/state_management.dart';
import 'package:provider/provider.dart';
import '../widgets/me_toggle_bar.dart';
import '../widgets/profile_headder.dart';
import '../dummy_data.dart';
import '../classes/user.dart';
import '../widgets/bet_feed_list.dart';

class MePage extends StatefulWidget {
  const MePage({super.key});

  @override
  State<MePage> createState() => _MePageState();
}

class _MePageState extends State<MePage> {
  int _toggleValue = 0;
  final User user = users[0];
  void _updateToggleValue(int index) {
    setState(() {
      _toggleValue = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<StateManagement>(context);
    return Column(
      children: [
        UserProfile(user),
        MeToggle(
            toggleValue: _toggleValue, updateToggleValue: _updateToggleValue),
        Expanded(child: Consumer<StateManagement>(
            builder: (context, state, _) {
              return MeFeedList(state.bets, _toggleValue);
            },
          ),
        ),
      ],
    );
  }
}