import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/functions/token/changedToken.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/provider/applicationFavoriteProvider.dart';
import 'package:provider/provider.dart';

class FavoriteApplicationButton extends StatefulWidget {
  final Map data;
  const FavoriteApplicationButton({super.key, required this.data});

  @override
  State<FavoriteApplicationButton> createState() =>
      _FavoriteApplicationButtonState();
}

class _FavoriteApplicationButtonState extends State<FavoriteApplicationButton> {
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
        "favoritable_type": "application"
      });
    } catch (e) {
      print(e);
    }
  }

  void changedData(active) {
    if (active) {
      Provider.of<ApplicationFavoriteProvider>(context, listen: false)
          .removeApplication = widget.data;
    } else {
      Provider.of<ApplicationFavoriteProvider>(context, listen: false)
          .addApplication = widget.data;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationFavoriteProvider>(
        builder: (context, data, child) {
      return SizedBox(
        height: 40,
        child: IconButton(
          onPressed: () => verifyToken(data.checkApplication(widget.data)),
          icon: Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: data.checkApplication(widget.data)
                    ? ColorComponent.red['500']
                    : const Color(0xffD1D5DB)),
            child: SvgPicture.asset('assets/icons/heart.svg'),
          ),
        ),
      );
    });
  }
}
