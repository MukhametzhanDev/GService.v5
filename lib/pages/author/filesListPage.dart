import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/button/back/backTitleButton.dart';
import 'package:gservice5/component/theme/colorComponent.dart';

class FilesListPage extends StatefulWidget {
  const FilesListPage({super.key});

  @override
  State<FilesListPage> createState() => _FilesListPageState();
}

class _FilesListPageState extends State<FilesListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 200,
        leading: const BackTitleButton(title: "Сертификаты"),
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return Container(
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: ColorComponent.gray["100"]!))),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Row(
                  children: [
                    CircleAvatar(
                        backgroundColor: ColorComponent.mainColor,
                        child: SvgPicture.asset('assets/icons/file.svg',
                            color: Colors.black)),
                    const Divider(indent: 16),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Сертификат",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                        const Divider(height: 4),
                        Text("Сертификат на продукцию",
                            style: TextStyle(
                                color: ColorComponent.gray['500'],
                                fontSize: 13))
                      ],
                    )),
                    SvgPicture.asset("assets/icons/right.svg")
                  ],
                ),
              )
              // ListTile(
              //   title: Text("Сертификат"),
              //   trailing: SvgPicture.asset("assets/icons/right.svg"),
              //   subtitle: Text(
              //     "Сертификат на продукцию",
              //     style: TextStyle(color: ColorComponent.gray['500']),
              //   ),
              // )
              );
        },
      ),
    );
  }
}
