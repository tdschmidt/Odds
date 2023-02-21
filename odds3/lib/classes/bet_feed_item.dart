class Bet {
  String bettor;
  String receiver;
  int betterAmount = 0;
  int receiverAmount = 0;
  String betText;
  bool userLiked = false;
  int status = 0; //replace with acceptedStatus
  int closed = 0; //1 if bet has closed
  int winner = 0; //1 if bettor won, 0 if reveiver
  //add winner

  Bet(this.bettor, this.receiver, this.betterAmount, this.receiverAmount,
      this.betText, this.status, this.closed, this.winner);

  void acceptBet() {
    status = 1;
  }

  void concedeBet() {}
}
