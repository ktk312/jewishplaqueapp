import 'package:calendar_dashboard/const.dart';
import 'package:calendar_dashboard/dashboard.dart';
import 'package:calendar_dashboard/network/app_binding.dart';
import 'package:calendar_dashboard/network/app_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final myAppController = Get.put(MyAppController());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: MyAppBinding(),
      title: 'Jewish Plaque',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        primaryColor: MaterialColor(
          primaryColorCode,
          <int, Color>{
            50: const Color(primaryColorCode).withOpacity(0.1),
            100: const Color(primaryColorCode).withOpacity(0.2),
            200: const Color(primaryColorCode).withOpacity(0.3),
            300: const Color(primaryColorCode).withOpacity(0.4),
            400: const Color(primaryColorCode).withOpacity(0.5),
            500: const Color(primaryColorCode).withOpacity(0.6),
            600: const Color(primaryColorCode).withOpacity(0.7),
            700: const Color(primaryColorCode).withOpacity(0.8),
            800: const Color(primaryColorCode).withOpacity(0.9),
            900: const Color(primaryColorCode).withOpacity(1.0),
          },
        ),
        scaffoldBackgroundColor: const Color(0xFF171821),
        fontFamily: 'Alef',
        brightness: Brightness.dark,
        dialogTheme: const DialogTheme(backgroundColor: Colors.white),
        // DialogThemeData(backgroundColor: Colors.white)
      ),
      home: DashBoard(),
    );
  }
}
