// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:gservice5/component/appBar/fadeOnScroll.dart';
// import 'package:gservice5/component/button/back/backIconButton.dart';
// import 'package:gservice5/component/dio/dio.dart';
// import 'package:gservice5/component/formatted/price/priceFormat.dart';
// import 'package:gservice5/component/loader/loaderComponent.dart';
// import 'package:gservice5/component/snackBar/snackBarComponent.dart';
// import 'package:gservice5/component/theme/colorComponent.dart';
// import 'package:gservice5/pages/ad/my/optionsMyAdPageModal.dart';
// import 'package:gservice5/pages/ad/my/request/myAdRequest.dart';
// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

// class ViewMyAdPage extends StatefulWidget {
//   final int id;
//   const ViewMyAdPage({super.key, required this.id});

//   @override
//   State<ViewMyAdPage> createState() => _ViewMyAdPageState();
// }

// class _ViewMyAdPageState extends State<ViewMyAdPage> {
//   Map data = {};
//   bool loader = true;
//   final ScrollController scrollController = ScrollController();

//   @override
//   void initState() {
//     super.initState();
//     getData();
//   }

//   @override
//   void dispose() {
//     scrollController.dispose();
//     super.dispose();
//   }

//   Future getData() async {
//     try {
//       Response response = await dio.get("/ad/${widget.id}");
//       print(response.data['data']['status']);
//       if (response.data['success']) {
//         data = response.data['data'];
//         loader = false;
//         setState(() {});
//       } else {
//         SnackBarComponent().showErrorMessage(response.data['message'], context);
//       }
//       print(response.data);
//     } on PlatformException catch (e) {
//       print(e);
//       SnackBarComponent().showNotGoBackServerErrorMessage(context);
//     }
//   }

//   Future unZipAd() async {
//     if (await MyAdRequest().unZipAd(data['id'], context)) {
//       Navigator.pop(context, "update");
//     }
//   }

//   Future restoreAd() async {
//     if (await MyAdRequest().restoreAd(data['id'], context)) {
//       Navigator.pop(context, "update");
//     }
//   }

//   void showPromotionAdPage() {
//     // Navigator.push(
//     //     context,
//     //     MaterialPageRoute(
//     //         builder: (context) => ListPromotionPage(
//     //             rubricId: 6, adId: data['id'], goBack: true)));
//   }

//   void showOptionsModal(Map data) {
//     showCupertinoModalBottomSheet(
//             context: context,
//             builder: (context) =>
//                 OptionsMyAdPageModal(data: data, status: data['status']))
//         .then((value) {
//       if (value != null) {
//         Navigator.pop(context, value);
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: loader
//           ? LoaderComponent()
//           : CustomScrollView(controller: scrollController, slivers: [
//               SliverAppBar(
//                 pinned: true,
//                 leading: const BackIconButton(),
//                 centerTitle: false,
//                 actions: [],
//                 title: FadeOnScroll(
//                   scrollController: scrollController,
//                   fullOpacityOffset: 180,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(data['title'],
//                           style: TextStyle(
//                               fontSize: 14, fontWeight: FontWeight.w500),
//                           maxLines: 1),
//                       Text("123123",
//                           style: TextStyle(
//                               fontSize: 14, fontWeight: FontWeight.w600),
//                           maxLines: 1),
//                     ],
//                   ),
//                 ),
//               ),
//               SliverToBoxAdapter(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(16),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(data['title'],
//                               style: TextStyle(
//                                   fontSize: 16, fontWeight: FontWeight.w600)),
//                           const SizedBox(height: 8),
//                           // PriceTextWidget(data['price'], data['current']),
//                           const SizedBox(height: 8),
//                           Container(
//                               decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.vertical(
//                                       top: Radius.circular(8))),
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Container(
//                                     width:
//                                         MediaQuery.of(context).size.width - 32,
//                                     child: Wrap(
//                                       runSpacing: 10,
//                                       children: [
//                                         Container(
//                                             margin: EdgeInsets.only(right: 8),
//                                             padding: EdgeInsets.symmetric(
//                                                 horizontal: 8, vertical: 3),
//                                             decoration: BoxDecoration(
//                                                 color: Color(0xffDEF7EC),
//                                                 borderRadius:
//                                                     BorderRadius.circular(4)),
//                                             child: Text(
//                                               "Продажа",
//                                               style: TextStyle(
//                                                   fontWeight: FontWeight.w600,
//                                                   fontSize: 12),
//                                               maxLines: 1,
//                                               overflow: TextOverflow.fade,
//                                               softWrap: false,
//                                             )),
//                                         Container(
//                                             margin: EdgeInsets.only(right: 8),
//                                             padding: EdgeInsets.symmetric(
//                                                 horizontal: 8, vertical: 3),
//                                             decoration: BoxDecoration(
//                                                 color: Color(0xffFDF6B2),
//                                                 borderRadius:
//                                                     BorderRadius.circular(4)),
//                                             child: Text(
//                                               data['category']['title'],
//                                               style: TextStyle(
//                                                   fontWeight: FontWeight.w600,
//                                                   fontSize: 12),
//                                               maxLines: 1,
//                                               overflow: TextOverflow.fade,
//                                               softWrap: false,
//                                             )),
//                                         // StickersWidget(),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               )),
//                         ],
//                       ),
//                     ),
//                     SliderImageWidget(images: data['images']),
//                     SizedBox(height: 8),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 15, vertical: 4),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Container(
//                             constraints: BoxConstraints(
//                                 maxWidth:
//                                     MediaQuery.of(context).size.width / 2 - 15),
//                             child: Row(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets.only(top: 1),
//                                   child: SvgPicture.asset(
//                                       'assets/icons/pinOutline.svg',
//                                       color: ColorComponent.gray['500'],
//                                       width: 16),
//                                 ),
//                                 const SizedBox(width: 4),
//                                 Expanded(
//                                   child: Text(data['city']['title'],
//                                       style: TextStyle(
//                                           color: ColorComponent.gray['500'],
//                                           fontSize: 12,
//                                           fontWeight: FontWeight.w500)),
//                                 )
//                               ],
//                             ),
//                           ),
//                           Row(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               SvgPicture.asset('assets/icons/eye.svg',
//                                   color: ColorComponent.gray['500'], width: 16),
//                               const SizedBox(width: 4),
//                               Text("${data['views']} просмотров",
//                                   style: TextStyle(
//                                       color: ColorComponent.gray['500'],
//                                       fontSize: 12,
//                                       fontWeight: FontWeight.w500)),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                     Divider(
//                         color: ColorComponent.gray['500'],
//                         indent: 15,
//                         endIndent: 15),
//                     AnalyticAdWidget(data: data['statistics']),
//                     Divider(
//                         color: ColorComponent.gray200,
//                         indent: 15,
//                         endIndent: 15),
//                     ViewCharacteristicWidget(
//                         characteristics: data['characteristics']),
//                     SizedBox(height: 15),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 15.0),
//                       child: ViewAddressMapWidget(data: data),
//                     ),
//                     SizedBox(height: 15),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 15),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text("ID ${data['id']}",
//                               style: TextStyle(
//                                   color: ColorComponent.gray500, fontSize: 12)),
//                           Text(formattedDate(data['created_at']),
//                               style: TextStyle(
//                                   color: ColorComponent.gray500, fontSize: 12)),
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: 15),

