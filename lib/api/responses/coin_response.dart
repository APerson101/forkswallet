class CoinResponse {
  String parentCoinInfo;
  String puzzleHash;
  int amount;

  CoinResponse(
      {required this.parentCoinInfo,
      required this.puzzleHash,
      required this.amount});

  CoinResponse.fromJson(Map<String, dynamic> json)
      : parentCoinInfo = '0x' + json['parent_coin_info'],
        puzzleHash = '0x' + json['puzzle_hash'],
        amount = int.parse(json['amount']);

  Map<String, dynamic> toJson() => {
        'parent_coin_info': parentCoinInfo,
        'puzzle_hash': puzzleHash,
        'amount': amount
      };
}
