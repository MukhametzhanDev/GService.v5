import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/functions/token/changedToken.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/provider/adFavoriteProvider.dart';
import 'package:provider/provider.dart';

class FavoriteButton extends StatefulWidget {
  final Map data;
  final String type;
  FavoriteButton({super.key, required this.data, required this.type});

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
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
        "favoritable_type": widget.type
      });
    } catch (e) {
      print(e);
    }
  }

  void changedData(active) {
    setState(() {
      if (widget.type == "ad") {
        if (active) {
          Provider.of<AdFavoriteProvider>(context, listen: false).removeAd =
              widget.data;
          // FavoriteAdData.adFavorite.remove(widget.id);
        } else {
          Provider.of<AdFavoriteProvider>(context, listen: false).addAd =
              widget.data;

          // FavoriteAdData.adFavorite.addAll({widget.id: ""});
        }
      } else {
        if (active) {
          // FavoriteApplicationData.applicationFavorite.remove(widget.id);
        } else {
          // FavoriteApplicationData.applicationFavorite.addAll({widget.id: ""});
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print("DATA FAVORITE ${widget.data}");
    return Consumer<AdFavoriteProvider>(builder: (context, data, child) {
      print("CHECK ${data.checkAd(widget.data)}");
      return Container(
        height: 40,
        child: IconButton(
          onPressed: () => verifyToken(data.checkAd(widget.data)),
          icon: Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: data.checkAd(widget.data)
                    ? ColorComponent.red['500']
                    : const Color(0xffD1D5DB)),
            child: SvgPicture.asset('assets/icons/heart.svg'),
          ),
        ),
      );
    });
  }
}
