import 'package:flutter/material.dart';
import 'package:gservice5/component/functions/token/changedToken.dart';
import 'package:gservice5/component/loader/loaderComponent.dart';
import 'package:gservice5/pages/auth/login/loginPage.dart';
import 'package:gservice5/pages/profile/contractor/contractorProfilePage.dart';
import 'package:gservice5/pages/profile/customer/customerProfilePage.dart';
import 'package:gservice5/pages/profile/individual/individualProfilePage.dart';

class VerifyProfilePage extends StatefulWidget {
  const VerifyProfilePage({super.key});

  @override
  State<VerifyProfilePage> createState() => _VerifyProfilePageState();
}

class _VerifyProfilePageState extends State<VerifyProfilePage> {
  bool verifyTokenData = false;
  String role = "";
  late Future<Widget> _futureData;

  @override
  void initState() {
    super.initState();
    _futureData = verifyToken();
  }

  Future<Widget> verifyToken() async {
    bool token = await ChangedToken().getToken() != null;
    if (token) {
      return await verifyRole();
    } else {
      return const LoginPage(showBackButton: false);
    }
  }

  Future verifyRole() async {
    String? role = await ChangedToken().getRole();
    if (role == "contractor") {
      return const ContractorProfilePage();
    } else if (role == "customer") {
      return const CustomerProfilePage();
    } else {
      return const IndividualProfilePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Widget>(
          future: _futureData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: LoaderComponent());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return const Center(child: Text('No data available'));
            } else {
              return snapshot.data!;
            }
          }),
    );
    // verifyTokenData
    //     ? role == "contractor"
    //         ? ContractorProfilePage()
    //         : role == "customer"
    //             ? CustomerProfilePage()
    //             : role == "individual"
    //                 ? const IndividualProfilePage()
    //                 : LoaderComponent()
    //     : const LoginPage(showBackButton: false);
  }
}
