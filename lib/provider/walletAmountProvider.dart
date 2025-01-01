import 'package:flutter/material.dart';
import 'package:gservice5/pages/payment/wallet/request/walletService.dart';
import 'package:gservice5/pages/payment/wallet/request/walletModel.dart';

class WalletAmountProvider with ChangeNotifier {
  late WalletModel data;

  bool loading = false;
  WalletServices services = WalletServices();

  getData(context) async {
    loading = true;
    data = await services.getData();
    loading = false;
    notifyListeners();
  }
}
