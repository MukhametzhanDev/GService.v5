import 'package:share_plus/share_plus.dart';

class MessageInviteApp {
  Future sendCompanyInvite(String companyName) async {
    String message =
        "Вас приглашает компания $companyName\n📲 Скачайте приложение GService.kz!\nКоллега, установите для удобной работы:\n\n✅ Быстрый доступ к информации.\n✅ Инструменты для продуктивности.\n✅ Новости и обновления.\n\n📥 Доступно на App Store и Google Play\n\nAppStore:\nhttps://apps.apple.com/kz/app/gservice/id1627674303\n\nGoogle Play:\nhttps://play.google.com/store/search?q=gservice&c=apps&hl=ru";
    await Share.share(message);
  }

  Future sendUserInvite() async {
    String message =
        "📲 Скачайте приложение GService.kz!\n\n📥 Доступно на App Store и Google Play\n\nAppStore:\nhttps://apps.apple.com/kz/app/gservice/id1627674303\n\nGoogle Play:\nhttps://play.google.com/store/search?q=gservice&c=apps&hl=ru";
    await Share.share(message);
  }
}
