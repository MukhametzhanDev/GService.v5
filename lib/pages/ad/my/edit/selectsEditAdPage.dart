import 'package:flutter/material.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/select/edit/editMultiSelect.dart';
import 'package:gservice5/component/select/edit/editSelectModal.dart';
import 'package:gservice5/component/textField/closeKeyboard/closeKeyboard.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';
import 'package:gservice5/pages/ad/my/edit/editAdCharacteristics.dart';
import 'package:gservice5/pages/create/data/createData.dart';
import 'package:gservice5/pages/create/structure/controllerPage/pageControllerIndexedStack.dart';

class SelectsEditAdPage extends StatefulWidget {
  final Map data;
  const SelectsEditAdPage({super.key, required this.data});

  @override
  State<SelectsEditAdPage> createState() => _SelectsEditAdPageState();
}

class _SelectsEditAdPageState extends State<SelectsEditAdPage> {
  List selectData = [];
  Map cityData = {
    "url": "https://dev.gservice-co.kz/api/cities",
    "name": "city_id",
    "multiple": false,
    "title": {
      "title_ru": "Выберите город",
      "title_kk": "Қаланы таңдаңыз",
      "title_en": "Select city"
    }
  };
  PageControllerIndexedStack pageControllerIndexedStack =
      PageControllerIndexedStack();

  @override
  void initState() {
    widget.data['category']['options']['necessary_inputs'][0] = cityData;
    selectData = widget.data['category']['options']['necessary_inputs'];
    EditData.data['description'] = widget.data['description'];
    super.initState();
  }

  void nextPage() {
    pageControllerIndexedStack.nextPage();
  }

  @override
  Widget build(BuildContext context) {
    String filterKey =
        widget.data['category']['options']['characteristics']['filter_key'];
    return GestureDetector(
      onTap: () => closeKeyboard(),
      child: Scaffold(
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 7.5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: selectData.map((value) {
                  print(value);
                  String key = value['name'].replaceAll("_id", "");
                  if (value['multiple']) {
                    return EditMultiSelect(
                        title: value['title']['title_ru'],
                        option: value,
                        api: value['url'],
                        values: widget.data[key]);
                  } else {
                    return EditSelectModal(
                        title: value['title']['title_ru'],
                        option: value,
                        value: widget.data[key],
                        api: value['url']);
                  }
                }).toList(),
              ),
              Text("Описание",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
              Divider(height: 8),
              TextFormField(
                  initialValue: widget.data['description'],
                  onChanged: (value) {
                    print(value);
                    EditData.data['description'] = value;
                  },
                  style: TextStyle(fontSize: 14),
                  maxLength: 1000,
                  textCapitalization: TextCapitalization.sentences,
                  maxLines: 14,
                  minLines: 6,
                  decoration: InputDecoration(
                      hintText: "Что нужно сделать?",
                      helperStyle:
                          TextStyle(color: ColorComponent.gray['500']))),
              EditAdCharacteristics(
                  value: widget.data['characteristics'],
                  param: {"category_id": widget.data['category']['id']}),
              widget.data['category']['options']['characteristics']
                      ['is_available']
                  ? EditAdCharacteristics(
                      value: widget.data['characteristics'],
                      param: {
                          filterKey:
                              widget.data[filterKey.replaceAll("_id", "")]['id']
                        })
                  : Container()
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBarComponent(
            child: Button(
                onPressed: () {},
                padding: EdgeInsets.symmetric(horizontal: 15),
                title: "Продолжить")),
      ),
    );
  }
}
