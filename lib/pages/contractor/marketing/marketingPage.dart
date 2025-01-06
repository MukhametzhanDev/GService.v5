import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/formatted/number/numberFormatted.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/contractor/dashboard/dashboardPage.dart';

class MarketingPage extends StatefulWidget {
  const MarketingPage({super.key});

  @override
  State<MarketingPage> createState() => _MarketingPageState();
}

class _MarketingPageState extends State<MarketingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorComponent.gray['100'],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: ColorComponent.mainColor.withOpacity(.2)),
                        child: SvgPicture.asset("assets/icons/logoOutline.svg"),
                      ),
                      Divider(height: 15),
                      Text("Реклама на GSrevice",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w700)),
                      Divider(height: 15),
                      Text(
                          "Ваш помощник в решении повседневных задач: покупка, продажа и развитие бизнеса. Мы знаем интересы наших пользователей и настраиваем рекламу так, чтобы она приносила результаты",
                          style: TextStyle(height: 1.5, fontSize: 15)),
                      Divider(height: 20),
                      SizedBox(
                          height: 42,
                          child: Button(
                            onPressed: () {},
                            title: "Подробнее",
                            backgroundColor:
                                ColorComponent.mainColor.withOpacity(.1),
                          ))
                    ]),
              ),
              Divider(height: 20),
              MarketingWidget(
                  icon: "banner.svg",
                  title: "Баннера на сайте и в мобильном приложение",
                  subTitle:
                      "Универсальное решение, которое позволяет эффективно охватить вашу целевую аудиторию на всех устройствах: от компьютеров до смартфонов."),
              Divider(height: 20),
              MarketingWidget(
                  icon: "pageArtboard.svg",
                  title: "Реклама на списке и последнее фото",
                  subTitle:
                      "Формат онлайн-рекламы, в котором рекламный баннер обрамляет содержимое сайта, заполняя фон и боковые панели вокруг основного контента"),
              Divider(height: 20),
              MarketingWidget(
                  icon: "windowAds.svg",
                  title: "Медийные форматы рекламы на сайте",
                  subTitle:
                      "Формат онлайн-рекламы, в котором рекламный баннер обрамляет содержимое сайта, заполняя фон и боковые панели вокруг основного контента"),
              Divider(height: 20),
              MarketingWidget(
                  icon: "bell.svg",
                  title: "Push",
                  subTitle:
                      "Формат онлайн-рекламы, в котором рекламный баннер обрамляет содержимое сайта, заполняя фон и боковые панели вокруг основного контента"),
              Divider(height: 20),
              MarketingWidget(
                  icon: "christmasGift.svg",
                  title: "Розыгрыш",
                  subTitle:
                      "Формат онлайн-рекламы, в котором рекламный баннер обрамляет содержимое сайта, заполняя фон и боковые панели вокруг основного контента"),
              Divider(height: 20),
              Container(
                padding: EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width - 40,
                decoration: BoxDecoration(
                    border:
                        Border.all(width: 1, color: ColorComponent.mainColor),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white),
                child: Column(children: [
                  Text("Остались вопросы?",
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
                  Divider(),
                  Text("Позвоним и ответим"),
                  Divider(),
                  SizedBox(
                    height: 40,
                    child: Button(
                        onPressed: () {}, title: "Мне нужна консультация"),
                  )
                ]),
              ),
              Divider(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class MarketingWidget extends StatelessWidget {
  const MarketingWidget(
      {super.key,
      required this.icon,
      required this.title,
      required this.subTitle});

  final String icon;
  final String title;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), color: Colors.white),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: ColorComponent.mainColor.withOpacity(.2)),
          child: SvgPicture.asset("assets/icons/$icon"),
        ),
        Divider(height: 15),
        Text(title,
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
        Divider(height: 15),
        Text(subTitle, style: TextStyle(height: 1.5, fontSize: 15)),
        Divider(height: 20),
        SizedBox(
          height: 42,
          child: Row(children: [
            Expanded(child: Button(onPressed: () {}, title: "Оставить заявку")),
            Divider(indent: 12),
            Expanded(
                child: Button(
              onPressed: () {},
              title: "Подробнее",
              backgroundColor: ColorComponent.mainColor.withOpacity(.1),
            ))
          ]),
        )
      ]),
    );
  }
}

