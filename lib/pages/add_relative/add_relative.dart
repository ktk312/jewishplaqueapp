import 'package:calendar_dashboard/responsive.dart';
import 'package:calendar_dashboard/const.dart';
import 'package:calendar_dashboard/network/app_controller.dart';
import 'package:calendar_dashboard/network/network_calls.dart';
import 'package:calendar_dashboard/widgets/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddRelative extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final String plaqueId;

  const AddRelative(
      {super.key, required this.plaqueId, required this.scaffoldKey});

  @override
  State<AddRelative> createState() => _AddRelativeState();
}

class _AddRelativeState extends State<AddRelative> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  final myAppController = Get.find<MyAppController>();
  @override
  void initState() {
    super.initState();
  }

  bool isSms = true;

  @override
  Widget build(BuildContext context) {
    SizedBox height(BuildContext context) => SizedBox(
          height: Responsive.isDesktop(context) ? 30 : 20,
        );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Relative',
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
                        context, fullNameController, 'Full Name',
                        keyboardType: TextInputType.name)),
                height(context),
                SizedBox(
                    height: 35,
                    child: _getTextField(context, phoneController, 'Phone',
                        keyboardType: TextInputType.phone)),
                height(context),
                SizedBox(
                    height: 35,
                    child: Row(
                      children: [
                        Text(
                          'Whatsapp',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Switch(
                            value: isSms,
                            onChanged: (val) {
                              isSms = val;
                              setState(() {});
                            }),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          'SMS',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ],
                    )),
                height(context),
                GestureDetector(
                    onTap: () async {
                      var body = {
                        'fullname': fullNameController.text,
                        'relativeid': widget.plaqueId,
                        'email': 'test@gmail.com',
                        'number': phoneController.text,
                        'isSms': isSms,
                      };

                      final response = await NetworkCalls().postRelative(body);
                      if (response.contains('Error:')) {
                        Get.rawSnackbar(
                            message: response,
                            backgroundColor: Colors.red.shade400);
                      } else {
                        Get.back();
                        myAppController.getPlaques();
                        Get.rawSnackbar(
                          message: 'Relative added Successfully!',
                          backgroundColor: Colors.green.shade500,
                        );
                      }
                    },
                    child: const CustomCard(child: Text('Add Relative')))
              ],
            ),
          ))),
    );
  }

  Widget _getTextField(
      BuildContext context, TextEditingController controller, String hintText,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
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
