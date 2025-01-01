import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/formatted/price/priceFormat.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/payment/wallet/request/walletService.dart';
import 'package:gservice5/provider/walletAmountProvider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ShowWalletWidget extends StatefulWidget {
  final bool showButton;
  const ShowWalletWidget({super.key, required this.showButton});

  @override
  State<ShowWalletWidget> createState() => _ShowWalletWidgetState();
}

class _ShowWalletWidgetState extends State<ShowWalletWidget> {
  WalletServices services = WalletServices();

  @override
  void initState() {
    super.initState();
    Provider.of<WalletAmountProvider>(context, listen: false).getData(context);
  }

  void showPage() {
    Navigator.pushNamed(context, "ReplenishmentWalletPage");
  }

  void showTransactionHistoryPage() {
    Navigator.pushNamed(context, "TransactionHistoryPage");
  }

  String formattedPrice(int cost) {
    String price = NumberFormat.currency(locale: 'kk', symbol: '')
        .format(cost)
        .toString()
        .split(',')[0];
    return price;
  }

  @override
  Widget build(BuildContext context) {
    final walletAmount = Provider.of<WalletAmountProvider>(context);
    return Container(
      decoration: const BoxDecoration(
          border:
              Border(bottom: BorderSide(width: 1, color: Color(0xffeeeeee)))),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.showButton
                    ? const Padding(
                        padding: EdgeInsets.only(bottom: 6),
                        child: Text("Баланс",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600)),
                      )
                    : Container(),
                walletAmount.loading
                    ? Shimmer.fromColors(
                        baseColor: const Color(0xffD1D5DB),
                        highlightColor: const Color(0xfff4f5f7),
                        period: const Duration(seconds: 1),
                        child: Container(
                            width: 100,
                            height: 29,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10))),
                      )
                    : Text(formattedPrice(walletAmount.data.amount as int),
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600)),
                const Divider(height: 6),
                walletAmount.loading
                    ? Shimmer.fromColors(
                        baseColor: const Color(0xffD1D5DB),
                        highlightColor: const Color(0xfff4f5f7),
                        period: const Duration(seconds: 1),
                        child: Container(
                            width: 70,
                            height: 17,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(6))),
                      )
                    : Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                            color: ColorComponent.mainColor.withOpacity(.2),
                            borderRadius: BorderRadius.circular(112)),
                        child: Text(
                          "${formattedPrice(walletAmount.data.bonus as int)} Б",
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ),
                widget.showButton
                    ? Container(
                        margin: const EdgeInsets.only(top: 12),
                        height: 42,
                        child: Row(
                          children: [
                            Expanded(
                                child: Button(
                                    onPressed: showPage,
                                    title: "Пополнить баланс")),
                            const Divider(indent: 8),
                            GestureDetector(
                              onTap: showTransactionHistoryPage,
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Row(
                                  children: [
                                    Text("История",
                                        style: TextStyle(
                                          color: ColorComponent.gray['500'],
                                          fontWeight: FontWeight.w500,
                                        )),
                                    const Divider(indent: 8),
                                    SvgPicture.asset(
                                        'assets/icons/arrowRight.svg')
                                  ],
                                ),
                              ),
                            )
                          ],
                        ))
                    : Container(),
              ],
            ),
          ),
          widget.showButton
              ? Container()
              : CircleAvatar(
                  backgroundColor: ColorComponent.mainColor,
                  radius: 25,
                  child: IconButton(
                      onPressed: showPage,
                      color: ColorComponent.mainColor,
                      icon: SvgPicture.asset("assets/icons/plusOutline.svg")),
                )
        ],
      ),
    );
  }
}
