
class Bet {
  String bettor;
  String receiver;
  int betterAmount = 0;
  int receiverAmount = 0;
  String betText;
  bool userLiked = false;
  int status = 0;

  Bet(this.bettor, this.receiver, this.betterAmount, this.receiverAmount,
      this.betText, this.status);

  void acceptBet() {
    status = 1;
  }

  void concedeBet() {}
}
