import 'dart:convert';

import 'package:calendar_dashboard/responsive.dart';
import 'package:calendar_dashboard/const.dart';
import 'package:calendar_dashboard/network/app_controller.dart';
import 'package:calendar_dashboard/network/mqtt_func.dart';
import 'package:calendar_dashboard/network/network_calls.dart';
import 'package:calendar_dashboard/pages/cupertino_date.dart';
import 'package:calendar_dashboard/widgets/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:wheel_picker/wheel_picker.dart';
import 'package:get/get.dart';
import 'package:kosher_dart/kosher_dart.dart';
import 'package:intl/intl.dart';

class AddPlaque extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const AddPlaque({super.key, required this.scaffoldKey});

  @override
  State<AddPlaque> createState() => _AddPlaqueState();
}

class _AddPlaqueState extends State<AddPlaque> {
  MQTTClientWrapper newClient = MQTTClientWrapper();
  JewishDate jewishDateBirth = JewishDate();
  JewishCalendar jewishCalendarBirth = JewishCalendar();
  JewishDate jewishDateDeath = JewishDate();
  JewishCalendar jewishCalendarDeath = JewishCalendar();
  HebrewDateFormatter hebrewDateFormatter = HebrewDateFormatter();
  HebrewDateFormatter translatedDateFormatter = HebrewDateFormatter()
    ..hebrewFormat = false;

  String _selectedGender = "";
  TextEditingController fullNameController = TextEditingController();
  TextEditingController hebrewNameController = TextEditingController();
  TextEditingController ledController = TextEditingController();

  final myAppController = Get.find<MyAppController>();

  WheelPickerController controller29 = WheelPickerController(itemCount: 29);
  WheelPickerController controller30 = WheelPickerController(itemCount: 30);

  late WheelPickerController monthsController;
  List<String> gregorianDates = [];
  final textStyle = const TextStyle(fontSize: 32.0, height: 1.5);

  // final listOfMonths = <String>[].obs;

  List jDate = [];

  @override
  void initState() {
    hebrewDateFormatter.hebrewFormat = true;
    hebrewDateFormatter.useGershGershayim = true;
    super.initState();
    getAvailableLeds();
    monthsController = WheelPickerController(
        itemCount: translatedDateFormatter.transliteratedMonths.length);
  }

  // Initial Selected Value
  final dropdownvalue = 'Item 1'.obs;

