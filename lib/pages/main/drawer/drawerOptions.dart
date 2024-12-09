import 'package:gservice5/pages/profile/news/allNewsPage.dart';

class DrawerOptions {
  static List options = [
    {
      "full_title": "Компании",
      "title": "Компании",
      "icon": "usersGroup.svg",
      "page": "AllNewsPage"
    },
    {
      "full_title": "Новости",
      "title": "Новости",
      "icon": "bullhorn.svg",
      "page": AllNewsPage(showBackButton: true)
    },
    {
      "full_title": "Гид",
      "title": "Гид",
      "icon": "userHeadset.svg",
      "page": "AllNewsPage"
    },
  ];
}
