import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/formatted/number/numberFormatted.dart';
import 'package:gservice5/component/switchRole/switchRoleWidget.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/application/item/applicationItem.dart';
import 'package:gservice5/pages/contractor/dashboard/newsWidget.dart';

class DashboardPage extends StatefulWidget {
  final ScrollController scrollController;
  const DashboardPage({super.key, required this.scrollController});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("GService Business")),
      backgroundColor: const Color(0xfff4f4f4),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          controller: widget.scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SwitchRoleWidget(),
              // ContainerWidget(
              //   Column(
              //     children: [
              //       Row(
              //         children: [
              //           CacheImage(
              //               url:
              //                   "https://images.unsplash.com/photo-1733077151496-5e2701fc64eb?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHw3fHx8ZW58MHx8fHx8",
              //               width: 50,
              //               height: 50,
              //               borderRadius: 25),
              //           Divider(indent: 12),
              //           Column(
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               Text("OYAL ENERJİ JENERATÖR",
              //                   style: TextStyle(fontWeight: FontWeight.w600)),
              //               Divider(height: 4),
              //               Text("ID: 1234567890",
              //                   style: TextStyle(
              //                       color: ColorComponent.gray['500']))
              //             ],
              //           )
              //         ],
              //       ),
              //       Divider(indent: 8),
              //       Row(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           Expanded(
              //             child: Column(
              //               children: [
              //                 Row(
              //                   children: [
              //                     SvgPicture.asset('assets/icons/users.svg'),
              //                     Divider(indent: 8),
              //                     RichText(
              //                         textAlign: TextAlign.start,
              //                         text: TextSpan(
              //                             style: TextStyle(color: Colors.black),
              //                             children: [
              //                               TextSpan(
              //                                   text: "8",
              //                                   style: TextStyle(
              //                                       fontWeight:
              //                                           FontWeight.w700)),
              //                               TextSpan(
              //                                   text: "  Подписчики компании")
              //                             ])),
              //                   ],
              //                 ),
              //                 Divider(height: 12),
              //                 Row(
              //                   children: [
              //                     SvgPicture.asset('assets/icons/eye.svg',
              //                         width: 24,
              //                         color: ColorComponent.mainColor),
              //                     Divider(indent: 8),
              //                     RichText(
              //                         textAlign: TextAlign.start,
              //                         text: TextSpan(
              //                             style: TextStyle(color: Colors.black),
              //                             children: [
              //                               TextSpan(
              //                                   text: "8",
              //                                   style: TextStyle(
              //                                       fontWeight:
              //                                           FontWeight.w700)),
              //                               TextSpan(
              //                                   text: "  Просмотры страницы")
              //                             ])),
              //                   ],
              //                 )
              //               ],
              //             ),
              //           ),
              //           Container(
              //             padding: EdgeInsets.all(4),
              //             decoration: BoxDecoration(
              //                 color: ColorComponent.mainColor,
              //                 borderRadius: BorderRadius.circular(4)),
              //             child: Row(
              //               children: [
              //                 SvgPicture.asset('assets/icons/star.svg'),
              //                 Divider(indent: 2),
              //                 Text("4.92",
              //                     style: TextStyle(
              //                         fontSize: 12,
              //                         fontWeight: FontWeight.w600))
              //               ],
              //             ),
              //           ),
              //         ],
              //       )
              //     ],
              //   ),
              // ),
              // Divider(height: 12),
              // ContainerWidget(Row(
              //   children: [
              //     Expanded(
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           Text("Ваш тариф",
              //               style: TextStyle(
              //                   color: ColorComponent.gray['500'],
              //                   fontWeight: FontWeight.w500)),
              //           Divider(height: 6),
              //           Text("Стартовый",
              //               style: TextStyle(
              //                   fontSize: 16, fontWeight: FontWeight.w600)),
              //           Divider(height: 6),
              //           RichText(
              //               textAlign: TextAlign.start,
              //               text: TextSpan(
              //                   style: TextStyle(color: Colors.black),
              //                   children: [
              //                     TextSpan(
              //                         text: "25",
              //                         style: TextStyle(
              //                             fontWeight: FontWeight.w700)),
              //                     TextSpan(text: " из 50 объявлении")
              //                   ])),
              //           Divider(height: 6),
              //           Text("Активен с 12 Октября 2024 ",
              //               style: TextStyle(
              //                   fontSize: 12,
              //                   color: ColorComponent.gray['500']))
              //         ],
              //       ),
              //     ),
              //     Container(
              //       width: 32,
              //       height: 32,
              //       decoration: BoxDecoration(
              //           color: ColorComponent.mainColor.withOpacity(.2),
              //           borderRadius: BorderRadius.circular(4)),
              //       child: SvgPicture.asset('assets/icons/starOutline.svg'),
              //     )
              //   ],
              // )),
              const Divider(height: 16),
              Row(
                children: [
                  const Expanded(
                      child: Text("Новые заказы",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600))),
                  Row(
                    children: [
                      Text("Показать все",
                          style: TextStyle(
                              color: ColorComponent.blue['500'],
                              fontWeight: FontWeight.w500)),
                      const Divider(indent: 4),
                      SvgPicture.asset('assets/icons/rightBlue.svg')
                    ],
                  )
                ],
              ),
              const Divider(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            width: 1, color: const Color(0xffeeeeee))),
                    child: Column(
                        children: app.map((value) {
                      return ApplicationItem(data: value, showCategory: true);
                    }).toList())),
              ),
              const Divider(height: 16),
              Row(
                children: [
                  const Expanded(
                      child: Text("Мои",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600))),
                  Row(
                    children: [
                      Text("Показать  все",
                          style: TextStyle(
                              color: ColorComponent.blue['500'],
                              fontWeight: FontWeight.w500)),
                      const Divider(indent: 4),
                      SvgPicture.asset('assets/icons/rightBlue.svg')
                    ],
                  )
                ],
              ),
              const Divider(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ContainerWidget(Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                              color: ColorComponent.mainColor.withOpacity(.2),
                              borderRadius: BorderRadius.circular(4)),
                          child: SvgPicture.asset(
                              'assets/icons/clipboardOutline.svg',
                              color: Colors.black),
                        ),
                        const Divider(indent: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                numberFormat(1234),
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                              const Divider(height: 4),
                              const Text("Объявлении")
                            ],
                          ),
                        )
                      ],
                    )),
                  ),
                  const Divider(indent: 12),
                  Expanded(
                    child: ContainerWidget(Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                              color: ColorComponent.mainColor.withOpacity(.2),
                              borderRadius: BorderRadius.circular(4)),
                          child: SvgPicture.asset(
                            'assets/icons/file.svg',
                            color: Colors.black,
                            width: 22,
                          ),
                        ),
                        const Divider(indent: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                numberFormat(1234),
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                              const Divider(height: 4),
                              const Text("Заказы")
                            ],
                          ),
                        )
                      ],
                    )),
                  ),
                ],
              ),
              const NewsWidget()
            ],
          ),
        ),
      ),
    );
  }
}

