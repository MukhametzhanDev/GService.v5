// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:gservice5/component/button/back/backIconButton.dart';
// import 'package:gservice5/component/theme/colorComponent.dart';
// import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:yandex_mapkit/yandex_mapkit.dart';

// class ViewAddressMapPage extends StatefulWidget {
//   final Map data;
//   const ViewAddressMapPage({super.key, required this.data});

//   @override
//   State<ViewAddressMapPage> createState() => _ViewAddressMapPageState();
// }

// class _ViewAddressMapPageState extends State<ViewAddressMapPage> {
//   late YandexMapController controller;

//   Future onMapCreated(YandexMapController yandexMapController) async {
//     controller = yandexMapController;
//     controller.toggleUserLayer(visible: true);

//     await changedCamera(
//         widget.data['latitude'], widget.data['longitude'], 13.0);
//   }

//   Future changedCamera(latitude, longitude, double zoom) async {
//     await controller.moveCamera(
//         CameraUpdate.newCameraPosition(CameraPosition(
//             target: Point(
//                 latitude: double.parse(latitude),
//                 longitude: double.parse(longitude)),
//             zoom: zoom)),
//         animation: const MapAnimation(duration: 1));
//   }

//   Future<void> show2GIS() async {
//     String latitude = widget.data['latitude'];
//     String longitude = widget.data['longitude'];
//     String url = "https://2gis.ru/geo/$longitude,$latitude";
//     if (!await launchUrl(Uri.parse(url),
//         mode: LaunchMode.externalApplication)) {
//       throw Exception('Could not launch $url');
//     }
//   }

//   Future<void> showYandexMap() async {
//     String latitude = widget.data['latitude'];
//     String longitude = widget.data['longitude'];
//     String url = "https://yandex.ru/maps/?ll=$longitude,$latitude&z=12";
//     if (!await launchUrl(Uri.parse(url),
//         mode: LaunchMode.externalApplication)) {
//       throw Exception('Could not launch $url');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(leading: const BackIconButton(), title: const Text("Адрес")),
//       body: Stack(
//         alignment: Alignment.center,
//         children: [
//           YandexMap(
//             onMapCreated: (YandexMapController yandexMapController) async {
//               await onMapCreated(yandexMapController);
//             },
//             mapObjects: [
//               PlacemarkMapObject(
//                   mapId:
//                       MapObjectId('location_order_${widget.data['longitude']}'),
//                   onTap: (PlacemarkMapObject self, point) =>
//                       print('Tapped me at $point'),
//                   opacity: 0.9,
//                   direction: 0,
//                   isDraggable: true,
//                   icon: PlacemarkIcon.single(PlacemarkIconStyle(
//                       anchor: const Offset(0.5, 1),
//                       scale: 0.8,
//                       image: BitmapDescriptor.fromAssetImage(
//                           'assets/images/pin.png'),
//                       rotationType: RotationType.noRotation)),
//                   point: Point(
//                       latitude: widget.data['latitude'],
//                       longitude: widget.data['longitude']))
//             ],
//           ),
//           Positioned(
//             right: 16,
//             child: Container(
//               width: 44,
//               height: 90,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(12),
//                 color: Colors.white,
//               ),
//               child: Column(
//                 children: [
//                   Expanded(
//                     child: GestureDetector(
//                         onTap: () {
//                           controller.moveCamera(CameraUpdate.zoomIn(),
//                               animation: const MapAnimation(duration: 0.4));
//                         },
//                         // onTapDown: (details) async {
//                         //   controller.moveCamera(CameraUpdate.zoomIn());
//                         // },
//                         // onTapUp: (details) {
//                         //   print('123');
//                         // },
//                         child: Container(
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12)),
//                           alignment: Alignment.center,
//                           child: const Text(
//                             "+",
//                             style: TextStyle(fontSize: 24),
//                           ),
//                         )),
//                   ),
//                   Container(
//                       width: 32, height: 1, color: ColorComponent.gray['200']),
//                   Expanded(
//                     child: GestureDetector(
//                         onTap: () {
//                           controller.moveCamera(CameraUpdate.zoomOut(),
//                               animation: const MapAnimation(duration: 0.4));
//                         },
//                         child: Container(
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12)),
//                           alignment: Alignment.center,
//                           child: const Text(
//                             "-",
//                             style: TextStyle(fontSize: 24),
//                           ),
//                         )),
//                   ),
//                 ],
//               ),
//             ),
//           )
//         ],
//       ),
//       bottomNavigationBar: BottomNavigationBarComponent(
//           child: Container(
//         constraints: BoxConstraints(
//             minHeight: MediaQuery.of(context).padding.bottom + 98),
//         padding: const EdgeInsets.symmetric(horizontal: 15),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             const SizedBox(height: 5),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(top: 2.0),
//                       child: SvgPicture.asset('assets/icons/pinOutline.svg',
//                           color: Colors.black, width: 18),
//                     ),
//                     const SizedBox(width: 8),
//                     Expanded(
//                       child: Text(widget.data['address'],
//                           style: const TextStyle(
//                               fontWeight: FontWeight.w600, fontSize: 16)),
//                     ),
//                   ],
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(top: 10, bottom: 6),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(top: 2),
//                         child: SvgPicture.network(
//                             widget.data['country']['flag'],
//                             width: 24),
//                       ),
//                       const SizedBox(width: 10),
//                       Text(
//                           widget.data['country']['title'] +
//                               ", " +
//                               widget.data['city']['title'],
//                           style: TextStyle(
//                               color: ColorComponent.gray['500'],
//                               fontWeight: FontWeight.w500)),
//                     ],
//                   ),
//                 )
//               ],
//             ),
//             const SizedBox(height: 12),
//             Text("Открыть при помощи",
//                 style: TextStyle(
//                     color: ColorComponent.gray['500'],
//                     fontWeight: FontWeight.w500)),
//             const SizedBox(height: 8),
//             SizedBox(
//               width: MediaQuery.of(context).size.width - 30,
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: TextButton(
//                         onPressed: show2GIS,
//                         child: Container(
//                             height: 44,
//                             padding: const EdgeInsets.symmetric(vertical: 11),
//                             alignment: Alignment.center,
//                             decoration: BoxDecoration(
//                                 border: Border.all(
//                                     width: 1, color: const Color(0xffE5E7EB)),
//                                 borderRadius: BorderRadius.circular(8)),
//                             child: Image.asset('assets/images/2gis.png'))),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: TextButton(
//                         onPressed: showYandexMap,
//                         child: Container(
//                             height: 44,
//                             padding: const EdgeInsets.symmetric(vertical: 11),
//                             alignment: Alignment.center,
//                             decoration: BoxDecoration(
//                                 border: Border.all(
//                                     width: 1, color: const Color(0xffE5E7EB)),
//                                 borderRadius: BorderRadius.circular(8)),
//                             child: Image.asset('assets/images/yandexMap.png'))),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       )),
//     );
//   }
// }
