import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gservice5/pages/auth/loginPage.dart';
import 'package:gservice5/pages/auth/registration/registrationPage.dart';
import 'package:gservice5/pages/auth/userExistsPage.dart';
import 'package:gservice5/pages/profile/profilePage.dart';

class VerifyProfilePage extends StatefulWidget {
  const VerifyProfilePage({super.key});

  @override
  State<VerifyProfilePage> createState() => _VerifyProfilePageState();
}

class _VerifyProfilePageState extends State<VerifyProfilePage> {
  bool verifyTokenData = false;

  @override
  void initState() {
    super.initState();
    verifyToken();
  }

  void verifyToken() async {
    bool token = await const FlutterSecureStorage().read(key: "token") != null;
    verifyTokenData = token;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return verifyTokenData
        ? const ProfilePage()
        : const UserExistsPage(showBack: false);
  }
}