Widget ContainerWidget(Widget child) {
  return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          border: Border.all(width: 1, color: const Color(0xffeeeeee))),
      child: child);
}

List app = [
  {
    "id": 9,
    "category": {
      "id": 9,
      "title": "Запчасти",
      "icon":
          "https://dev.gservice-co.kz/api-assets/category_icon/spare_part.svg"
    },
    "city": {"id": 8, "title": "Астана"},
    "description": "dsfsdfsdf sg df g sdfg sdf g sdf gg s",
    "transport_type": {"id": 36, "title": "Автокраны", "is_popular": true},
    "price": null,
    "status": "pending",
    "is_favorite": false,
    "statistics": {"viewed": 30},
    "created_at": "2024-12-04T10:16:33.000000Z"
  },
  {
    "id": 8,
    "category": {
      "id": 11,
      "title": "Водитель",
      "icon": "https://dev.gservice-co.kz/"
    },
    "city": {"id": 28, "title": "Алматы"},
    "description":
        "требуются водители на Новый Самосвал Howo-15 тонн с прицепом 25 тонн. Права категории СЕ. Зарплата от 400000 тенге до 700000 тенге.",
    "transport_type": {"id": 1, "title": "Бульдозеры", "is_popular": true},
    "price": null,
    "status": "pending",
    "is_favorite": false,
    "statistics": {"viewed": 28},
    "created_at": "2024-12-04T10:14:34.000000Z"
  },
  {
    "id": 7,
    "category": {
      "id": 7,
      "title": "Покупка спецтехники",
      "icon": "https://dev.gservice-co.kz/api-assets/category_icon/basket.svg"
    },
    "city": {"id": 28, "title": "Алматы"},
    "description": "need tral",
    "transport_type": {
      "id": 57,
      "title": "Ассенизаторские машины",
      "is_popular": false
    },
    "price": null,
    "status": "pending",
    "is_favorite": false,
    "statistics": {"viewed": 31},
    "created_at": "2024-12-04T07:01:32.000000Z"
  },
];
