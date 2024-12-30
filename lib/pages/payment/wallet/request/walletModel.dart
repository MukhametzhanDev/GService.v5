class WalletModel {
  String? amount;
  String? bonus;

  WalletModel({this.amount});

  WalletModel.fromJson(Map<String, dynamic> json) {
    amount = json['wallet']['amount'];
    bonus = json['bonus']['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount'] = this.amount;
    data['bonus'] = this.bonus;
    return data;
  }
}
