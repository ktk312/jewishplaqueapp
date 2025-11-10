import 'dart:convert';

import 'package:calendar_dashboard/model/plaque_model.dart';
import 'package:calendar_dashboard/network/mqtt_func.dart';
import 'package:calendar_dashboard/network/network_calls.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kosher_dart/kosher_dart.dart';
import 'package:mqtt_client/mqtt_client.dart';

import 'package:shared_preferences/shared_preferences.dart';

class MyAppController extends GetxController {
  final client = Rxn<MqttClient>();

  final currentMenuIndex = 0.obs;

  final plaqueList = <PlaqueModel>[].obs;

  final maleList = [].obs;
  final femaleList = [].obs;

  final isLoggedIn = false.obs;
  final userId = 0.obs;

  final token = ''.obs;

  final userEmail = ''.obs;

  Future<String> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    final result = await prefs.setString('token', token);
    if (result) {
      isLoggedIn(true);
      return 'success';
    }
    isLoggedIn(false);
    return 'fail';
  }

  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null) {
      isLoggedIn(true);
      return token;
    }
    isLoggedIn(false);
    return 'no_token';
  }

  Future<bool> logout() async {
    // logout here remove token from prefs
    final prefs = await SharedPreferences.getInstance();
    isLoggedIn(false);
    return await prefs.clear();
  }

  deleteRelative(String id) async {
    final response = await NetworkCalls().deleteRelative(id);
    if (response.contains('Error')) {
      Get.rawSnackbar(message: response, backgroundColor: Colors.red);
    } else {
      Get.rawSnackbar(
          message: 'Relative Deleted Successfully!',
          backgroundColor: Colors.green);
      getPlaques();
    }
  }

  updateCurrentYear(String id, bool isCurrentYear) async {
    var body = {"id": id, "currentyear": isCurrentYear};
    final response = await NetworkCalls().updateCurrentYear(body);
    if (response.contains('Error')) {
      Get.rawSnackbar(message: response, backgroundColor: Colors.red);
    } else {
      Get.rawSnackbar(
          message: 'Current Year Updated Successfully!',
          backgroundColor: Colors.green);
      getPlaques();
    }
  }

  deletePlaque(String id) async {
    final response = await NetworkCalls().deletePlaque(id);
    if (response.contains('Error')) {
      Get.rawSnackbar(message: response, backgroundColor: Colors.red);
    } else {
      Get.rawSnackbar(
          message: 'Plaque Deleted Successfully!',
          backgroundColor: Colors.green);
      getPlaques();
    }
  }

  getPlaques() async {
    try {
      final response = await NetworkCalls().getPlaque();
      print(response);
      if (!response.contains('Error')) {
        plaqueList.value = plaqueModelFromJson(response);
        maleList.clear();
        femaleList.clear();
        for (var element in plaqueList) {
          if (element.gender.toUpperCase() == "MALE") {
            maleList.add(element);
          } else {
            femaleList.add(element);
          }
        }

        maleList.sort((a, b) => a.hebruname.compareTo(b.hebruname));
        femaleList.sort((a, b) => a.hebruname.compareTo(b.hebruname));
      } else {
        Get.rawSnackbar(message: response, backgroundColor: Colors.red);
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  getCredentials() async {
    String returnString = '';
    final response = await NetworkCalls().getCredentials();
    if (response.contains('Error:')) {
      Get.rawSnackbar(
        message: 'Error fetching credentials',
        backgroundColor: Colors.red,
      );
    } else {
      print(response);

      returnString = response;
    }
    return returnString;
  }

  List<String> generateGregorianDates(JewishDate jDate) {
    List<String> gregorianDates = [];

    JewishDate todayJewishDate = JewishDate();

    // Determine the starting year
    int startYear = jDate.getJewishYear();

    // Check if the selected date is in the past
    bool isSelectedDateInPast = false;

    // Compare the selected date with today's date
    if (jDate.getJewishYear() < todayJewishDate.getJewishYear() ||
        (jDate.getJewishYear() == todayJewishDate.getJewishYear() &&
            jDate.getJewishMonth() < todayJewishDate.getJewishMonth()) ||
        (jDate.getJewishYear() == todayJewishDate.getJewishYear() &&
            jDate.getJewishMonth() == todayJewishDate.getJewishMonth() &&
            jDate.getJewishDayOfMonth() <
                todayJewishDate.getJewishDayOfMonth())) {
      isSelectedDateInPast = true;
    }

    if (isSelectedDateInPast) {
      startYear = todayJewishDate.getJewishYear();
      if (todayJewishDate.getJewishMonth() > jDate.getJewishMonth() ||
          (todayJewishDate.getJewishMonth() == jDate.getJewishMonth() &&
              todayJewishDate.getJewishDayOfMonth() >
                  jDate.getJewishDayOfMonth())) {
        startYear += 1; // Move to the next year
      }
    }

    for (int i = 0; i < 10; i++) {
      int currentYear = startYear + i;

      // Check if the current year is a leap year
      bool isLeapYear = (currentYear % 19 == 0 ||
          currentYear % 19 == 3 ||
          currentYear % 19 == 6 ||
          currentYear % 19 == 8 ||
          currentYear % 19 == 11 ||
          currentYear % 19 == 14 ||
          currentYear % 19 == 17);
      print('reached here');
      // Create a Hebrew date object
      int month = jDate.getJewishMonth();
      print('reached here');
      int day = jDate.getJewishDayOfMonth();

      print('reached here');

      if (month == 12 || month == 13) {
        print('inside month if');
        // Adar
        if (isLeapYear) {
          print('inside leapyear if ');
          // Generate for Adar I
          if (day <= 30) {
            print('inside leapyear day 30 ');
            // Check if day is valid for Adar I
            JewishDate jewishDateAdarI = JewishDate.initDate(
                jewishYear: currentYear,
                jewishMonth: 12, // Adar I
                jewishDayOfMonth: day);
            gregorianDates
                .add(jewishDateAdarI.getGregorianCalendar().toString());
          }

          // Generate for Adar II
          if (day <= 29) {
            print('inside leapyear day 29 ');
            // Check if day is valid for Adar II
            JewishDate jewishDateAdarII = JewishDate.initDate(
                jewishYear: currentYear,
                jewishMonth: 13, // Adar II
                jewishDayOfMonth: day);
            gregorianDates
                .add(jewishDateAdarII.getGregorianCalendar().toString());
          }
        } else {
          // If not a leap year, just generate for Adar
          if (day <= 29) {
            // Check if day is valid for Adar
            JewishDate jewishDate = JewishDate.initDate(
                jewishYear: currentYear,
                jewishMonth: month - 1,
                jewishDayOfMonth: day);
            gregorianDates.add(jewishDate.getGregorianCalendar().toString());
          }
        }
      } else {
        print('here reach');
        // For all other months, just generate the date
        if (day <= 30) {
          // Check if day is valid for other months
          JewishDate jewishDate = JewishDate.initDate(
              jewishYear: currentYear,
              jewishMonth: month,
              jewishDayOfMonth: day);
          gregorianDates.add(jewishDate.getGregorianCalendar().toString());
        }
      }
    }

    return gregorianDates;
  }
}
