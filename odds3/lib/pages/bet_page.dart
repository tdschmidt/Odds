import 'package:flutter/material.dart';
import 'package:odds3/classes/bet_feed_item.dart';
import 'package:odds3/classes/state_management.dart';
import 'package:provider/provider.dart';

class BetPage extends StatefulWidget {
  const BetPage({super.key});

  @override
  State<BetPage> createState() => _BetPageState();
}

class _BetPageState extends State<BetPage> {
  TextEditingController _friendController = TextEditingController();
  TextEditingController _yourRiskController = TextEditingController();
  TextEditingController _theirRiskController = TextEditingController();
  TextEditingController _betTextController = TextEditingController();

  void click(StateManagement state) {
    String friend = _friendController.text;
    String yourBet = _yourRiskController.text;
    String theirBet = _theirRiskController.text;
    String betText = _betTextController.text;

    Bet newBet = Bet(
        id: "temporary",
        bettor: 'You',
        receiver: friend,
        bettorAmount: int.parse(yourBet),
        receiverAmount: int.parse(theirBet),
        betText: betText,
        status: 0);

    state.makeBet(newBet);

    _friendController.clear();
    _yourRiskController.clear();
    _theirRiskController.clear();
    _betTextController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<StateManagement>(context);

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 100.0),
        child: Column(
          children: [
            TextField(
              controller: _friendController,
              decoration: InputDecoration(labelText: 'Friend to bet against'),
            ),
            TextField(
              controller: _yourRiskController,
              decoration: InputDecoration(labelText: 'Your risk'),
            ),
            TextField(
              controller: _theirRiskController,
              decoration: InputDecoration(labelText: 'Their risk'),
            ),
            TextField(
              controller: _betTextController,
              decoration: InputDecoration(labelText: 'Bet text'),
            ),
            ElevatedButton(
              onPressed: () => click(state),
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
