import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/button/back/closeIconButton.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:photo_view/photo_view.dart';

class ViewImageModal extends StatefulWidget {
  final List data;
  final int index;
  const ViewImageModal({
    super.key,
    required this.data,
    required this.index,
  });

  @override
  State<ViewImageModal> createState() => _ViewImageModalState();
}

class _ViewImageModalState extends State<ViewImageModal> {
  late PageController controller =
      PageController(viewportFraction: 1, keepPage: true);
  int mainImage = 0;
  int indexImage = 0;

  @override
  void initState() {
    super.initState();
    controller = PageController(
        viewportFraction: 1, keepPage: true, initialPage: widget.index);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
    indexImage = widget.index;
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
              controller: controller,
              onPageChanged: (index) {
                indexImage = index;
                setState(() {});
              },
              itemCount: widget.data.length,
              itemBuilder: (context, index) {
                return PhotoView(
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.covered * 2,
                  backgroundDecoration: const BoxDecoration(color: Colors.black),
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      alignment: Alignment.center,
                      child: SvgPicture.asset('assets/icons/warningAlarm.svg',
                          color: Colors.white, height: 50, width: 50),
                    );
                  },
                  imageProvider: NetworkImage(
                      widget.data[index].runtimeType == String
                          ? widget.data[index]
                          : widget.data[index]?['url']),
                );
              },
            ),
            Positioned(
              left: 15,
              top: 15,
              child: SizedBox(
                width: MediaQuery.of(context).size.width - 30,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.6),
                            borderRadius: BorderRadius.circular(30)),
                        child: Text("${indexImage + 1}/${widget.data.length}",
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w500))),
                    const CloseIconButton(iconColor: Colors.white, padding: false),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
