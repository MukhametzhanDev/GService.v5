class WalletModel {
  int? amount;
  int? bonus;
  int? walletId;

  WalletModel({this.amount});

  WalletModel.fromJson(Map<String, dynamic> json) {
    amount = json['wallet']['balance'];
    bonus = json['bonus']['balance'];
    walletId = json['wallet']['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amount'] = amount;
    data['bonus'] = bonus;
    data['walletId'] = walletId;
    return data;
  }
}
