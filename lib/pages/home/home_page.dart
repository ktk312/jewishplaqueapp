import 'dart:convert';

import 'package:calendar_dashboard/network/app_controller.dart';
import 'package:calendar_dashboard/network/mqtt_func.dart';
import 'package:calendar_dashboard/pages/add_plaque/add_plaque.dart';
import 'package:calendar_dashboard/pages/admin/admin.dart';
import 'package:calendar_dashboard/pages/home/plaque_detail_page.dart';
import 'package:calendar_dashboard/pages/message_page.dart';
import 'package:calendar_dashboard/pages/print_page.dart';
import 'package:calendar_dashboard/widgets/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:calendar_dashboard/responsive.dart';
import 'package:get/get.dart';
import 'package:kosher_dart/kosher_dart.dart';

class HomePage extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const HomePage({super.key, required this.scaffoldKey});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final appController = Get.find<MyAppController>();
  MQTTClientWrapper newClient = MQTTClientWrapper();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appController.getPlaques();
    hebrewDateFormatter.hebrewFormat = true;
  }

  connectMqttAndSendMessage() async {
    final response = await appController.getCredentials();
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
          .then((value) => newClient.publishMessage("reset"));
    }
  }

  HebrewDateFormatter hebrewDateFormatter = HebrewDateFormatter();
  @override
  Widget build(BuildContext context) {
    SizedBox height(BuildContext context) => SizedBox(
          height: Responsive.isDesktop(context) ? 30 : 20,
        );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Plaque List',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        // centerTitle: true,
        actions: [
          appController.userEmail.value == 'admin@email.com'
              ? TextButton(
                  onPressed: () {
                    Get.to(() => const AdminPage());
                  },
                  child: const Text(
                    'Admin',
                  ),
                )
              : Container(),
          // const SizedBox(
          //   width: 20,
          // ),
          // TextButton(
          //   onPressed: () {
          //     connectMqttAndSendMessage();
          //   },
          //   child: const Text(
          //     'Sync',
          //   ),
          // ),
          const SizedBox(
            width: 20,
          ),
          TextButton(
            onPressed: () {
              Get.to(() => PrintPage(scaffoldKey: widget.scaffoldKey));
            },
            child: const Text(
              'Print',
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          TextButton(
            onPressed: () {
              Get.to(() => MessagePage(scaffoldKey: widget.scaffoldKey));
            },
            child: const Text(
              'Setting',
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          IconButton(
              onPressed: () async {
                await Get.to(() => AddPlaque(scaffoldKey: widget.scaffoldKey));
                appController.getPlaques();
              },
              icon: const Icon(Icons.add)),
          const SizedBox(
            width: 20,
          )
        ],
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
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'Male List',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      'Female List',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: Get.size.width / 2.2,
                      child: PlaqueListWidget(
                          appController: appController,
                          widget: widget,
                          isMale: true,
                          hebrewDateFormatter: hebrewDateFormatter),
                    ),
                    SizedBox(
                      width: Get.size.width / 2.2,
                      child: PlaqueListWidget(
                          appController: appController,
                          widget: widget,
                          isMale: false,
                          hebrewDateFormatter: hebrewDateFormatter),
                    ),
                  ],
                ),
              ],
            ),
          ))),
    );
  }
}

class PlaqueListWidget extends StatelessWidget {
  const PlaqueListWidget({
    super.key,
    required this.appController,
    required this.widget,
    required this.hebrewDateFormatter,
    required this.isMale,
  });

  final MyAppController appController;
  final HomePage widget;
  final HebrewDateFormatter hebrewDateFormatter;
  final bool isMale;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView.builder(
        shrinkWrap: true,
        itemCount: isMale
            ? appController.maleList.length
            : appController.femaleList.length,
        itemBuilder: (context, index) => Container(
          margin: const EdgeInsets.only(top: 5, bottom: 5),
          child: CustomCard(
              child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 200,
              minWidth: 100,
              maxHeight: 80,
              minHeight: 40,
            ),
            child: GestureDetector(
              onTap: () {
                Get.to(() => PlaqueDetailPage(
                    index: index,
                    isMale: isMale,
                    scaffoldKey: widget.scaffoldKey));
              },
              child: ListTile(
                trailing: IconButton(
                  onPressed: () async {
                    Get.dialog(AlertDialog(
                      backgroundColor: Color((0xFF171821)),
                      icon: Text(
                          'Are you sure you want to delete ${isMale ? appController.maleList[index].hebruname : appController.femaleList[index].hebruname}?'),
                      actions: [
                        OutlinedButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: const Text(
                              'Cancel',
                              style: TextStyle(color: Colors.white),
                            )),
                        OutlinedButton(
                            style: const ButtonStyle(
                                side: WidgetStatePropertyAll(
                                    BorderSide(color: Colors.red))),
                            onPressed: () async {
                              Get.back();
                              String id = isMale
                                  ? appController.maleList[index].plaqueId
                                  : appController.femaleList[index].plaqueId;
                              appController.deletePlaque(id);
                            },
                            child: const Text(
                              'Delete',
                              style: TextStyle(color: Colors.white),
                            )),
                      ],
                    ));
                    // String id = isMale
                    //     ? appController.maleList[index].plaqueId
                    //     : appController.femaleList[index].plaqueId;
                    // await appController.deletePlaque(id);
                  },
                  icon: const Icon(Icons.delete),
                  color: Colors.red,
                ),
                title: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isMale
                              ? appController.maleList[index].hebruname
                              : appController.femaleList[index].hebruname,
                          style: const TextStyle(
                            fontFamily: 'Alef',
                          ),
                        ),
                        Text(
                          "Led: ${isMale ? appController.maleList[index].led : appController.femaleList[index].led}",
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isMale
                              ? appController.maleList[index].plaqueFullname
                              : appController.femaleList[index].plaqueFullname,
                          style: const TextStyle(
                            fontFamily: 'Alef',
                          ),
                        ),
                        Container(),
                        // Text(
                        //   "Led: ${isMale ? appController.maleList[index].led : appController.femaleList[index].led}",
                        //   style: const TextStyle(fontSize: 12),
                        // ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _getFormattedHebrewDate(
                            isMale
                                ? appController.maleList[index].predate
                                : appController.femaleList[index].predate,
                          ),
                          style: const TextStyle(
                            fontFamily: 'Alef',
                          ),
                        ),
                        Text(isMale
                            ? appController.maleList[index].gender.toUpperCase()
                            : appController.femaleList[index].gender
                                .toUpperCase()),
                      ],
                    ),
                  ],
                ),
                // subtitle: Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Text(
                //       hebrewDateFormatter.format(JewishDate.fromDateTime(
                //           DateTime.tryParse(isMale
                //               ? appController.maleList[index].dod
                //               : appController.femaleList[index].dod)!)),
                //       style: const TextStyle(
                //         fontFamily: 'Alef',
                //       ),
                //     ),
                //     Text(isMale
                //         ? appController.maleList[index].gender.toUpperCase()
                //         : appController.femaleList[index].gender.toUpperCase()),
                //   ],
                // ),
              ),
            ),
          )),
        ),
      ),
    );
  }

  String _getFormattedHebrewDate(String? predate) {
    if (predate == null || predate.isEmpty) {
      return ''; // or return 'N/A', 'Unknown', etc.
    }

    final parsedDate = DateTime.tryParse(predate);
    if (parsedDate == null) {
      return ''; // or log an error if needed
    }

    final jewishDate = JewishDate.fromDateTime(parsedDate);
    return hebrewDateFormatter.format(jewishDate);
  }
}
