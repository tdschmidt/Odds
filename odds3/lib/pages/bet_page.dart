import 'package:flutter/material.dart';
import '../widgets/bet_feed_list.dart';
import '../classes/bet_feed_item.dart';

class BetPage extends StatefulWidget {
  const BetPage({super.key});

  @override
  State<BetPage> createState() => _BetPageState();
}

class _BetPageState extends State<BetPage> {
  List<Bet> bets = [
    Bet('Amarins', 'Tia', 5, 5, 'This screen to be replaced by bet place flow',
        1, 1, 0)
  ];
  @override
  Widget build(BuildContext context) {
    return BetFeedList(bets);
  }
}
