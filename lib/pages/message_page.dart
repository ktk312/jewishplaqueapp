import 'dart:async';
import 'dart:convert';

import 'package:calendar_dashboard/responsive.dart';
import 'package:calendar_dashboard/const.dart';
import 'package:calendar_dashboard/network/app_controller.dart';
import 'package:calendar_dashboard/network/mqtt_func.dart';
import 'package:calendar_dashboard/network/network_calls.dart';
import 'package:calendar_dashboard/widgets/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessagePage extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const MessagePage({super.key, required this.scaffoldKey});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

// A relative date of passing is coming up for :
class _MessagePageState extends State<MessagePage> {
  MQTTClientWrapper newclient = MQTTClientWrapper();

  TextEditingController messageController = TextEditingController();
  TextEditingController addLedController = TextEditingController();
  TextEditingController testLedController = TextEditingController();
  TextEditingController website1Controller = TextEditingController();

  TextEditingController website2Controller = TextEditingController();
  TextEditingController website3Controller = TextEditingController();
  TextEditingController hostController = TextEditingController();
  TextEditingController portController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController timerController = TextEditingController();

  final appController = Get.find<MyAppController>();

  final textStyle = const TextStyle(fontSize: 32.0, height: 1.5);
  Timer? timmer;
  bool isTesting = false;
  String message = '';
  @override
  void initState() {
    super.initState();
    getMessage();
    getAllLeds();
    getWebsites();
    getCredentials();
  }

  getWebsites() async {
    final response = await NetworkCalls().getWebsites();
    if (response.contains('Error:')) {
      Get.rawSnackbar(
        message: 'Error fetching websites',
        backgroundColor: Colors.red,
      );
    } else {
      print(response);
      final decodedResponse = jsonDecode(response);
      website1Controller.text = decodedResponse['link1'];
      website2Controller.text = decodedResponse['link2'];
      website3Controller.text = decodedResponse['link3'];
      timerController.text = decodedResponse['timer'];
    }
  }

  getCredentials() async {
    final response = await appController.getCredentials();
    if (response.contains('Error:')) {
      Get.rawSnackbar(
        message: 'Error fetching credentials',
        backgroundColor: Colors.red,
      );
    } else {
      print(response);
      final decodedResponse = jsonDecode(response);
      hostController.text = decodedResponse['data']['host'];
      portController.text = decodedResponse['data']['port'];
      userNameController.text = decodedResponse['data']['username'];
      passwordController.text = decodedResponse['data']['password'];

      await newclient.prepareMqttClient(
          hostController.text,
          portController.text,
          userNameController.text,
          passwordController.text);
    }
  }

  // Initial Selected Value
  String dropdownvalue = 'Item 1';

