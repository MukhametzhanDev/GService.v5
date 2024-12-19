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
  int categoryId = CreateData.data['category_id'];

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future getData() async {
    role = await ChangedToken().getRole();
    print(" `categoryId` $categoryId");
    setState(() {});
    if (role != "individual" && (categoryId == 1 || categoryId == 4)) {
      try {
        Response response = await dio.get("/company-currency",
            queryParameters: {"category_id": categoryId});
        print(response.data);
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
      } on DioException catch (e) {
        print(e.response);
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
    if (role == "individual" && categoryId == 1 && categoryId == 4) {
      return Container();
    } else {
      return GestureDetector(
        onTap: () {
          showGetCurrencyModal();
        },
        child: Container(
          height: 48,
          width: 70,
          margin: const EdgeInsets.only(left: 12),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: const Color(0xffF9FAFB),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(width: 1, color: const Color(0xffE5E5EA))),
          child: loader
              ? Shimmer.fromColors(
                  baseColor: const Color(0xffD1D5DB),
                  highlightColor: const Color(0xfff4f5f7),
                  period: const Duration(seconds: 1),
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
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500)),
                    const Divider(indent: 8),
                    SvgPicture.asset('assets/icons/down.svg'),
                  ],
                ),
        ),
      );
    }
  }
}