  // List of items in our dropdown menu
  final availableLedsList = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ].obs;

  getAvailableLeds() async {
    List<String> returnList = [];
    final response = await NetworkCalls().getAvailableLeds();
    print("Response:::: $response");
    var arrayItems = jsonDecode(response)['availables_leds'];
    for (var item in arrayItems) {
      returnList.add(item.toString());
    }
    availableLedsList.value = returnList;
    dropdownvalue.value = availableLedsList.first;
    setState(() {});
  }

  connectMqttAndSendMessage() async {
    final response = await myAppController.getCredentials();
    if (response.contains('Error:')) {
      Get.rawSnackbar(
        message: 'Error fetching credentials',
        backgroundColor: Colors.red,
      );
    } else {
      print(response);
      final decodedResponse = jsonDecode(response);
      String host = decodedResponse['data']['host'];
      String port = decodedResponse['data']['port'];
      String username = decodedResponse['data']['username'];
      String password = decodedResponse['data']['password'];

      await newClient
          .prepareMqttClient(host, port, username, password)
          .then((value) => newClient.publishMessage("{'a':'a'}"));
    }
  }

  @override
  Widget build(BuildContext context) {
    SizedBox height(BuildContext context) => SizedBox(
          height: Responsive.isDesktop(context) ? 30 : 20,
        );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Plaque',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
              child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Responsive.isMobile(context) ? 15 : 18),
            child: Column(
              children: [
                SizedBox(
                  height: Responsive.isMobile(context) ? 5 : 18,
                ),
                height(context),
                SizedBox(
                    height: 35,
                    child: _getTextField(
                        context, fullNameController, 'Full Name')),
                height(context),
                SizedBox(
                    height: 35,
                    child: _getTextField(
                        context, hebrewNameController, 'Hebrew Name')),
                height(context),

                // SizedBox(
                //     height: 35,
                //     child: _getTextField(context, ledController, 'Led Number',
                //         keyboardType: TextInputType.number)),
                height(context),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                //   children: [
                //     WheelPicker(
                //       builder: (context, index) =>
                //           Text("$index", style: textStyle),
                //       controller: controller29,
                //       scrollDirection: Axis.vertical,
                //       selectedIndexColor: Colors.blue,
                //       onIndexChanged: (index) {
                //         print("On index $index");
                //       },
                //       style: WheelPickerStyle(
                //         itemExtent: textStyle.fontSize! *
                //             textStyle.height!, // Text height
                //         squeeze: 1.25,
                //         diameterRatio: .8,
                //         surroundingOpacity: .25,
                //         magnification: 1.2,
                //       ),
                //     ),
                //     WheelPicker(
                //       builder: (context, index) =>
                //           Text("$index", style: textStyle),
                //       controller: controller30,
                //       scrollDirection: Axis.vertical,
                //       selectedIndexColor: Colors.blue,
                //       onIndexChanged: (index) {
                //         print("On index $index");
                //       },
                //       style: WheelPickerStyle(
                //         itemExtent: textStyle.fontSize! *
                //             textStyle.height!, // Text height
                //         squeeze: 1.25,
                //         diameterRatio: .8,
                //         surroundingOpacity: .25,
                //         magnification: 1.2,
                //       ),
                //     ),
                //     Container(
                //       width: 140,
                //       child: WheelPicker(
                //         looping: true,
                //         builder: (context, index) => Text(
                //             "${translatedDateFormatter.transliteratedMonths[index]}",
                //             style: textStyle),
                //         controller: monthsController,
                //         scrollDirection: Axis.vertical,
                //         selectedIndexColor: Colors.blue,
                //         onIndexChanged: (index) {
                //           print("On index $index");
                //         },
                //         style: WheelPickerStyle(
                //           itemExtent: textStyle.fontSize! *
                //               textStyle.height!, // Text height
                //           squeeze: 1.25,
                //           diameterRatio: .8,
                //           surroundingOpacity: .25,
                //           magnification: 1.2,
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                height(context),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        const SizedBox(
                          height: 35,
                          child: Text(
                            "Select Led",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ),
                        SizedBox(
                          height: 50,
                          child: CustomCard(
                            child: DropdownButtonHideUnderline(
                              child: Obx(
                                () => DropdownButton(
                                  // Initial Value
                                  value: dropdownvalue.value,

                                  // Down Arrow Icon
                                  icon: const Icon(Icons.keyboard_arrow_down),

                                  // Array list of items
                                  items: availableLedsList.map((String item) {
                                    return DropdownMenuItem(
                                      value: item,
                                      child: Text(item),
                                    );
                                  }).toList(),
                                  // After selecting the desired option,it will
                                  // change button value to selected value
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      dropdownvalue.value = newValue!;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Radio<String>(
                              value: "male",
                              groupValue: _selectedGender,
                              onChanged: (value) =>
                                  setState(() => _selectedGender = value!),
                            ),
                            const Text("Male"),
                          ],
                        ),
                        height(context),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Radio<String>(
                              value: "female",
                              groupValue: _selectedGender,
                              onChanged: (value) =>
                                  setState(() => _selectedGender = value!),
                            ),
                            const Text("Female"),
                          ],
                        ),

                        // Add another Radio button for "Other" if needed
                      ],
                    ),
                  ],
                ),

                // const Text(
                //   "Select Date of Birth",
                //   style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                // ),
                height(context),
                // GestureDetector(
                //   onTap: () async {
                //     DateTime? pickedDate = await showDatePicker(
                //       context: context,
                //       initialDate: jewishCalendarBirth.getGregorianCalendar(),
                //       firstDate: DateTime(
                //           jewishCalendarBirth.getGregorianYear() - 100),
                //       lastDate: DateTime(
                //           jewishCalendarBirth.getGregorianYear() + 100),
                //     );

                //     if (pickedDate != null) {
                //       setState(() {
                //         jewishCalendarBirth.setDate(pickedDate);
                //         jewishDateBirth.setDate(pickedDate);
                //       });
                //     }
                //   },
                //   child: WeightHeightBloodCard(
                //     key1: 'תאריך לעוזי',
                //     value1: intl.DateFormat("dd MMM yyyy")
                //         .format(jewishDateBirth.getGregorianCalendar()),
                //     key2: 'תאריך עברי',
                //     value2: hebrewDateFormatter.format(jewishDateBirth),
                //     key3: 'תאריך מתורגם',
                //     value3: translatedDateFormatter.format(jewishDateBirth),
                //   ),
                // ),
                height(context),
                const Text(
                  "Select Date of Death",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                height(context),
                CustomCard(
                    child: Container(
                  child: GestureDetector(
                    onTap: () {
                      showHebrewCupertinoDatePicker(
                          confirmText: "Confirm",
                          initialDate: DateTime.now(),
                          context: context,
                          // Everytime the date is changed, the callback is called
                          onDateChanged: (dateTime) {
                            print(dateTime);
                          },
                          // When the users clicks on the confirm button, the onConfirm callback is called.
                          onConfirm: (dateTime) {
                            print('Confirm');

                            final jewishDate =
                                JewishDate.fromDateTime(dateTime);
                            print(jewishDate);
                            jDate.clear();
                            hebrewDateFormatter.hebrewFormat = true;
                            print(jewishDate);
                            print(hebrewDateFormatter.format(jewishDate));
                            jDate.add(hebrewDateFormatter.format(jewishDate));
                            jDate.add(dateTime);

                            gregorianDates.clear();
                            gregorianDates = myAppController
                                .generateGregorianDates(jewishDate);

                            gregorianDates.forEach((item) => print(item));

                            setState(() {});

                            print(dateTime);
                          });
                    },
                    child: ListTile(
                      title: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(jDate.isNotEmpty
                                  ? 'Hebrew Date'
                                  : 'Select Date'),
                              if (jDate.isNotEmpty) Text(jDate[0]),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(jDate.length > 1 ? 'Gregorian Date' : ''),
                              if (jDate.length > 1)
                                Text(
                                    DateFormat('dd MMM yyyy').format(jDate[1])),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )),

                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                    onTap: () async {
                      var body = {
                        "fullname": fullNameController.text,
                        "gender": _selectedGender,
                        "dob": 'not needed',
                        "dod": jDate[1].toString(),
                        "jdate": jDate[0].toString(),
                        "predate": gregorianDates.first,
                        "led": dropdownvalue.value,
                        "hebruname": hebrewNameController.text,
                        "dateList": jsonEncode(gregorianDates)
                      };

                      print(body);
                      final response = await NetworkCalls().postPlaque(body);
                      connectMqttAndSendMessage();
                      if (response.contains('Error:')) {
                        Get.rawSnackbar(
                            message: response,
                            backgroundColor: Colors.red.shade400);
                      } else {
                        Get.back(result: 'success');
                        Get.rawSnackbar(
                          message: 'Plaque added Successfully!',
                          backgroundColor: Colors.green.shade500,
                        );
                      }
                    },
                    child: const CustomCard(child: Text('Add Plaque')))
              ],
            ),
          ))),
    );
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
}
