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
    Bet(
        id: '12345',
        bettor: 'Amarins',
        receiver: 'Tia',
        bettorAmount: 5,
        receiverAmount: 5,
        status: 1,
        betText: 'she wont stfu')
  ];
  @override
  Widget build(BuildContext context) {
    return BetFeedList(bets);
  }
}
