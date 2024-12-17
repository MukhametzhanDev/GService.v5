import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/image/cacheImage.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:story_view/story_view.dart';

class ViewBannerPage extends StatefulWidget {
  final List data;
  const ViewBannerPage({super.key, required this.data});

  @override
  State<ViewBannerPage> createState() => _ViewBannerPageState();
}

class _ViewBannerPageState extends State<ViewBannerPage> {
  final StoryController controller = StoryController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          shape: RoundedRectangleBorder(side: BorderSide(width: 0)),
          backgroundColor: Colors.black,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.black,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.dark,
          ),
        ),
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: StoryView(
                    onVerticalSwipeComplete: (p0) {
                      if (p0 == Direction.down) {
                        Navigator.pop(context);
                      } else if (p0 == Direction.up) {}
                    },
                    controller: controller,
                    indicatorColor: Colors.white,
                    indicatorForegroundColor: ColorComponent.mainColor,
                    storyItems: widget.data.map((value) {
                      return StoryItem.pageImage(
                          url: value,
                          controller: controller,
                          shown: true,
                          imageFit: BoxFit.cover);
                      // StoryItem.inlineProviderImage(
                      //     CachedNetworkImageProvider(value),
                      //     shown: true,
                      //     roundedBottom: true);
                    }).toList(),
                    onComplete: () {
                      Navigator.pop(context);
                    },
                    progressPosition: ProgressPosition.top,
                    repeat: false,
                    inline: true,
                  ),
                ),
                Positioned(
                    left: 15,
                    top: 25,
                    right: 15,
                    child: GestureDetector(
                      child: Row(
                        children: [
                          CacheImage(
                              url:
                                  "https://images.unsplash.com/photo-1608541737042-87a12275d313?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjN8fG5pa2V8ZW58MHx8MHx8fDA%3D",
                              width: 30,
                              height: 30,
                              borderRadius: 50),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "NIke",
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                              maxLines: 2,
                            ),
                          )
                        ],
                      ),
                    )),
                Positioned(
                    bottom: 10,
                    left: 15,
                    right: 15,
                    child: Button(
                        onPressed: () {},
                        backgroundColor: ColorComponent.mainColor.withOpacity(.9),
                        titleColor: Colors.black,
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        title: "Подробнее"))
              ],
            ),
          ),
        ));
  }
}
