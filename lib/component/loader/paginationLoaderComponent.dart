import 'package:flutter/material.dart';
import 'package:gservice5/component/theme/colorComponent.dart';

class PaginationLoaderComponent extends StatelessWidget {
  const PaginationLoaderComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 60,
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
                color: ColorComponent.mainColor, strokeWidth: 3)));
  }
}
