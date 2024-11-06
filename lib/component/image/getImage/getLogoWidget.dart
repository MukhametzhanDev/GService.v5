import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/theme/colorComponent.dart';

class GetLogoWidget extends StatefulWidget {
  const GetLogoWidget({super.key});

  @override
  State<GetLogoWidget> createState() => _GetLogoWidgetState();
}

class _GetLogoWidgetState extends State<GetLogoWidget> {
  void getImage() {
    
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        child: Row(
          children: [
            SvgPicture.asset('assets/icons/getAvatar.svg'),
            Divider(indent: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Загрузить логотип компании",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: ColorComponent.gray['500'])),
                  Divider(height: 8),
                  Text("SVG, PNG, JPG или JPEG (MAX. 800x400px)",
                      style: TextStyle(
                          fontSize: 12, color: ColorComponent.gray['500'])),
                  Divider(height: 8),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    decoration: BoxDecoration(
                        color: ColorComponent.mainColor,
                        borderRadius: BorderRadius.circular(8)),
                    child: Text("Загрузить фото",
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w500)),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
