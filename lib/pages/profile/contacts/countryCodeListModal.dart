import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/button/back/closeIconButton.dart';
import 'package:gservice5/component/modal/modalBottomSheetWrapper.dart';
import 'package:gservice5/component/textField/closeKeyboard/closeKeyboard.dart';
import 'package:gservice5/component/textField/searchTextField.dart';
import 'package:gservice5/localization/extensions/context_extension.dart';

class CountryCodeListModal extends StatefulWidget {
  final List data;
  const CountryCodeListModal({super.key, required this.data});

  @override
  State<CountryCodeListModal> createState() => _CountryCodeListModalState();
}

class _CountryCodeListModalState extends State<CountryCodeListModal> {
  List filterData = [];

  @override
  void initState() {
    filterData = widget.data;
    super.initState();
  }

  void addTitle(String value) {
    print(value);
    List data = widget.data;
    if (value.isNotEmpty) {
      filterData = data
          .where((element) =>
              element['title'].toLowerCase().contains(value.toLowerCase()))
          .toList();
    } else {
      filterData = data;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ModalBottomSheetWrapper(builder: (context, physics) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Выберите код страны"),
          leading: Container(),
          leadingWidth: 0,
          elevation: 0,
          actions: const [CloseIconButton(iconColor: null, padding: true)],
          bottom: PreferredSize(
              preferredSize: Size(MediaQuery.of(context).size.width, 56),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                child: SearchTextField(
                    title: context.localizations.search, onChanged: addTitle),
              )),
        ),
        body: ListView.builder(
          itemCount: filterData.length,
          physics: physics,
          itemBuilder: (context, index) {
            Map value = filterData[index];
            return Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                      top: BorderSide(width: 1, color: Color(0xffe5e7eb)))),
              child: ListTile(
                onTap: () {
                  closeKeyboard();
                  Navigator.pop(context, value);
                },
                leading: SvgPicture.network(value['flag'], width: 24),
                title: Text(
                  value['title'],
                  style: const TextStyle(fontSize: 15),
                ),
                trailing: Text(
                  "+${value['phone_code']}",
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
              ),
            );
          },
        ),
      );
    });
  }
}