//                     // Padding(
//                     //   padding: const EdgeInsets.symmetric(horizontal: 16),
//                     //   child: Column(
//                     //     crossAxisAlignment: CrossAxisAlignment.start,
//                     //     children: [
//                     //       const Padding(
//                     //         padding: EdgeInsets.only(bottom: 8.0),
//                     //         child: Row(children: [
//                     //           Expanded(child: Text("Модель: ")),
//                     //           Expanded(
//                     //               child: Text("МТЗ Белорус",
//                     //                   style: TextStyle(
//                     //                       fontWeight: FontWeight.w600)))
//                     //         ]),
//                     //       ),
//                     //       const Padding(
//                     //         padding: EdgeInsets.only(bottom: 8.0),
//                     //         child: Row(children: [
//                     //           Expanded(child: Text("Модель: ")),
//                     //           Expanded(
//                     //               child: Text("МТЗ Белорус",
//                     //                   style: TextStyle(
//                     //                       fontWeight: FontWeight.w600)))
//                     //         ]),
//                     //       ),
//                     //       const Padding(
//                     //         padding: EdgeInsets.only(bottom: 8.0),
//                     //         child: Row(children: [
//                     //           Expanded(child: Text("Модель:")),
//                     //           SizedBox(width: 6),
//                     //           Expanded(
//                     //               child: Text("МТЗ Белорус",
//                     //                   style: TextStyle(
//                     //                       fontWeight: FontWeight.w600)))
//                     //         ]),
//                     //       ),
//                     //       const SizedBox(height: 16),
//                     //       Text(data['description'],
//                     //           style: TextStyle(height: 1.6)),
//                     //       SizedBox(height: 15)
//                     //     ],
//                     //   ),
//                     // ),
//                   ],
//                 ),
//               )
//             ]),
//       bottomNavigationBar: loader
//           ? null
//           : BottomNavigationBarComponent(
//               child: data['status'] == "archived"
//                   ? ButtonComponent(
//                       onPressed: unZipAd,
//                       title: "Разархивировать",
//                       backgroundColor: ColorComponent.green500,
//                       titleColor: Colors.white,
//                       margin: true)
//                   : data['status'] == "deleted"
//                       ? ButtonComponent(
//                           onPressed: restoreAd,
//                           title: "Восстановить",
//                           backgroundColor: ColorComponent.green500,
//                           titleColor: Colors.white,
//                           margin: true)
//                       : Row(
//                           children: [
//                             Expanded(
//                               child: ButtonComponent(
//                                   onPressed: showPromotionAdPage,
//                                   title: "Продвижение",
//                                   backgroundColor: ColorComponent.orange,
//                                   titleColor: Colors.white,
//                                   margin: true),
//                             ),
//                             GestureDetector(
//                               onTap: () {
//                                 showOptionsModal(data);
//                               },
//                               child: Container(
//                                 height: 40,
//                                 padding:
//                                     const EdgeInsets.symmetric(horizontal: 8),
//                                 child: Row(
//                                   children: [
//                                     Text(
//                                       "Править",
//                                       style: TextStyle(
//                                           fontSize: 15,
//                                           fontWeight: FontWeight.w500),
//                                     ),
//                                     const SizedBox(width: 12),
//                                     SvgPicture.asset('assets/icons/dots.svg',
//                                         width: 18)
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             SizedBox(width: 15)
//                           ],
//                         )),
//     );
//   }
// }
