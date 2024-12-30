import 'package:gservice5/pages/companies/companiesMainPage.dart';
import 'package:gservice5/pages/profile/news/allNewsPage.dart';

class DrawerOptions {
  static List options = [
    {
      "full_title": "Компании",
      "title": "Компании",
      "icon": "usersGroup.svg",
      "page": const CompaniesMainPage()
    },
    {
      "full_title": "Новости",
      "title": "Новости",
      "icon": "bullhorn.svg",
      "page": const AllNewsPage(showBackButton: true)
    },
    {
      "full_title": "Гид",
      "title": "Гид",
      "icon": "userHeadset.svg",
      "page": "AllNewsPage"
    },
  ];
}
