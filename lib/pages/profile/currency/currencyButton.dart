import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/functions/token/changedToken.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/pages/create/data/createData.dart';
import 'package:gservice5/pages/profile/currency/getCurrencyModal.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shimmer/shimmer.dart';

class CurrencyButton extends StatefulWidget {
  const CurrencyButton({super.key});

  @override
  State<CurrencyButton> createState() => _CurrencyButtonState();
}

class _CurrencyButtonState extends State<CurrencyButton> {
  List data = [];
  bool loader = true;
  Map currentData = {};
  String role = "";

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future getData() async {
    role = await ChangedToken().getRole();
    setState(() {});
    if (role != "individual") {
      try {
        Response response = await dio.get("/company-currency");
        if (response.data['success']) {
          data = response.data['data'];
          currentData = response.data['data'][0];
          CreateData.data['currency_id'] =
              response.data['data'][0]['currency']['id'];
          loader = false;
          setState(() {});
        } else {
          SnackBarComponent().showResponseErrorMessage(response, context);
        }
      } catch (e) {
        SnackBarComponent().showNotGoBackServerErrorMessage(context);
      }
    }
  }

  void showGetCurrencyModal() {
    showCupertinoModalBottomSheet(
      context: context,
      builder: (context) {
        return GetCurrencyModal(data: data, currentData: currentData);
      },
    ).then((value) {
      currentData = value;
      CreateData.data['currency_id'] = value['currency']['id'];
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (role == "individual") {
      return Container();
    } else {
      return GestureDetector(
        onTap: () {
          showGetCurrencyModal();
        },
        child: Container(
          height: 48,
          width: 70,
          margin: EdgeInsets.only(left: 12),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Color(0xffF9FAFB),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(width: 1, color: Color(0xffE5E5EA))),
          child: loader
              ? Shimmer.fromColors(
                  baseColor: Color(0xffD1D5DB),
                  highlightColor: Color(0xfff4f5f7),
                  period: Duration(seconds: 1),
                  child: Container(
                      height: 48,
                      width: 70,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8))),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(currentData['currency']['symbol'],
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500)),
                    Divider(indent: 8),
                    SvgPicture.asset('assets/icons/down.svg'),
                  ],
                ),
        ),
      );
    }
  }
}
