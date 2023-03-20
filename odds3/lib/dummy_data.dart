import 'classes/bet_feed_item.dart';
import 'classes/user.dart';

List<Bet> dummy_bets = [
  Bet(
      id: '12',
      bettorId: 'Amarins',
      receiverId: 'Tia',
      bettorAmount: 5,
      receiverAmount: 5,
      bettorProfileUrl:
          'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png',
      receiverProfileUrl:
          'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png',
      status: 1,
      timestampCreated: 1231231231231,
      betText: 'she wont go to berlin',
      bettorName: "Amarins",
      receiverName: "Tia"),
  Bet(
      id: '123',
      bettorId: 'Manko',
      receiverId: 'Gary',
      bettorAmount: 10,
      receiverAmount: 1,
      bettorProfileUrl:
          'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png',
      receiverProfileUrl:
          'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png',
      status: 1,
      timestampCreated: 23462934798234,
      betText: 'Eagles win superbowl',
      bettorName: "Manko",
      receiverName: "Gary"),
  Bet(
      id: '1234',
      bettorId: 'Rodri',
      receiverId: 'Jen',
      bettorAmount: 5,
      receiverAmount: 4,
      bettorProfileUrl:
          'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png',
      receiverProfileUrl:
          'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png',
      status: 0,
      timestampCreated: 89547983475043,
      betText: 'Firebase will crash on us',
      bettorName: "Rodri",
      receiverName: "Jen"),
  Bet(
      id: '12345',
      bettorId: 'Spencer',
      receiverId: 'Theo',
      bettorAmount: 10,
      receiverAmount: 1,
      bettorProfileUrl:
          'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png',
      receiverProfileUrl:
          'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png',
      status: 1,
      timestampCreated: 83749283497023,
      betText: 'Flutter will give us plenty of problems',
      bettorName: "Spencer",
      receiverName: "Theo")
];

List<CurUser> users = [
  CurUser(
      fullName: "Spencer",
      tokens: 20,
      betsWon: 10,
      betsLost: 2,
      username: '@spaul',
      uid: '789',
      photoURL: 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png'),
  CurUser(
      fullName: "Jen",
      tokens: 14,
      betsWon: 9,
      betsLost: 2,
      username: "@jen",
      uid: '678',
      photoURL: 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png'),
  CurUser(
      fullName: "Theo",
      tokens: 12,
      betsWon: 7,
      betsLost: 2,
      username: "@bigTay",
      uid: '567',
      photoURL: 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png'),
  CurUser(
      fullName: "Rodri",
      tokens: 12,
      betsWon: 6,
      betsLost: 1,
      username: "@Rj",
      uid: '456',
      photoURL: 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png'),
  CurUser(
      fullName: "Ethan",
      tokens: 10,
      betsWon: 5,
      betsLost: 3,
      username: "@EB",
      uid: '345',
      photoURL: 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png'),
  CurUser(
      fullName: "Jordan",
      tokens: 4,
      betsWon: 2,
      betsLost: 2,
      username: "@JT",
      uid: '234',
      photoURL: 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png'),
  CurUser(
      fullName: "Cat",
      tokens: 3,
      betsWon: 1,
      betsLost: 3,
      username: "@cat",
      uid: '123',
      photoURL: 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png'),
];
