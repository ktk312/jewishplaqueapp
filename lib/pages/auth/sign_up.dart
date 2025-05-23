import 'dart:convert';

import 'package:calendar_dashboard/const.dart';
import 'package:calendar_dashboard/network/app_controller.dart';
import 'package:calendar_dashboard/pages/home/home_page.dart';
import 'package:calendar_dashboard/responsive.dart';
import 'package:calendar_dashboard/widgets/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class SignUpPage extends StatefulWidget {
  // final GlobalKey<ScaffoldState> scaffoldKey;

  const SignUpPage({
    super.key,
  });

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  void initState() {
    super.initState();
  }

  bool isValidEmail(String email) {
    final emailRegex =
        RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
    return emailRegex.hasMatch(email);
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SizedBox height(BuildContext context) => SizedBox(
          height: Responsive.isDesktop(context) ? 30 : 20,
        );

    return Scaffold(
      body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Responsive.isMobile(context) ? 15 : 18),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: Responsive.isMobile(context) ? 5 : 18,
                ),
                height(context),
                const Text(
                  'Add User',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                height(context),
                Column(
                  children: [
                    SizedBox(
                        height: 35,
                        child: _getTextField(context, nameController, 'Name')),
                    height(context),
                    SizedBox(
                        height: 35,
                        child:
                            _getTextField(context, emailController, 'Email')),
                    height(context),
                    SizedBox(
                        height: 35,
                        child: _getTextField(
                          context,
                          passController,
                          'Password',
                        )),
                    height(context),
                    height(context),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                            onTap: () async {
                              if (!isValidEmail(emailController.text)) {
                                Get.snackbar('Error',
                                    'Please enter a valid email address');
                                return;
                              } else {
                                var headers = {
                                  'Content-Type': 'application/json'
                                };
                                var request = http.Request(
                                    'POST',
                                    Uri.parse(
                                        'https://bsdjudaica.com/plaq/auth/signup.php'));
                                request.body = jsonEncode({
                                  "name": nameController.text,
                                  "email": emailController.text,
                                  "password": passController.text,
                                });
                                request.headers.addAll(headers);

                                http.StreamedResponse response =
                                    await request.send();

                                if (response.statusCode == 200) {
                                  final result =
                                      await response.stream.bytesToString();
                                  final decodedJson = jsonDecode(result);
                                  print(result);
                                  if (decodedJson['message'] ==
                                      "User registered successfully") {
                                    Get.back();
                                  }
                                } else {
                                  print(response.reasonPhrase);
                                }
                              }
                            },
                            child: const CustomCard(
                              child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 20, right: 20, top: 5, bottom: 5),
                                  child: Text(
                                    'Sign Up',
                                    style: TextStyle(
                                      fontSize: 16,
                                      // ),
                                    ),
                                  )),
                            )),
                        SizedBox(
                          width: 40,
                        ),
                        GestureDetector(
                            onTap: () async {
                              Get.back();
                            },
                            child: const CustomCard(
                              child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 20, right: 20, top: 5, bottom: 5),
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(
                                      fontSize: 16,
                                      // ),
                                    ),
                                  )),
                            )),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }

  Widget _getTextField(
      BuildContext context, TextEditingController controller, String hintText,
      {isPassword = false}) {
    return TextField(
      controller: controller,
      // keyboardType:TextInputType.number,
      obscureText: isPassword,
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
