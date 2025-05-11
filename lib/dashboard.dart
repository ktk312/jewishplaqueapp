import 'package:calendar_dashboard/network/app_controller.dart';
import 'package:calendar_dashboard/pages/admin/admin.dart';
import 'package:calendar_dashboard/pages/auth/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:calendar_dashboard/pages/home/home_page.dart';
import 'package:calendar_dashboard/widgets/menu.dart';
// import 'package:calendar_dashboard/Responsive.dart';
import './responsive.dart';
import 'package:get/get.dart';
import './pages/auth/login.dart';

class DashBoard extends StatefulWidget {
  DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  final myAppController = Get.find<MyAppController>();

  bool isLoading = false;

  int currentPage = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // setup();
  }

  // setup() async {
  //   isLoading = true;
  //   setState(() {});
  //   await myAppController.getToken();
  //   isLoading = false;
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        drawer: !Responsive.isDesktop(context)
            ? SizedBox(width: 250, child: Menu(scaffoldKey: _scaffoldKey))
            : null,
        body: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isLoading
                  ? Container(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Obx(
                      () => Expanded(
                          flex: 1,
                          child: myAppController.token.value == ''
                              ? myAppController.isLoginPage.value
                                  ?
                                  //admin123##
                                  // AdminPage()
                                  LoginPage(scaffoldKey: _scaffoldKey)
                                  : SignUpPage(scaffoldKey: _scaffoldKey)
                              : HomePage(scaffoldKey: _scaffoldKey)),
                    ),
            ],
          ),
        ));
  }
}
