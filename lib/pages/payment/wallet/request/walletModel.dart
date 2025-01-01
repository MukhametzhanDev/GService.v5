class WalletModel {
  int? amount;
  int? bonus;

  WalletModel({this.amount});

  WalletModel.fromJson(Map<String, dynamic> json) {
    amount = json['wallet']['balance'];
    bonus = json['bonus']['balance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount'] = this.amount;
    data['bonus'] = this.bonus;
    return data;
  }
}