// body: SafeArea(
//           child: SingleChildScrollView(
//         padding: const EdgeInsets.all(15),
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 const Expanded(
//                     child: Text("Статистика баннера",
//                         style: TextStyle(
//                             fontSize: 16, fontWeight: FontWeight.w600))),
//                 Row(
//                   children: [
//                     Text("Показать  все",
//                         style: TextStyle(
//                             color: ColorComponent.blue['500'],
//                             fontWeight: FontWeight.w500)),
//                     const Divider(indent: 4),
//                     SvgPicture.asset('assets/icons/rightBlue.svg')
//                   ],
//                 )
//               ],
//             ),
//             const Divider(height: 12),
//             Column(
//               children: [
//                 Row(
//                   children: [
//                     const Expanded(
//                         child: Text("Статистика объявлении",
//                             style: TextStyle(
//                                 fontSize: 16, fontWeight: FontWeight.w600))),
//                     Row(
//                       children: [
//                         Text("Показать  все",
//                             style: TextStyle(
//                                 color: ColorComponent.blue['500'],
//                                 fontWeight: FontWeight.w500)),
//                         const Divider(indent: 4),
//                         SvgPicture.asset('assets/icons/rightBlue.svg')
//                       ],
//                     )
//                   ],
//                 ),
//                 const Divider(height: 12),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: ContainerWidget(Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Container(
//                             width: 24,
//                             height: 24,
//                             decoration: BoxDecoration(
//                                 color: ColorComponent.mainColor.withOpacity(.2),
//                                 borderRadius: BorderRadius.circular(4)),
//                             child: SvgPicture.asset('assets/icons/message.svg',
//                                 color: Colors.black),
//                           ),
//                           const Divider(indent: 12),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   numberFormat(1234),
//                                   style: const TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.w600),
//                                 ),
//                                 const Divider(height: 4),
//                                 const Text("Сообщения от пользователей")
//                               ],
//                             ),
//                           )
//                         ],
//                       )),
//                     ),
//                     const Divider(indent: 12),
//                     Expanded(
//                       child: ContainerWidget(Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Container(
//                             width: 24,
//                             height: 24,
//                             decoration: BoxDecoration(
//                                 color: ColorComponent.mainColor.withOpacity(.2),
//                                 borderRadius: BorderRadius.circular(4)),
//                             child: SvgPicture.asset('assets/icons/eye.svg',
//                                 color: Colors.black),
//                           ),
//                           const Divider(indent: 12),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   numberFormat(1234),
//                                   style: const TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.w600),
//                                 ),
//                                 const Divider(height: 4),
//                                 const Text("Просмотры объявлений")
//                               ],
//                             ),
//                           )
//                         ],
//                       )),
//                     ),
//                   ],
//                 ),
//                 const Divider(height: 12),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: ContainerWidget(Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Container(
//                             width: 24,
//                             height: 24,
//                             decoration: BoxDecoration(
//                                 color: ColorComponent.mainColor.withOpacity(.2),
//                                 borderRadius: BorderRadius.circular(4)),
//                             child: SvgPicture.asset('assets/icons/phoneOutline.svg',
//                                 color: Colors.black),
//                           ),
//                           const Divider(indent: 12),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   numberFormat(1234),
//                                   style: const TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.w600),
//                                 ),
//                                 const Divider(height: 4),
//                                 const Text("Просмотры контактов")
//                               ],
//                             ),
//                           )
//                         ],
//                       )),
//                     ),
//                     const Divider(indent: 12),
//                     Expanded(
//                       child: ContainerWidget(Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Container(
//                             width: 24,
//                             height: 24,
//                             decoration: BoxDecoration(
//                                 color: ColorComponent.mainColor.withOpacity(.2),
//                                 borderRadius: BorderRadius.circular(4)),
//                             child: SvgPicture.asset('assets/icons/share.svg',
//                                 color: Colors.black),
//                           ),
//                           const Divider(indent: 12),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   numberFormat(1234),
//                                   style: const TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.w600),
//                                 ),
//                                 const Divider(height: 4),
//                                 const Text("Поделились объявлениями")
//                               ],
//                             ),
//                           )
//                         ],
//                       )),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ],
//         ),
//       )),