  // List of items in our dropdown menu
  var allLedsList = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];

  getMessage() async {
    final response = await NetworkCalls().getMessage();
    print("Response:::: $response");
    message = jsonDecode(response)['messages'][0]['message'];
    messageController.text = jsonDecode(response)['messages'][0]['message'];
    setState(() {});
  }

  getAllLeds() async {
    List<String> returnList = [];
    final response = await NetworkCalls().getAllLeds();
    print("Response:::: $response");
    var arrayItems = jsonDecode(response)['led_numbers'];
    for (var item in arrayItems) {
      returnList.add(item.toString());
    }
    allLedsList = returnList;
    dropdownvalue = allLedsList.first;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    SizedBox height(BuildContext context) => SizedBox(
          height: Responsive.isDesktop(context) ? 30 : 20,
        );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        actions: [
          Text('User ID: ${appController.userId.value}'),
          SizedBox(
            width: 10,
          )
        ],
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
                height(context),
                SizedBox(
                  width: Get.size.width,
                  child: const Text(
                    'Message',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                SizedBox(
                    height: 35,
                    child: _getTextField(
                        context, messageController, 'SMS Message')),
                height(context),
                GestureDetector(
                    onTap: () async {
                      // message post call
                      var body = {"message": messageController.text};

                      final response = await NetworkCalls().postMessage(body);
                      if (response.contains('Error')) {
                        Get.rawSnackbar(
                          message: response,
                          backgroundColor: Colors.red,
                        );
                      }
                      Get.back(result: 'success');
                      Get.rawSnackbar(
                        message: 'Message Saved Successfully!',
                        backgroundColor: Colors.green.shade500,
                      );
                      getMessage();
                    },
                    child: const CustomCard(child: Text('Save Message'))),
                height(context),
                // SizedBox(
                //   width: Get.size.width,
                //   child: const Text(
                //     'Add Leds',
                //     textAlign: TextAlign.left,
                //     style: TextStyle(
                //       fontSize: 18,
                //     ),
                //   ),
                // ),
                // SizedBox(
                //     height: 35,
                //     child:
                //         _getTextField(context, addLedController, 'Enter Led')),
                // height(context),
                // const Text('Format Led: M1_01 for Master and N1_01 for Node'),
                // height(context),
                // GestureDetector(
                //     onTap: () async {
                //       //post led call
                //       var body = {"led_number": addLedController.text};
                //       print(body);

                //       final response = await NetworkCalls().postLed(body);
                //       if (response.contains('Error')) {
                //         Get.rawSnackbar(
                //           message: response,
                //           backgroundColor: Colors.red,
                //         );
                //       }
                //       Get.rawSnackbar(
                //         message: 'Message Saved Successfully!',
                //         backgroundColor: Colors.green.shade500,
                //       );
                //       getAllLeds();
                //     },
                //     child: const CustomCard(child: Text('Save Led'))),
                // height(context),
                SizedBox(
                  width: Get.size.width,
                  child: const Text(
                    'Led Setting',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        const SizedBox(
                          width: 20,
                        ),
                        GestureDetector(
                            onTap: () async {
                              // var body = {
                              //   "led_number":

                              //       // addLedController.text
                              //       "N1-15"
                              // };

                              var body = {
                                "led_number": 'all',
                                "userId": appController.userId.value
                              };
                              print(body);
                              isTesting = true;
                              setState(() {});

                              final response =
                                  await NetworkCalls().testLed(body);
                              if (response.contains('Error')) {
                                Get.rawSnackbar(
                                  message: response,
                                  backgroundColor: Colors.red,
                                );
                              }
                              newclient.publishMessage(jsonEncode(body));
                              Get.rawSnackbar(
                                message: 'Led Tested Successfully!',
                                backgroundColor: Colors.green.shade500,
                              );
                              isTesting = false;
                              setState(() {});
                            },
                            child: CustomCard(
                                child: Text(isTesting
                                    ? 'Testing ...'
                                    : 'Test All Led'))),
                      ],
                    ),
                  ],
                ),
                height(context),
                SizedBox(
                  width: Get.size.width,
                  child: const Text(
                    'Add Websites for TV App',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                height(context),
                SizedBox(
                    height: 35,
                    child: _getTextField(
                        context, website1Controller, 'Website 1')),
                height(context),
                SizedBox(
                    height: 35,
                    child: _getTextField(
                        context, website2Controller, 'Website 2')),
                height(context),
                SizedBox(
                    height: 35,
                    child: _getTextField(
                        context, website3Controller, 'Website 3')),
                height(context),
                SizedBox(
                    height: 35,
                    child: _getTextField(
                        context, timerController, 'Slide Time Seconds')),
                height(context),
                GestureDetector(
                    onTap: () async {
                      var body = {
                        "link1": website1Controller.text,
                        "link2": website2Controller.text,
                        "link3": website3Controller.text,
                        "timer": timerController.text
                      };

                      final response = await NetworkCalls().saveWebsites(body);
                      if (response.contains('Error')) {
                        Get.rawSnackbar(
                          message: response,
                          backgroundColor: Colors.red,
                        );
                      }
                      Get.rawSnackbar(
                        message: 'Website Saved Successfully!',
                        backgroundColor: Colors.green.shade500,
                      );
                      // isTesting = false;
                      setState(() {});
                    },
                    child: const CustomCard(child: Text('Save'))),
                height(context),
                height(context),
                // SizedBox(
                //   width: Get.size.width,
                //   child: const Text(
                //     'Mqtt Credentials for Led\'s Test (For Admin Only - Do not change)',
                //     textAlign: TextAlign.left,
                //     style: TextStyle(
                //       fontSize: 18,
                //     ),
                //   ),
                // ),
                // height(context),
                // SizedBox(
                //   width: Get.size.width,
                //   child: const Text(
                //     'Host',
                //     textAlign: TextAlign.left,
                //     style: TextStyle(
                //       fontSize: 14,
                //     ),
                //   ),
                // ),
                // SizedBox(
                //     height: 35,
                //     child: _getTextField(context, hostController, 'Host')),
                // height(context),
                // SizedBox(
                //   width: Get.size.width,
                //   child: const Text(
                //     'Port (for wss:// protocol)',
                //     textAlign: TextAlign.left,
                //     style: TextStyle(
                //       fontSize: 14,
                //     ),
                //   ),
                // ),
                // SizedBox(
                //     height: 35,
                //     child: _getTextField(context, portController, 'Port')),
                // height(context),
                // SizedBox(
                //   width: Get.size.width,
                //   child: const Text(
                //     'Username',
                //     textAlign: TextAlign.left,
                //     style: TextStyle(
                //       fontSize: 14,
                //     ),
                //   ),
                // ),
                // SizedBox(
                //     height: 35,
                //     child:
                //         _getTextField(context, userNameController, 'Username')),
                // height(context),
                // SizedBox(
                //   width: Get.size.width,
                //   child: const Text(
                //     'Password',
                //     textAlign: TextAlign.left,
                //     style: TextStyle(
                //       fontSize: 14,
                //     ),
                //   ),
                // ),
                // SizedBox(
                //     height: 35,
                //     child:
                //         _getTextField(context, passwordController, 'Password')),
                // height(context),
                // GestureDetector(
                //     onTap: () async {
                //       var body = {
                //         "host": hostController.text,
                //         "port": portController.text,
                //         "username": userNameController.text,
                //         "password": passwordController.text
                //       };

                //       final response =
                //           await NetworkCalls().saveCredetials(body);
                //       if (response.contains('Error')) {
                //         Get.rawSnackbar(
                //           message: response,
                //           backgroundColor: Colors.red,
                //         );
                //       }
                //       await getCredentials();
                //       Get.rawSnackbar(
                //         message: 'Credentials Saved Successfully!',
                //         backgroundColor: Colors.green.shade500,
                //       );
                //       // isTesting = false;
                //       setState(() {});
                //     },
                //     child: const CustomCard(child: Text('Save'))),
                // height(context),
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
