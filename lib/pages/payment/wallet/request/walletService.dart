import 'package:dio/dio.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/pages/payment/wallet/request/walletModel.dart';

class WalletServices {
  Future<WalletModel> getData() async {
    late WalletModel walletModel;
    try {
      Response response = await dio.get("/user-wallet");
      print("RESP WWALLLETT ----> ${response.data}");
      if (response.data['success']) {
        walletModel = WalletModel.fromJson(response.data['data']);
      }
    } catch (e) {}
    return walletModel;
  }
}
