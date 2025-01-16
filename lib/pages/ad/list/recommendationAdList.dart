import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/pages/ad/item/smallAdItem.dart';

class RecommendationAdList extends StatefulWidget {
  final int id;
  const RecommendationAdList({super.key, required this.id});

  @override
  State<RecommendationAdList> createState() => _RecommendationAdListState();
}

class _RecommendationAdListState extends State<RecommendationAdList> {
  List data = [];
  bool loading = true;

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future getData() async {
    try {
      Response response = await dio.get("/similar-ad/${widget.id}");
      if (response.data['success']) {
        data = splitIntoChunks(response.data['data']);
        loading = false;
        setState(() {});
      } else {
        SnackBarComponent().showResponseErrorMessage(response, context);
      }
    } catch (e) {
      SnackBarComponent().showNotGoBackServerErrorMessage(context);
    }
  }

  List<List<T>> splitIntoChunks<T>(List<T> list) {
    List<List<T>> chunks = [];
    for (int i = 0; i < list.length; i += 2) {
      chunks.add(
        list.sublist(i, i + 2 > list.length ? list.length : i + 2),
      );
    }
    return chunks;
  }

  @override
  Widget build(BuildContext context) {
    return data.isEmpty
        ? const SliverToBoxAdapter()
        : SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 7.5),
            sliver: SliverList.builder(
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                print('asd');
                List value = data[index];
                if (index == 0) {
                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(height: 1, color: Color(0xfff4f5f7)),
                        const Divider(indent: 16),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 7.5),
                          child: Text("Вам могут понравится",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600)),
                        ),
                        const SizedBox(height: 15),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: value.map((childValue) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 7.5),
                                child: SmallAdItem(
                                    data: childValue, showFullInfo: true),
                              );
                            }).toList())
                      ]);
                }
                return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: value.map((childValue) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 7.5),
                        child:
                            SmallAdItem(data: childValue, showFullInfo: true),
                      );
                    }).toList());
              },
              // GridView.count(
              //     shrinkWrap: true,
              //     physics: const NeverScrollableScrollPhysics(),
              //     crossAxisCount: 2,
              //     childAspectRatio: 0.98,
              //     mainAxisSpacing: 12,
              //     crossAxisSpacing: 8,
              //     padding: const EdgeInsets.symmetric(horizontal: 15),
              //     children: data.map((value) {
              //       return SmallAdItem(data: value, showFullInfo: true);
              //     }).toList())
            ),
          );
  }
}
