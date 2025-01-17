// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:gservice5/component/theme/colorComponent.dart';
// import 'package:yandex_mapkit/yandex_mapkit.dart';

// class SearchMapAddressPage extends StatefulWidget {
//   final Point? currentCityPoint;
//   final Map cityData;
//   const SearchMapAddressPage(
//       {super.key, required this.currentCityPoint, required this.cityData});

//   @override
//   State<SearchMapAddressPage> createState() => _SearchMapAddressPageState();
// }

// class _SearchMapAddressPageState extends State<SearchMapAddressPage> {
//   TextEditingController textEditingController = TextEditingController();
//   bool progress = false;
//   final List<SearchSessionResult> results = [];
//   var session;

//   @override
//   void dispose() {
//     textEditingController.dispose();
//     super.dispose();
//   }

//   void getAddress() async {
//     print(widget.currentCityPoint);
//     progress = true;
//     setState(() {});
//     String query = textEditingController.text;
//     if (query.isNotEmpty) {
//       results.clear();
//       final resultWithSession = await YandexSearch.searchByText(
//         searchText: widget.cityData['title'] + ", " + query,
//         geometry: Geometry.fromPoint(Point(
//             latitude: widget.currentCityPoint!.latitude,
//             longitude: widget.currentCityPoint!.longitude)),
//         searchOptions:
//             const SearchOptions(searchType: SearchType.geo, geometry: false),
//       );
//       SearchSessionResult searchSession = await resultWithSession.$2;
//       print(searchSession.page);
//       setState(() {});
//       await _init(searchSession);
//     }
//   }

//   Future<void> _init(result) async {
//     await _handleResult(await result);
//   }

//   Future<void> _handleResult(SearchSessionResult result) async {
//     progress = false;
//     setState(() {});
//     if (result.error != null) {
//       print('Error: ${result.error}');
//       return;
//     }
//     setState(() {
//       results.add(result);
//     });
//     progress = true;
//     setState(() {});
//     print('Got ${result.found} items, fetching next page...');
//     // await _handleResult(await session?.fetchNextPage());
//   }

//   List<Widget> _getList() {
//     final list = <Widget>[];

//     if (results.isEmpty) {
//       list.add(const Center(
//           child: Padding(
//         padding: EdgeInsets.only(top: 20),
//         child: (Text("Ничего не найдено")),
//       )));
//     }

//     for (var r in results) {
//       r.items!.asMap().forEach((i, item) {
//         List<String> street = ["", ""];
//         List<String> province = ["", ""];
//         item.toponymMetadata!.address.addressComponents.forEach((key, value) {
//           if (key == SearchComponentKind.street) {
//             street[0] = value.toString();
//           } else if (key == SearchComponentKind.house) {
//             street[1] = value.toString();
//           } else if (key == SearchComponentKind.country) {
//             province[0] = value.toString();
//           } else if (key == SearchComponentKind.locality) {
//             province[1] = value.toString();
//           }
//         });
//         var data = {
//           "latitude": item.toponymMetadata!.balloonPoint.latitude,
//           "longitude": item.toponymMetadata!.balloonPoint.longitude,
//           "address": street.join(" "),
//           "province": province
//         };
//         if (street[0] != "") {
//           list.add(Container(
//             decoration: const BoxDecoration(
//                 border: Border(
//                     bottom: BorderSide(width: 1, color: Color(0xffD1D5DB)))),
//             child: ListTile(
//               onTap: () => sendData(data),
//               title: Text(street.join(" ")),
//               subtitle: Text(
//                 province.join(" "),
//                 style: TextStyle(color: ColorComponent.gray['500']),
//               ),
//             ),
//           ));
//         }
//       });
//     }

//     return list;
//   }

//   void sendData(item) {
//     // widget.getAddressData(item);
//     print(item);
//     Navigator.pop(context, item);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         bottom: false,
//         child: Column(
//           children: [
//             Container(
//                 height: 55,
//                 decoration: const BoxDecoration(
//                     color: Colors.white,
//                     border: Border(
//                         bottom:
//                             BorderSide(width: 1, color: Color(0xffE5E7EB)))),
//                 child: Row(
//                   children: [
//                     Container(
//                       width: 20,
//                       margin: const EdgeInsets.only(left: 16),
//                       child: TextButton(
//                           onPressed: () => Navigator.pop(context),
//                           style: TextButton.styleFrom(
//                               backgroundColor: Colors.transparent),
//                           child: SvgPicture.asset('assets/icons/left.svg',
//                               color: Colors.black)),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(left: 8, right: 5),
//                       child: SvgPicture.asset("assets/icons/search.svg",
//                           width: 18),
//                     ),
//                     Expanded(
//                       child: TextField(
//                         style: const TextStyle(fontSize: 16),
//                         keyboardType: TextInputType.text,
//                         textInputAction: TextInputAction.search,
//                         controller: textEditingController,
//                         onChanged: (value) {
//                           getAddress();
//                         },
//                         autofocus: true,
//                         decoration: const InputDecoration(
//                             contentPadding: EdgeInsets.zero,
//                             focusedBorder: OutlineInputBorder(
//                               borderSide: BorderSide(
//                                   width: 1, color: Colors.transparent),
//                             ),
//                             disabledBorder: OutlineInputBorder(
//                               borderSide: BorderSide(
//                                   width: 1, color: Colors.transparent),
//                             ),
//                             enabledBorder: OutlineInputBorder(
//                               borderSide: BorderSide(
//                                   width: 1, color: Colors.transparent),
//                             ),
//                             errorBorder: OutlineInputBorder(
//                                 borderSide: BorderSide(
//                                     width: 2, color: Colors.transparent)),
//                             focusedErrorBorder: OutlineInputBorder(
//                                 borderSide: BorderSide(
//                                     width: 2, color: Colors.transparent)),
//                             fillColor: Colors.white,
//                             hintText: "Поиск по городу"),
//                       ),
//                     ),
//                   ],
//                 )),
//             Expanded(
//               child: SingleChildScrollView(
//                   physics: const ClampingScrollPhysics(),
//                   child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: _getList())),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
