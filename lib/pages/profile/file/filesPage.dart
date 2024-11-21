import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/button/back/backIconButton.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';
import 'package:gservice5/pages/profile/file/addFilePage.dart';

class FilesPage extends StatefulWidget {
  FilesPage({super.key});

  @override
  State<FilesPage> createState() => _FilesPageState();
}

class _FilesPageState extends State<FilesPage> {
  List<Map<String, String>> files = [];

  void deleteFile(int index) {
    setState(() {
      files.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: BackIconButton(),
        centerTitle: false,
        title: Text("Документы"),
      ),
      body: files.isEmpty
          ? Center(child: Text("Пока у вас нет документов"))
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: files.length,
              itemBuilder: (context, index) {
                final file = files[index];
                return Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 1, color: Colors.grey.withOpacity(0.2)),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: EdgeInsets.all(12),
                      child: Row(
                        children: [
                          SvgPicture.asset("assets/icons/fileCard.svg"),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(file['title'] ?? '',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600)),
                                Text(
                                    "${file['size'] ?? ''}, ${file['type'] ?? ''}",
                                    style: TextStyle(
                                        color: ColorComponent.gray['500'])),
                              ],
                            ),
                          ),
                          GestureDetector(
                            child:
                                SvgPicture.asset("assets/icons/editBadge.svg"),
                          ),
                          SizedBox(width: 8),
                          GestureDetector(
                            onTap: () => deleteFile(index),
                            child: SvgPicture.asset(
                                "assets/icons/deleteBadge.svg"),
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                  ],
                );
              },
            ),
      bottomNavigationBar: BottomNavigationBarComponent(
        child: Button(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddFilePage()),
            ).then((value) {
              if (value != null) {
                setState(() {
                  files.add(value);
                });
              }
            });
          },
          backgroundColor: ColorComponent.mainColor,
          titleColor: Colors.black,
          icon: null,
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          widthIcon: null,
          title: "Добавить документ",
        ),
      ),
    );
  }
}
