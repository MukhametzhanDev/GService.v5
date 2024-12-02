import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/functions/token/changedToken.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/theme/colorComponent.dart';

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
      postData();
      widget.active = !widget.active;
      setState(() {});
    } else {
      SnackBarComponent().showErrorMessage(
          "Чтобы добавить в избранное, вы должны войти в личный кабинет",
          context);
    }
  }

  void postData() async {
    try {
      if (widget.active) {
        Response response = await dio.post("/remove-favorite",
            queryParameters: {
              "favoritable_id": widget.id,
              "favoritable_type": widget.type
            });
        widget.active = !widget.active;
        print(response.data);
      } else {
        Response response = await dio.post("/favorite", queryParameters: {
          "favoritable_id": widget.id,
          "favoritable_type": widget.type
        });
        widget.active = !widget.active;
        // counterClick("favorite", widget.data['class_name'], widget.data['id']);
        print(response.data);
      }
      // setState(() {});
    } catch (e) {
      print(e);
    }
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
            color:
                widget.active ? ColorComponent.red['500'] : Color(0xffD1D5DB)),
        child: SvgPicture.asset('assets/icons/heart.svg'),
      ),
    );
  }
}
