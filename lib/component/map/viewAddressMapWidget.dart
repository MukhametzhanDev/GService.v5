// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:gservice5/component/map/viewAddressMapPage.dart';
// import 'package:yandex_mapkit/yandex_mapkit.dart';

// class ViewAddressMapWidget extends StatefulWidget {
//   final Map data;
//   const ViewAddressMapWidget({super.key, required this.data});

//   @override
//   State<ViewAddressMapWidget> createState() => _ViewAddressMapWidgetState();
// }

// class _ViewAddressMapWidgetState extends State<ViewAddressMapWidget> {
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
//             target: Point(latitude: latitude, longitude: longitude),
//             zoom: zoom)),
//         animation: const MapAnimation(duration: 0));
//   }

//   void showPage() {
//     Navigator.push(
//         context,
//         MaterialPageRoute(
//             builder: (context) => ViewAddressMapPage(data: widget.data)));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text("Адрес",
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
//         const SizedBox(height: 12),
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(top: 3),
//               child:
//                   SvgPicture.network(widget.data['country']['flag'], width: 24),
//             ),
//             const SizedBox(width: 10),
//             Expanded(
//               child: RichText(
//                   textAlign: TextAlign.start,
//                   text: TextSpan(
//                       style: const TextStyle(color: Colors.black),
//                       children: [
//                         TextSpan(text: widget.data['country']['title'] + ", "),
//                         TextSpan(text: widget.data['city']['title'] + ", "),
//                         TextSpan(text: widget.data['address']),
//                       ])),
//             ),
//           ],
//         ),
//         const SizedBox(height: 15),
//         ClipRRect(
//           borderRadius: BorderRadius.circular(8),
//           child: SizedBox(
//             height: 150,
//             width: MediaQuery.of(context).size.width - 30,
//             child: Stack(
//               alignment: Alignment.center,
//               children: [
//                 YandexMap(
//                   onMapCreated:
//                       (YandexMapController yandexMapController) async {
//                     await onMapCreated(yandexMapController);
//                   },
//                 ),
//                 Container(
//                     width: 40,
//                     height: 46,
//                     alignment: Alignment.center,
//                     decoration:
//                         BoxDecoration(borderRadius: BorderRadius.circular(12)),
//                     child: SvgPicture.asset('assets/icons/location.svg',
//                         height: 34)),
//                 GestureDetector(
//                   onTap: showPage,
//                   child: Container(
//                     height: 150,
//                     width: MediaQuery.of(context).size.width - 30,
//                     decoration:
//                         BoxDecoration(borderRadius: BorderRadius.circular(8)),
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
