import 'classes/bet_feed_item.dart';
import 'classes/user.dart';

List<Bet> dummy_bets = [
  Bet(
      id: '12',
      bettor: 'Amarins',
      receiver: 'Tia',
      bettorAmount: 5,
      receiverAmount: 5,
      status: 1,
      betText: 'she wont go to berlin'),
  Bet(
      id: '123',
      bettor: 'Manko',
      receiver: 'Gary',
      bettorAmount: 10,
      receiverAmount: 1,
      status: 1,
      betText: 'Eagles win superbowl'),
  Bet(
      id: '1234',
      bettor: 'Rodri',
      receiver: 'Jen',
      bettorAmount: 5,
      receiverAmount: 4,
      status: 0,
      betText: 'Firebase will crash on us'),
  Bet(
      id: '12345',
      bettor: 'Spencer',
      receiver: 'Theo',
      bettorAmount: 10,
      receiverAmount: 1,
      status: 1,
      betText: 'Flutter will give us plenty of problems')
];

List<User> users = [
  User("Spencer", 20, 10, 2, '@spaul'),
  User("Jen", 14, 9, 2, "@jen"),
  User("Theo", 12, 7, 2, "@bigTay"),
  User("Rodri", 12, 6, 1, "@Rj"),
  User("Ethan", 10, 5, 3, "@EB"),
  User("Jordan", 4, 2, 2, "@JT"),
  User("Cat", 3, 1, 3, "@cat")
];
