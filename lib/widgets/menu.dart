import 'package:calendar_dashboard/network/app_controller.dart';
import 'package:flutter/material.dart';
import 'package:calendar_dashboard/responsive.dart';
import 'package:calendar_dashboard/model/menu_modal.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class Menu extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const Menu({super.key, required this.scaffoldKey});

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  final myAppController = Get.find<MyAppController>();
  List<MenuModel> menu = [
    MenuModel(icon: 'assets/svg/home.svg', title: "Dashboard"),
    MenuModel(icon: 'assets/svg/profile.svg', title: "Add Relative"),
    MenuModel(icon: 'assets/svg/exercise.svg', title: "Add Plaque"),
    MenuModel(icon: 'assets/svg/setting.svg', title: "Test Led"),

    // MenuModel(icon: 'assets/svg/setting.svg', title: "Settings"),
    // MenuModel(icon: 'assets/svg/history.svg', title: "History"),
    // MenuModel(icon: 'assets/svg/signout.svg', title: "Signout"),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
          border: Border(
            right: BorderSide(
              color: Colors.grey[800]!,
              width: 1,
            ),
          ),
          color: const Color(0xFF171821)),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
            child: Column(
          children: [
            SizedBox(
              height: Responsive.isMobile(context) ? 40 : 80,
            ),
            for (var i = 0; i < menu.length; i++)
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(6.0),
                  ),
                  color: myAppController.currentMenuIndex.value == i
                      ? Theme.of(context).primaryColor
                      : Colors.transparent,
                ),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      myAppController.currentMenuIndex.value = i;
                    });
                    widget.scaffoldKey.currentState!.closeDrawer();
                  },
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 13, vertical: 7),
                        child: SvgPicture.asset(
                          menu[i].icon,
                          color: myAppController.currentMenuIndex.value == i
                              ? Colors.black
                              : Colors.grey,
                        ),
                      ),
                      Text(
                        menu[i].title,
                        style: TextStyle(
                            fontSize: 16,
                            color: myAppController.currentMenuIndex.value == i
                                ? Colors.black
                                : Colors.grey,
                            fontWeight:
                                myAppController.currentMenuIndex.value == i
                                    ? FontWeight.w600
                                    : FontWeight.normal),
                      )
                    ],
                  ),
                ),
              ),
          ],
        )),
      ),
    );
  }
}
