import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/functions/token/changedToken.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/provider/adFavoriteProvider.dart';
import 'package:provider/provider.dart';

class FavoriteAdButton extends StatefulWidget {
  final Map data;
  const FavoriteAdButton({super.key, required this.data});

  @override
  State<FavoriteAdButton> createState() => _FavoriteAdButtonState();
}

class _FavoriteAdButtonState extends State<FavoriteAdButton> {
  bool activeFavourite = false;

  void verifyToken(bool active) async {
    bool havedToken = await ChangedToken().getToken() != null;
    if (havedToken) {
      changedData(active);
      postData(active);
    } else {
      SnackBarComponent().showErrorMessage(
          "Чтобы добавить в избранное, вы должны войти в личный кабинет",
          context);
    }
  }

  Future postData(active) async {
    try {
      String API = active ? "/remove-favorite" : "/favorite";
      await dio.post(API, queryParameters: {
        "favoritable_id": widget.data['id'],
        "favoritable_type": "ad"
      });
    } catch (e) {
      print(e);
    }
  }

  void changedData(active) {
    if (active) {
      Provider.of<AdFavoriteProvider>(context, listen: false).removeAd =
          widget.data;
    } else {
      Provider.of<AdFavoriteProvider>(context, listen: false).addAd =
          widget.data;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AdFavoriteProvider>(builder: (context, data, child) {
      return SizedBox(
        height: 40,
        child: IconButton(
          onPressed: () => verifyToken(data.checkAd(widget.data)),
          icon: Container(
              width: 24,
              height: 24,
              alignment: Alignment.center,
              // decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(4),
              //     color: data.checkAd(widget.data)
              //         ? ColorComponent.red['500']
              //         : const Color(0xffD1D5DB)),
              child: data.checkAd(widget.data)
                  ? SvgPicture.asset('assets/icons/heart.svg',
                      color: ColorComponent.red['500'])
                  : SvgPicture.asset('assets/icons/heartOutline.svg',
                      color: ColorComponent.gray['500'])),
        ),
      );
    });
  }
}
