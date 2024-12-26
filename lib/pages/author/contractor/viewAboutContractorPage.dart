import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/author/filesListPage.dart';
import 'package:readmore/readmore.dart';

class ViewAboutContractorPage extends StatefulWidget {
  final Map data;
  const ViewAboutContractorPage({super.key, required this.data});

  @override
  State<ViewAboutContractorPage> createState() =>
      _ViewAboutContractorPageState();
}

class _ViewAboutContractorPageState extends State<ViewAboutContractorPage> {
  void showFilesPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const FilesListPage()));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ReadMoreText(
            "Севало Инжиниринг Машинери Казахстан)» создано в Казахстане (г.Алматы) в Мае, 2012 года.Наша компания в основном реализует продукцию Южной Кореи (экскаватор, погрузчик, дробилка), Шаньдунской компании Линь Гун Китай (погрузчики), Уханьской компании Шань Мао, Китай (Bobcat), Шанхайской компании Хань Юй Китай, (гидромолот) и других известных компаний.Компания предоставляет клиентам комплексное обслуживание как реализация, сервисное обслуживание машин, управление финансирования и страховое агентство. Компания всегда придерживается идеи бизнеса комплексное обслуживание и высокое качество, а также принципов - честность, искренний труд, и непреклонное стремление к совершенству",
            trimMode: TrimMode.Line,
            trimLines: 5,
            style: const TextStyle(fontSize: 15, height: 1.5),
            trimCollapsedText: ' читать дальше',
            trimExpandedText: ' cкрыть',
            lessStyle: TextStyle(
                fontSize: 14,
                color: ColorComponent.blue['500'],
                fontWeight: FontWeight.w500),
            moreStyle: TextStyle(
                fontSize: 14,
                color: ColorComponent.blue['500'],
                fontWeight: FontWeight.w500),
          ),
          const Divider(indent: 12),
          InfoButton(
              SvgPicture.asset('assets/icons/fileOutline.svg',
                  width: 18, color: const Color(0xff6b7280)),
              "Сертификаты",
              showFilesPage),
          InfoButton(
              SvgPicture.asset('assets/icons/pin.svg',
                  width: 18, color: const Color(0xff6b7280)),
              widget.data['city']['title'],
              () {}),
          InfoButton(
              Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(right: 4, left: 5),
                  decoration: BoxDecoration(
                      color: ColorComponent.red['500'],
                      borderRadius: BorderRadius.circular(5))),
              "Закрыто до завтра",
              () {}),
          const Divider(),
          const Text("Контакты",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
          const Divider(height: 10),
          GestureDetector(
            child: const Row(children: [
              Text("example.com",
                  style: TextStyle(decoration: TextDecoration.underline))
            ]),
          ),
          const Divider(height: 12),
          GestureDetector(
            child: const Row(children: [
              Text("Написать на whatsapp",
                  style: TextStyle(decoration: TextDecoration.underline))
            ]),
          ),
          const Divider(height: 12),
          GestureDetector(
            child: const Row(children: [
              Text("@instagramnik",
                  style: TextStyle(decoration: TextDecoration.underline))
            ]),
          ),
        ],
      ),
    );
  }

  Widget InfoButton(Widget leading, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            border: Border(
                bottom:
                    BorderSide(width: 1, color: ColorComponent.gray['100']!))),
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  leading,
                  const Divider(indent: 10),
                  Text(title,
                      style:
                          const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            SvgPicture.asset("assets/icons/right.svg")
          ],
        ),
      ),
    );
  }
}
