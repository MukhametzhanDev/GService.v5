import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gservice5/component/button/back/backIconButton.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/map/searchMapAddressPage.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class GetMapAddressPage extends StatefulWidget {
  final onSavedData;
  Map? cityData;
  GetMapAddressPage(
      {super.key, required this.onSavedData, @required this.cityData});

  @override
  State<GetMapAddressPage> createState() => _GetMapAddressPageState();
}

class _GetMapAddressPageState extends State<GetMapAddressPage> {
  late YandexMapController controller;
  bool animatedImage = true;
  bool loader = false;
  var position;
  Point? currentCityPoint;

  @override
  void initState() {
    super.initState();
    verifyAddressData();
  }

  void verifyAddressData() {
    // if (EditData.adData.isNotEmpty && EditData.adData['address'] != null) {
    //   print('asdfasd');
    //   getCityPoint(
    //       widget.cityData?['title'] + " " + EditData.adData['address'], 15.0);
    // } else
    if (widget.cityData != null && widget.cityData?['title'] != null) {
      getCityPoint(widget.cityData?['title'], 12.0);
    }
  }

  Future getCityPoint(String address, double zoom) async {
    final resultWithSession = await YandexSearch.searchByText(
      searchText: address,
      geometry: Geometry.fromBoundingBox(const BoundingBox(
          southWest:
              Point(latitude: 55.76996383933034, longitude: 37.57483142322235),
          northEast: Point(
              latitude: 55.785322774728414, longitude: 37.590924677311705))),
      searchOptions:
          const SearchOptions(searchType: SearchType.geo, geometry: false),
    );
    SearchSessionResult searchSession = await resultWithSession.$2;
    if (searchSession.items!.isNotEmpty) {
      Point? cityPoint = searchSession.items!.first.geometry.first.point;
      currentCityPoint = cityPoint;
      setState(() {});
      changedCamera(cityPoint?.latitude, cityPoint?.longitude, zoom);
    }
  }

