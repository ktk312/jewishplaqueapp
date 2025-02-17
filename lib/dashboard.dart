import 'package:calendar_dashboard/network/app_controller.dart';
import 'package:flutter/material.dart';
import 'package:calendar_dashboard/pages/home/home_page.dart';
import 'package:calendar_dashboard/widgets/menu.dart';
// import 'package:calendar_dashboard/Responsive.dart';
import './responsive.dart';
import 'package:get/get.dart';

class DashBoard extends StatelessWidget {
  DashBoard({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final myAppController = Get.find<MyAppController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        drawer: !Responsive.isDesktop(context)
            ? SizedBox(width: 250, child: Menu(scaffoldKey: _scaffoldKey))
            : null,
        body: SafeArea(
          child: Row(
            children: [
              Expanded(flex: 1, child: HomePage(scaffoldKey: _scaffoldKey)),
            ],
          ),
        ));
  }
}
