import 'dart:convert';

import 'package:calendar_dashboard/const.dart';
import 'package:calendar_dashboard/network/app_controller.dart';
import 'package:calendar_dashboard/network/mqtt_func.dart';
import 'package:calendar_dashboard/network/network_calls.dart';
import 'package:calendar_dashboard/pages/add_plaque/add_plaque.dart';
import 'package:calendar_dashboard/pages/home/plaque_detail_page.dart';
import 'package:calendar_dashboard/widgets/custom_card.dart';

import 'package:flutter/material.dart';
import 'package:calendar_dashboard/responsive.dart';
import 'package:get/get.dart';
import 'package:kosher_dart/kosher_dart.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({
    super.key,
  });

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final appController = Get.find<MyAppController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  var allLedsList = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];

  getAllLeds() async {
    List<String> returnList = [];
    final response = await NetworkCalls().getAllLeds();
    print("Response:::: $response");
    var arrayItems = jsonDecode(response)['led_numbers'];
    for (var item in arrayItems) {
      returnList.add(item.toString());
    }
    allLedsList = returnList;

    setState(() {});
  }

  Widget _getTextField(
      BuildContext context, TextEditingController controller, String hintText) {
    return TextField(
      controller: controller,
      // keyboardType:TextInputType.number,
      decoration: InputDecoration(
        filled: true,
        fillColor: cardBackgroundColor,
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        hintText: hintText,
        // prefixIcon: const Icon(
        //   Icons.search,
        //   color: Colors.grey,
        //   size: 21,
        // )
      ),
    );
  }

  TextEditingController addLedController = TextEditingController();

  HebrewDateFormatter hebrewDateFormatter = HebrewDateFormatter();
  @override
  Widget build(BuildContext context) {
    SizedBox height(BuildContext context) => SizedBox(
          height: Responsive.isDesktop(context) ? 30 : 20,
        );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Admin Setting',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        // centerTitle: true,
      ),
      body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
              child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Responsive.isMobile(context) ? 15 : 18),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: Responsive.isMobile(context) ? 5 : 18,
                ),
                height(context),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          // width: Get.size.width / 3.2,
                          height: Get.size.height - 120,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                const Text(
                                  'Users List',
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: 50,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                          bottom: 10,
                                        ),
                                        child: CustomCard(
                                          child: Text('Hello'),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          )),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      flex: 4,
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          // width: Get.size.width,
                          height: Get.size.height - 120,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                const Text(
                                  'Users List',
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                height(context),
                                SizedBox(
                                  width: Get.size.width,
                                  child: const Text(
                                    'Add Leds',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                    height: 35,
                                    child: _getTextField(context,
                                        addLedController, 'Enter Led')),
                                height(context),
                                const Text(
                                    'Format Led: M1_01 for Master and N1_01 for Node'),
                                height(context),
                                GestureDetector(
                                    onTap: () async {
                                      //post led call
                                      var body = {
                                        "led_number": addLedController.text
                                      };
                                      print(body);

                                      final response =
                                          await NetworkCalls().postLed(body);
                                      if (response.contains('Error')) {
                                        Get.rawSnackbar(
                                          message: response,
                                          backgroundColor: Colors.red,
                                        );
                                      }
                                      Get.rawSnackbar(
                                        message: 'Message Saved Successfully!',
                                        backgroundColor: Colors.green.shade500,
                                      );
                                      getAllLeds();
                                    },
                                    child: const CustomCard(
                                        child: Text('Save Led'))),
                                height(context),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: allLedsList.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                          bottom: 10,
                                        ),
                                        child: CustomCard(
                                          child: Text(allLedsList[index]),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          )),
                    ),
                  ],
                ),
              ],
            ),
          ))),
    );
  }
}