  void getData() async {
    final cameraPosition = await controller.getCameraPosition();
    if (animatedImage) {
      loader = true;
      setState(() {});
      try {
        final resultWithSession = await YandexSearch.searchByPoint(
            point: cameraPosition.target,
            searchOptions: const SearchOptions(
                searchType: SearchType.geo, geometry: false));
        _init(resultWithSession.$2);
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> _init(result) async {
    await _handleResult(await result);
  }

  Future<void> _handleResult(SearchSessionResult result) async {
    formattedValue(formattedLocation(result.items?.first));
  }

  void formattedValue(value) {
    print(value);
    position = {
      "latitude": value['latitude'].toString(),
      "longitude": value['longitude'].toString(),
      "address": value['address']
    };
    loader = false;
    setState(() {});
  }

  Future onMapCreated(YandexMapController yandexMapController) async {
    controller = yandexMapController;
    controller.toggleUserLayer(visible: true);
    var position = await _determinePosition();
    if (widget.cityData == null || widget.cityData!.isEmpty) {
      changedCamera(position.latitude, position.longitude, 12.0);
    }
  }

  void changedCamera(latitude, longitude, double zoom) {
    controller.moveCamera(
        CameraUpdate.newCameraPosition(CameraPosition(
            target: Point(latitude: latitude, longitude: longitude),
            zoom: zoom)),
        animation: MapAnimation(duration: 0.5));
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  void savedData() {
    widget.onSavedData(position);
    Navigator.pop(context);
  }

  String capitalized(String value) {
    String capitalizedString = "";
    if (value.isNotEmpty) {
      capitalizedString = value[0].toUpperCase() + value.substring(1);
    }
    return capitalizedString;
  }

  void showSearchAddressPage() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchMapAddressPage(
              currentCityPoint: currentCityPoint, cityData: widget.cityData!),
        )).then((value) {
      if (value != null) {
        changedCamera(value['latitude'], value['longitude'], 16.4);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackIconButton(),
        title: Text("Укажите адрес"),
        bottom: PreferredSize(
            preferredSize: Size(MediaQuery.of(context).size.width, 66),
            child: Container(
              height: 66,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(width: 1, color: Color(0xffE5E7EB)))),
              child: GestureDetector(
                onTap: showSearchAddressPage,
                child: Container(
                  height: 42,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(width: 1, color: Color(0xffE5E7EB))),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset('assets/icons/searchOutline.svg',
                          width: 18, color: ColorComponent.gray['500']),
                      SizedBox(width: 8),
                      Text("Поиск по городу",
                          style: TextStyle(color: ColorComponent.gray['500']))
                    ],
                  ),
                ),
              ),
            )),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          YandexMap(
            onCameraPositionChanged: (cameraPosition, reason, finished) {
              if (animatedImage != finished) {
                animatedImage = finished;
                setState(() {});
                getData();
              }
            },
            onMapCreated: (YandexMapController yandexMapController) async {
              await onMapCreated(yandexMapController);
            },
            onUserLocationAdded: (UserLocationView view) async {
              return view.copyWith(
                  pin: view.pin.copyWith(
                      opacity: 1,
                      icon: PlacemarkIcon.single(PlacemarkIconStyle(
                          image: BitmapDescriptor.fromAssetImage(
                              'assets/images/locationUser.png')))),
                  arrow: view.arrow.copyWith(
                      opacity: 1,
                      zIndex: 100,
                      icon: PlacemarkIcon.single(PlacemarkIconStyle(
                          image: BitmapDescriptor.fromAssetImage(
                              'assets/images/locationUser.png')))),
                  accuracyCircle: view.accuracyCircle.copyWith(
                      fillColor: Colors.transparent,
                      strokeColor: Colors.grey.withOpacity(0.3),
                      strokeWidth: 2));
            },
          ),
          UserLocaitonWidget(animatedImage, loader),
          Positioned(
            right: 16,
            child: Container(
              width: 44,
              height: 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Expanded(
                    child: GestureDetector(
                        onTap: () {
                          controller.moveCamera(CameraUpdate.zoomIn(),
                              animation: MapAnimation(duration: 0.4));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12)),
                          alignment: Alignment.center,
                          child: Text(
                            "+",
                            style: TextStyle(fontSize: 24),
                          ),
                        )),
                  ),
                  Container(
                      width: 32, height: 1, color: ColorComponent.gray['200']),
                  Expanded(
                    child: GestureDetector(
                        onTap: () {
                          controller.moveCamera(CameraUpdate.zoomOut(),
                              animation: MapAnimation(duration: 0.4));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12)),
                          alignment: Alignment.center,
                          child: Text(
                            "-",
                            style: TextStyle(fontSize: 24),
                          ),
                        )),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var position = await _determinePosition();
          changedCamera(position.latitude, position.longitude, 16.4);
        },
        elevation: 1,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: SvgPicture.asset(
          'assets/icons/locationOutline.svg',
          width: 32,
          color: Colors.black,
        ),
      ),
      bottomNavigationBar: BottomNavigationBarComponent(
          child: Container(
        constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).padding.bottom + 98),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: 5),
            loader
                ? Container(
                    width: 20,
                    height: 20,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                        color: ColorComponent.blue['500']))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 3.0),
                            child: SvgPicture.asset(
                                'assets/icons/pinOutline.svg',
                                color: ColorComponent.gray['500'],
                                width: 18),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(capitalized(position?['address'] ?? ""),
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 16)),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 6),
                        child: Text(widget.cityData?['title'] ?? "",
                            style: TextStyle(
                                color: ColorComponent.gray['500'],
                                fontWeight: FontWeight.w500)),
                      )
                    ],
                  ),
            SizedBox(height: 15),
            Button(onPressed: savedData, title: "Сохранить")
            // TextButton(
            //     onPressed: ,
            //     style: TextButton.styleFrom(
            //         backgroundColor: ColorComponent.mainColor,
            //         shape: RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(8))),
            //     child: Container(
            //         alignment: Alignment.center,
            //         height: 50,
            //         child: loader
            //             ? Container(
            //                 width: 20,
            //                 height: 20,
            //                 alignment: Alignment.center,
            //                 child:
            //                     CircularProgressIndicator(color: Colors.white))
            //             : Text(
            //                 "Сохранить",
            //                 style: TextStyle(
            //                     fontSize: 16,
            //                     fontWeight: FontWeight.w600,
            //                     color: Colors.white),
            //               ))),
          ],
        ),
      )),
    );
  }
}

Widget UserLocaitonWidget(animatedImage, loader) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 40),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedContainer(
            width: 40,
            height: 46,
            margin: EdgeInsets.only(bottom: animatedImage ? 0 : 10),
            duration: Duration(milliseconds: 200),
            child: Column(
              children: [
                Container(
                    width: 40,
                    height: 46,
                    alignment: Alignment.center,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(12)),
                    child: SvgPicture.asset('assets/icons/location.svg',
                        height: 34)),
              ],
            )),
        AnimatedContainer(
          width: animatedImage ? 15 : 40,
          height: 10,
          duration: Duration(milliseconds: 200),
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage('assets/images/shadow.png'),
          )),
        ),
      ],
    ),
  );
}

Map formattedLocation(item) {
  Map data = {};
  List<String> street = ["", ""];
  List<String> province = ["", ""];
  print(item.toponymMetadata!.address.addressComponents);
  item.toponymMetadata!.address.addressComponents.forEach((key, value) {
    if (key == SearchComponentKind.street ||
        key == SearchComponentKind.district ||
        key == SearchComponentKind.hydro ||
        key == SearchComponentKind.area) {
      street[0] = value.toString();
    } else if (key == SearchComponentKind.house) {
      street[1] = value.toString();
    } else if (key == SearchComponentKind.country) {
      province[0] = value.toString();
    } else if (key == SearchComponentKind.province ||
        key == SearchComponentKind.locality) {
      province[1] = value.toString();
    }
  });
  data = {
    "latitude": item.toponymMetadata!.balloonPoint.latitude,
    "longitude": item.toponymMetadata!.balloonPoint.longitude,
    "address": street.join(" "),
    "province": province
  };
  return data;
}
