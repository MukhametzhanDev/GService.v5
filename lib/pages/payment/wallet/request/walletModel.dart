class WalletModel {
  int? amount;
  int? bonus;

  WalletModel({this.amount});

  WalletModel.fromJson(Map<String, dynamic> json) {
    amount = json['wallet']['balance'];
    bonus = json['bonus']['balance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amount'] = amount;
    data['bonus'] = bonus;
    return data;
  }
}
