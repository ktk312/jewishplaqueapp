import 'dart:convert';

import 'package:calendar_dashboard/const.dart';
import 'package:calendar_dashboard/network/app_controller.dart';
import 'package:calendar_dashboard/pages/admin/admin.dart';
import 'package:calendar_dashboard/pages/home/home_page.dart';
import 'package:calendar_dashboard/responsive.dart';
import 'package:calendar_dashboard/widgets/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const LoginPage({super.key, required this.scaffoldKey});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
  }

  bool isValidEmail(String email) {
    final emailRegex = RegExp(
        r"^(?!\.)[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}(?<!\.)$");
    return emailRegex.hasMatch(email);
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

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
                const Text(
                  'Welcome Back!',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                height(context),
                const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                height(context),
                Column(
                  children: [
                    SizedBox(
                        height: 35,
                        child:
                            _getTextField(context, emailController, 'Email')),
                    height(context),
                    SizedBox(
                        height: 35,
                        child: _getTextField(
                            context, passController, 'Password',
                            isPassword: true)),
                    height(context),
                    height(context),
                    GestureDetector(
                        onTap: () async {
                          print('Login');
                          if (!isValidEmail(emailController.text)) {
                            print('Login error');
                            Get.rawSnackbar(
                                message: "Error: Invalid Email",
                                backgroundColor: Colors.red);
                          } else {
                            print('Login else');
                            var headers = {'Content-Type': 'application/json'};
                            var request = http.Request(
                                'POST',
                                Uri.parse(
                                    'https://bsdjudaica.com/plaq/auth/login.php'));
                            request.body = jsonEncode({
                              "email": emailController.text,
                              "password": passController.text,
                            });
                            request.headers.addAll(headers);

                            http.StreamedResponse response =
                                await request.send();

                            if (response.statusCode == 200) {
                              final result =
                                  await response.stream.bytesToString();
                              Map<String, dynamic> decodedJson =
                                  jsonDecode(result);
                              if (decodedJson.keys.contains('error')) {
                                Get.rawSnackbar(
                                    message: "Error: Invalid Credentials",
                                    backgroundColor: Colors.red);
                              } else {
                                print(result);
                                print(decodedJson['token']);

                                Get.find<MyAppController>().token.value =
                                    decodedJson['token'];
                                Get.find<MyAppController>().userId.value =
                                    decodedJson['id'];
                                Get.find<MyAppController>().userEmail.value =
                                    emailController.text;
                                Get.find<MyAppController>().isLoggedIn.value =
                                    true;

                                if (emailController.text == 'admin@email.com') {
                                  Get.offAll(() => AdminPage());
                                } else {
                                  Get.offAll(() => HomePage(
                                      scaffoldKey: widget.scaffoldKey));
                                }
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
                                'Login',
                                style: TextStyle(
                                  fontSize: 16,
                                  // ),
                                ),
                              )),
                        )),
                  ],
                ),
                height(context),
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
