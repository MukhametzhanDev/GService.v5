import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/button/back/closeIconButton.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';
import 'package:permission_handler/permission_handler.dart';

class GalleryDeniedModal extends StatefulWidget {
  const GalleryDeniedModal({super.key});

  @override
  State<GalleryDeniedModal> createState() => _GalleryDeniedModalState();
}

class _GalleryDeniedModalState extends State<GalleryDeniedModal>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) checkGalleryPermission();
  }

  void checkGalleryPermission() async {
    var status = await Permission.photos.status;
    if (status == true) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        leadingWidth: 0,
        actions: [CloseIconButton(padding: true)],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/icons/camera.svg',
                  color: ColorComponent.mainColor),
              SizedBox(height: 30),
              Text(
                "Привлекайте больше клиентов!",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                "Для этого разрешите доступ к камере и галереи, чтобы вы могли добавлять изображения!",
                style: TextStyle(fontSize: 15, height: 1.7),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 10)
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBarComponent(
          child: Button(
              onPressed: () {
                AppSettings.openAppSettings(type: AppSettingsType.location);
              },
              padding: EdgeInsets.symmetric(horizontal: 15),
              title: "Разрешить доступ",
              backgroundColor: ColorComponent.mainColor)),
    );
  }
}
