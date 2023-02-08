import 'package:flutter/material.dart';
import '../widgets/homeToggle.dart';
import '../widgets/betFeedList.dart';
import '../classes/betFeedItem.dart';

class BetPage extends StatefulWidget {
  const BetPage({super.key});

  @override
  State<BetPage> createState() => _BetPageState();
}

class _BetPageState extends State<BetPage> {
  List<Bet> bets = [Bet('Amarins', 'Tia', 5, 5, 'she wont stfu')];
  @override
  Widget build(BuildContext context) {
    return BetFeedList(bets);
  }
}
