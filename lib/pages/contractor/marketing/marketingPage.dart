import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/button/back/backTitleButton.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:gservice5/localization/extensions/context_extension.dart';

class MarketingPage extends StatefulWidget {
  const MarketingPage({super.key});

  @override
  State<MarketingPage> createState() => _MarketingPageState();
}

class _MarketingPageState extends State<MarketingPage> {
  void showInfoMarketing() {
    print('object');
    showCupertinoModalBottomSheet(
        context: context, builder: (context) => const Placeholder());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: BackTitleButton(title: "Маркетинг"), leadingWidth: 200),
      backgroundColor: ColorComponent.gray['100'],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
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
                      const Divider(height: 15),
                      const Text("Реклама на GSrevice",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w700)),
                      const Divider(height: 15),
                      const Text(
                          "Ваш помощник в решении повседневных задач: покупка, продажа и развитие бизнеса. Мы знаем интересы наших пользователей и настраиваем рекламу так, чтобы она приносила результаты",
                          style: TextStyle(height: 1.5, fontSize: 15)),
                      const Divider(height: 20),
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
              const Divider(height: 20),
              MarketingWidget(
                  onTap: () => showInfoMarketing(),
                  icon: "banner.svg",
                  title: "Баннера на сайте и в мобильном приложение",
                  subTitle:
                      "Универсальное решение, которое позволяет эффективно охватить вашу целевую аудиторию на всех устройствах: от компьютеров до смартфонов."),
              const Divider(height: 20),
              MarketingWidget(
                  onTap: () => showInfoMarketing(),
                  icon: "pageArtboard.svg",
                  title: "Реклама на списке и последнее фото",
                  subTitle:
                      "Формат онлайн-рекламы, в котором рекламный баннер обрамляет содержимое сайта, заполняя фон и боковые панели вокруг основного контента"),
              const Divider(height: 20),
              MarketingWidget(
                  onTap: () => showInfoMarketing(),
                  icon: "windowAds.svg",
                  title: "Медийные форматы рекламы на сайте",
                  subTitle:
                      "Формат онлайн-рекламы, в котором рекламный баннер обрамляет содержимое сайта, заполняя фон и боковые панели вокруг основного контента"),
              const Divider(height: 20),
              MarketingWidget(
                  onTap: () => showInfoMarketing(),
                  icon: "bell.svg",
                  title: "Push-уведомления",
                  subTitle:
                      "Вы получите возможность отправлять push-уведомления всем пользователям о ваших акциях и объявлениях. Это отличный способ достучаться до аудитории, заинтересованной только в спецтехнике, что повысит шансы на успешные продажи."),
              const Divider(height: 20),
              MarketingWidget(
                  onTap: () => showInfoMarketing(),
                  icon: "christmasGift.svg",
                  title: "Розыгрыш",
                  subTitle:
                      "Хотите провести розыгрыш на нашей платформе? Мы можем помочь вам организовать его! Наши пользователи заинтересованы в спецтехнике, что позволяет вам охватить именно эту аудиторию"),
              const Divider(height: 20),
              Container(
                padding: const EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width - 40,
                decoration: BoxDecoration(
                    border:
                        Border.all(width: 1, color: ColorComponent.mainColor),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white),
                child: Column(children: [
                  Text(context.localizations.well_help_you_choose,
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.w700)),
                  const Divider(),
                  Text(context.localizations
                      .if_you_have_any_questions_or_dont_know_what_to_choose_contact_our_sales_department_or_leave_an_application),
                  const Divider(),
                  SizedBox(
                    height: 40,
                    child: Button(
                        onPressed: () {}, title: "Мне нужна консультация"),
                  )
                ]),
              ),
              const Divider(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBarComponent(
          child: Button(
              onPressed: () {},
              title: "Оставить заявку",
              padding: const EdgeInsets.symmetric(horizontal: 15))),
    );
  }
}

class MarketingWidget extends StatelessWidget {
  const MarketingWidget(
      {super.key,
      required this.icon,
      required this.title,
      required this.subTitle,
      required this.onTap});

  final String icon;
  final String title;
  final String subTitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
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
          const Divider(height: 15),
          Text(title,
              style:
                  const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
          const Divider(height: 15),
          Text(subTitle, style: const TextStyle(height: 1.5, fontSize: 15)),
          const Divider(height: 20),
          SizedBox(
            height: 42,
            child: Row(children: [
              // Expanded(child: Button(onPressed: () {}, title: "Оставить заявку")),
              // const Divider(indent: 12),
              Expanded(
                  child: Button(
                onPressed: () {},
                title: "Подробнее",
                backgroundColor: ColorComponent.mainColor.withOpacity(.1),
              ))
            ]),
          )
        ]),
      ),
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
