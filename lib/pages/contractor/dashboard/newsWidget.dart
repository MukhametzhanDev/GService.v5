import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/image/cacheImage.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/contractor/dashboard/dashboardPage.dart';

class NewsWidget extends StatefulWidget {
  const NewsWidget({super.key});

  @override
  State<NewsWidget> createState() => _NewsWidgetState();
}

class _NewsWidgetState extends State<NewsWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(height: 16),
        Row(
          children: [
            const Expanded(
                child: Text("Мои новости",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
            Row(
              children: [
                Text("Что это такое?",
                    style: TextStyle(
                        color: ColorComponent.blue['500'],
                        fontWeight: FontWeight.w500)),
                // Divider(indent: 4),
                // SvgPicture.asset('assets/icons/rightBlue.svg')
              ],
            )
          ],
        ),
        const Divider(height: 12),
        ContainerWidget(true
            ? Column(
                children: [
                  SvgPicture.asset('assets/icons/bullhorn.svg',
                      width: 50, color: ColorComponent.gray['500']),
                  const Divider(height: 12),
                  const Text("Здесь будет ваши новости",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const Divider(height: 12),
                  const Text(
                      "Новости дегенымыз жаналыктар. Сыздын жаксы жаксы жаналыктарыныз болса салсаныз болады",
                      textAlign: TextAlign.center),
                  const Divider(height: 12),
                  SizedBox(
                    height: 40,
                    child: Button(onPressed: () {}, title: "Создать"),
                  )
                ],
              )
            : Column(
                children: [1, 2, 3].map((value) {
                return Padding(
                  padding: EdgeInsets.only(bottom: value < 3 ? 12 : 0),
                  child: Row(
                    children: [
                      const CacheImage(
                          url:
                              "https://images.unsplash.com/photo-1527847263472-aa5338d178b8?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8dHJhY3RvcnxlbnwwfHwwfHx8MA%3D%3D",
                          width: 140,
                          height: 100,
                          borderRadius: 8),
                      const Divider(indent: 12),
                      Expanded(
                          child: Column(
                        children: [
                          const Text(
                              "Поехали сдавать ЕНТ на тракторе: видео из ЗКО объяснили в акимате",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                              maxLines: 2),
                          const Divider(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text("15 Март 2024, 04:20",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: ColorComponent.gray["500"])),
                              const Divider(indent: 15),
                              SvgPicture.asset(
                                'assets/icons/eye.svg',
                                width: 16,
                                color: ColorComponent.gray["400"],
                              ),
                              const Divider(indent: 4),
                              Text(
                                "1200",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: ColorComponent.gray["500"]),
                              ),
                            ],
                          ),
                        ],
                      ))
                    ],
                  ),
                );
              }).toList()))
      ],
    );
  }
}
