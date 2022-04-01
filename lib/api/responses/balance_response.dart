class BalanceResponse {
  int? balance;

  BalanceResponse({this.balance});

  BalanceResponse.fromJson(Map<String, dynamic> json) {
    balance = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount'] = this.balance;
    return data;
  }
}
