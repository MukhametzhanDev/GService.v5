import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/formatted/price/priceFormat.dart';
import 'package:gservice5/component/theme/colorComponent.dart';

class ShowWalletWidget extends StatefulWidget {
  final bool showButton;
  const ShowWalletWidget({super.key, required this.showButton});

  @override
  State<ShowWalletWidget> createState() => _ShowWalletWidgetState();
}

class _ShowWalletWidgetState extends State<ShowWalletWidget> {
  void showPage() {
    Navigator.pushNamed(context, "ReplenishmentWalletPage");
  }

  void showTransactionHistoryPage() {
    Navigator.pushNamed(context, "TransactionHistoryPage");
  }

  @override
  Widget build(BuildContext context) {
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
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: const Text("Баланс",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600)),
                      )
                    : Container(),
                Text(priceFormat(1000000),
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w600)),
                const Divider(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                      color: ColorComponent.mainColor.withOpacity(.2),
                      borderRadius: BorderRadius.circular(112)),
                  child: Text(
                    "${priceFormat(100000)} Б",
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
                widget.showButton
                    ? Container(
                        margin: EdgeInsets.only(top: 12),
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