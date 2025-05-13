import 'dart:convert';

import 'package:calendar_dashboard/const.dart';
import 'package:calendar_dashboard/model/user_model.dart';
import 'package:calendar_dashboard/network/app_controller.dart';
import 'package:calendar_dashboard/network/network_calls.dart';
import 'package:calendar_dashboard/pages/auth/sign_up.dart';

import 'package:calendar_dashboard/widgets/custom_card.dart';

import 'package:flutter/material.dart';
import 'package:calendar_dashboard/responsive.dart';
import 'package:get/get.dart';
import 'package:kosher_dart/kosher_dart.dart';
import 'package:http/http.dart' as http;

class AdminPage extends StatefulWidget {
  const AdminPage({
    super.key,
  });

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final appController = Get.find<MyAppController>();

  final isLoadingUser = false.obs;
  final isLoadingorEmpty = false.obs;

  String returnMessage = '';

  List<Data> userData = [];

  int selectedUserId = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setup();
  }

  setup() async {
    await getUsers();
  }

  getUsers() async {
    List<String> returnList = [];
    var headersList = {
      'Accept': '*/*',
    };
    var url = Uri.parse('https://bsdjudaica.com/plaq/admin/getusers.php');

    var req = http.Request('GET', url);
    req.headers.addAll(headersList);

    var res = await req.send();
    final resBody = await res.stream.bytesToString();

    if (res.statusCode >= 200 && res.statusCode < 300) {
      print(resBody);
      final userModel = userModelFromJson(resBody);
      userData = userModel.data;
      await getAllLeds(selectedUserId);
      setState(() {});
    } else {
      print(res.reasonPhrase);
    }
  }

  getAllLeds(int userId) async {
    var headersList = {'Accept': '*/*', 'Content-Type': 'application/json'};
    var url = Uri.parse('https://bsdjudaica.com/plaq/admin/getall_leds.php');

    var body = {"userId": userId};

    var req = http.Request('POST', url);
    req.headers.addAll(headersList);
    req.body = json.encode(body);

    var res = await req.send();
    final resBody = await res.stream.bytesToString();

    if (res.statusCode >= 200 && res.statusCode < 300) {
      print(resBody);

      final decodedJson = jsonDecode(resBody);
      if (decodedJson.keys.contains('message')) {
        returnMessage = decodedJson['message'];
      } else {
        returnMessage = '';
        final ledList = decodedJson['led_numbers'];

        print("Led Numbers : $ledList");
        allLedsList.clear();
        for (var led in ledList) {
          allLedsList.add(led.toString());
        }
      }
      setState(() {});
    } else {
      print(res.reasonPhrase);
    }
  }

  var allLedsList = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];

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
        actions: [
          GestureDetector(
              onTap: () async {
                //post led call
                await Get.to(() => SignUpPage());
                getUsers();
              },
              child: const CustomCard(child: Text('Add User'))),
          SizedBox(
            width: 40,
          )
        ],
        // centerTitle: true,
      ),
      body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: isLoadingorEmpty.value
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : userData.isEmpty
                  ? Center(child: Text('No User Data'))
                  : SingleChildScrollView(
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
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount: userData.length,
                                            itemBuilder: (context, index) {
                                              return GestureDetector(
                                                onTap: () {
                                                  print('pressed');
                                                  isLoadingUser.value = true;
                                                  selectedUserId = int.parse(
                                                      userData[index].id);

                                                  setState(() {});

                                                  getAllLeds(selectedUserId);

                                                  Future.delayed(
                                                      Duration(seconds: 2), () {
                                                    isLoadingUser.value = false;
                                                  });
                                                },
                                                child: Container(
                                                  margin: const EdgeInsets.only(
                                                    bottom: 10,
                                                  ),
                                                  child: CustomCard(
                                                    child: Text(
                                                        userData[index].name),
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
                              Obx(
                                () => isLoadingUser.value
                                    ? Expanded(
                                        flex: 4,
                                        child: Center(
                                            child:
                                                const CircularProgressIndicator()))
                                    : Expanded(
                                        flex: 4,
                                        child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
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
                                                      child: _getTextField(
                                                          context,
                                                          addLedController,
                                                          'Enter Led')),
                                                  height(context),
                                                  const Text(
                                                      'Format Led: M1_01 for Master and N1_01 for Node'),
                                                  height(context),
                                                  GestureDetector(
                                                      onTap: () async {
                                                        //post led call

                                                        var headersList = {
                                                          'Accept': '*/*',
                                                          'Content-Type':
                                                              'application/json'
                                                        };
                                                        var url = Uri.parse(
                                                            'https://bsdjudaica.com/plaq/admin/postleds.php');

                                                        var body = {
                                                          "userId":
                                                              selectedUserId,
                                                          "led_number":
                                                              addLedController
                                                                  .text
                                                        };

                                                        var req = http.Request(
                                                            'POST', url);
                                                        req.headers.addAll(
                                                            headersList);
                                                        req.body =
                                                            json.encode(body);

                                                        var res =
                                                            await req.send();
                                                        final resBody = await res
                                                            .stream
                                                            .bytesToString();
                                                        final decodedJson =
                                                            jsonDecode(resBody);

                                                        if (decodedJson.keys
                                                            .contains(
                                                                'error')) {
                                                          Get.rawSnackbar(
                                                              message:
                                                                  decodedJson[
                                                                      'error'],
                                                              backgroundColor:
                                                                  Colors.red);
                                                        } else {
                                                          Get.rawSnackbar(
                                                              message:
                                                                  'Led Added Successfully',
                                                              backgroundColor:
                                                                  Colors.green);
                                                        }
                                                        getAllLeds(
                                                            selectedUserId);

                                                        // var body = {
                                                        //   "led_number":
                                                        //       addLedController
                                                        //           .text,
                                                        //   "user_id": '1',
                                                        // };
                                                        // print(body);

                                                        // final response =
                                                        //     await NetworkCalls()
                                                        //         .postLed(body);
                                                        // if (response.contains(
                                                        //     'Error')) {
                                                        //   Get.rawSnackbar(
                                                        //     message: response,
                                                        //     backgroundColor:
                                                        //         Colors.red,
                                                        //   );
                                                        // }
                                                        // Get.rawSnackbar(
                                                        //   message:
                                                        //       'Message Saved Successfully!',
                                                        //   backgroundColor:
                                                        //       Colors.green
                                                        //           .shade500,
                                                        // );
                                                        // getAllLeds(
                                                        //     selectedUserId);
                                                      },
                                                      child: const CustomCard(
                                                          child: Text(
                                                              'Save Led'))),
                                                  height(context),
                                                  returnMessage != ''
                                                      ? Text(returnMessage)
                                                      : ListView.builder(
                                                          shrinkWrap: true,
                                                          physics:
                                                              const NeverScrollableScrollPhysics(),
                                                          itemCount: allLedsList
                                                              .length,
                                                          itemBuilder:
                                                              (context, index) {
                                                            return GestureDetector(
                                                              onTap: () {},
                                                              child: Container(
                                                                margin:
                                                                    const EdgeInsets
                                                                        .only(
                                                                  bottom: 10,
                                                                ),
                                                                child:
                                                                    CustomCard(
                                                                  child: Text(
                                                                      allLedsList[
                                                                          index]),
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                ],
                                              ),
                                            )),
                                      ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ))),
    );
  }
}
