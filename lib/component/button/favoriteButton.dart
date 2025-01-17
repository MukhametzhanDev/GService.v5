import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/counter/counterClickStatistic.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/functions/token/changedToken.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/favorite/ad/data/favoriteAdData.dart';
import 'package:gservice5/pages/favorite/application/data/favoriteApplicationData.dart';

class FavoriteButton extends StatefulWidget {
  final int id;
  bool active;
  final String type;
  FavoriteButton(
      {super.key, required this.id, required this.active, required this.type});

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  bool activeFavourite = false;

  void verifyToken() async {
    bool havedToken = await ChangedToken().getToken() != null;
    if (havedToken) {
      changedData();
      postData();
      widget.active = !widget.active;
      setState(() {});
    } else {
      SnackBarComponent().showErrorMessage(
          "Чтобы добавить в избранное, вы должны войти в личный кабинет",
          context);
    }
  }

  Future postData() async {
    try {
      if (widget.active) {
        Response response = await dio.post("/remove-favorite",
            queryParameters: {
              "favoritable_id": widget.id,
              "favoritable_type": widget.type
            });
        print(response.data);
      } else {
        Response response = await dio.post("/favorite", queryParameters: {
          "favoritable_id": widget.id,
          "favoritable_type": widget.type
        });
      }
    } catch (e) {
      print(e);
    }
  }

  void changedData() {
    setState(() {
      if (widget.type == "ad") {
        if (widget.active) {
          FavoriteAdData.adFavorite.remove(widget.id);
        } else {
          FavoriteAdData.adFavorite.addAll({widget.id: ""});
        }
      } else {
        if (widget.active) {
          FavoriteApplicationData.applicationFavorite.remove(widget.id);
        } else {
          FavoriteApplicationData.applicationFavorite.addAll({widget.id: ""});
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => verifyToken(),
      child: Container(
        width: 24,
        height: 24,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: widget.active
                ? ColorComponent.red['500']
                : const Color(0xffD1D5DB)),
        child: SvgPicture.asset('assets/icons/heart.svg'),
      ),
    );
  }
}
