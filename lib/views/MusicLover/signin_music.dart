import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:music/utils/common.dart';
import 'package:music/utils/http_service.dart';
import 'package:music/views/MusicLover/signup_music.dart';
import 'package:music/views/MusicLover/signup_music_verify.dart';

import '../../utils/app_dimen.dart';

class SignInMusic extends StatefulWidget {
  const SignInMusic({Key? key}) : super(key: key);

  @override
  _SignInMusicState createState() => _SignInMusicState();
}

class _SignInMusicState extends State<SignInMusic> {
  TextEditingController mobile = TextEditingController(text: '');
  String countryCode = "+1";
  bool isObsecure = true;
  TextEditingController email = TextEditingController(text: '');
  TextEditingController password = TextEditingController(text: '');

  login() async {
    EasyLoading.show(status: 'loading...');
    var httpClient = HttpService();
    var type = '';
    if (Platform.isIOS) {
      type = 'I';
    } else if (Platform.isAndroid) {
      type = 'A';
    }
    final FirebaseMessaging fcm = FirebaseMessaging.instance;
    final token = await fcm.getToken();
    var resp = await httpClient.post(generateUrl('sendotp'), body: {
      'country_code': countryCode,
      'email': email.text,
      'type': 'user',
      'device_type': type,
      'device_token': token.toString(),
    });
    if (resp.statusCode == 200) {
      final body = jsonDecode(resp.body);
      print(body);
      if (body['status']) {
        //showToast(message: "Your OTP is " + body['code'].toString());
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SignUpMusicVerify(
              phone: email.text,
              countryCode: countryCode,
              referedFrom: 'signin',
            ),
          ),
        );
      } else {
        showToast(message: body['message']);
      }
    } else {
      showToast(message: 'Oops! Something went wrong.');
    }
    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/splash_background.png'),
                fit: BoxFit.cover)),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: hDimen(50),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const SizedBox(
                        width: 35,
                        height: 35,
                        child: Image(
                          image: AssetImage("assets/images/back_btn.png"),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: EdgeInsets.only(left: hDimen(10)),
                      child: const Text(
                        'WELCOME TO',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Rajdhani"),
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
              Center(
                child: SizedBox(
                  height: hDimen(75),
                  width: hDimen(150),
                  child: Image.asset(
                    'assets/images/appicon.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: hDimen(20), top: hDimen(5)),
                child: const Text(
                  "Sign In as Music Lover",
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w300,
                      color: Color(0xFF92A4AC)),
                ),
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: hDimen(20)),
                  child: Container(
                    height: hDimen(100),
                    width: hDimen(100),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(color: const Color(0xFF1AA8E6))),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: const Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Image(
                          image: AssetImage("assets/images/mobile.png"),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // const Padding(
              //   padding: EdgeInsets.only(left: 60, right: 60, top: 40),
              //   child: Align(
              //     alignment: Alignment.centerLeft,
              //     child: Text(
              //       "Mobile Number *",
              //       style: TextStyle(
              //           color: Color(0xFF92A4AC),
              //           fontFamily: "Rajdhani",
              //           fontSize: 16),
              //     ),
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.only(top: 10, left: 55, right: 55),
              //   child: IntlPhoneField(
              //     controller: mobile,
              //     dropdownIcon: const Icon(
              //       Icons.arrow_drop_down,
              //       color: Color(0xFF1AA8E6),
              //     ),
              //     dropdownTextStyle:
              //         const TextStyle(color: Colors.white, fontFamily: "Rajdhani"),
              //     style: const TextStyle(color: Colors.white, fontFamily: "Rajdhani"),
              //     decoration: const InputDecoration(
              //       hintText: 'Phone Number',
              //       hintStyle:
              //           TextStyle(color: Colors.white, fontFamily: "Rajdhani"),
              //       helperStyle:
              //           TextStyle(color: Colors.white, fontFamily: "Rajdhani"),
              //       enabledBorder: UnderlineInputBorder(
              //         borderSide: BorderSide(color: Color(0xFF1AA8E6)),
              //       ),
              //       focusedBorder: UnderlineInputBorder(
              //         borderSide: BorderSide(color: Color(0xFF1AA8E6)),
              //       ),
              //       // border: OutlineInputBorder(
              //       //   // borderSide: BorderSide(color: Colors.transparent,width: 0),
              //       // ),
              //     ),
              //     onChanged: (phone) {
              //       countryCode = phone.countryCode;
              //     },
              //     onCountryChanged: (country) {
              //       countryCode = country.dialCode;
              //     },
              //   ),
              // ),
              const Padding(
                padding:
                EdgeInsets.only(left: 60, right: 60, top: 60),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Email ID *",
                    style: TextStyle(
                        color: Color(0xFF92A4AC),
                        fontFamily: "Rajdhani",
                        fontSize: 16),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 60, right: 60),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TextField(
                    controller: email,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        enabledBorder: const UnderlineInputBorder(
                          borderSide:
                          BorderSide(color: Color(0xFF1AA8E6)),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide:
                          BorderSide(color: Color(0xFF1AA8E6)),
                        ),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(13),
                          child: Image.asset(
                            'assets/images/email.png',
                            width: 10,
                            height: 10,
                            fit: BoxFit.contain,
                          ),
                        ),
                        hintText: "Type in",
                        hintStyle: const TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontFamily: "Rajdhani")),
                  ),
                ),
              ),

              // const Padding(
              //   padding:
              //   EdgeInsets.only(left: 60, right: 60, top: 15),
              //   child: Align(
              //     alignment: Alignment.centerLeft,
              //     child: Text(
              //       "Password *",
              //       style: TextStyle(
              //           color: Color(0xFF92A4AC),
              //           fontFamily: "Rajdhani",
              //           fontSize: 16),
              //     ),
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.only(left: 60, right: 60),
              //   child: Align(
              //     alignment: Alignment.centerLeft,
              //     child: TextField(
              //       controller: password,
              //       style: const TextStyle(color: Colors.white),
              //       obscureText: isObsecure,
              //       decoration: InputDecoration(
              //           enabledBorder: const UnderlineInputBorder(
              //             borderSide:
              //             BorderSide(color: Color(0xFF1AA8E6)),
              //           ),
              //           focusedBorder: const UnderlineInputBorder(
              //             borderSide:
              //             BorderSide(color: Color(0xFF1AA8E6)),
              //           ),
              //           prefixIcon: Padding(
              //             padding: const EdgeInsets.all(13),
              //             child: Image.asset(
              //               'assets/images/password.png',
              //               width: 10,
              //               height: 10,
              //               fit: BoxFit.contain,
              //             ),
              //           ),
              //           suffixIcon: GestureDetector(
              //             onTap: () {
              //               setState(() {
              //                 isObsecure = !isObsecure;
              //               });
              //             },
              //             child: Padding(
              //               padding: const EdgeInsets.all(13),
              //               child: Image.asset(
              //                 'assets/images/invisible.png',
              //                 width: 10,
              //                 height: 10,
              //                 fit: BoxFit.contain,
              //               ),
              //             ),
              //           ),
              //           hintText: "Type in",
              //           hintStyle: const TextStyle(
              //               fontSize: 15,
              //               color: Colors.white,
              //               fontFamily: "Rajdhani")),
              //     ),
              //   ),
              // ),

              const Padding(
                padding: EdgeInsets.only(left: 60, right: 60, top: 10),
                child: Text(
                  "4 digit verification code will be sent",
                  style: TextStyle(
                      color: Color(0xFF92A4AC),
                      fontFamily: "Rajdhani",
                      fontSize: 16),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: GestureDetector(
                    onTap: () {
                      if (email.text.isEmpty) {
                        showToast(message: "Email cannot be blank");
                      } else if (email.text.isEmpty ||
                          RegExp(r"\s").hasMatch(email.text) ||
                          !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email.text)) {
                        showToast(message: "Please enter a valid email id");
                      } else {
                        login();
                      }
                    },
                    child: Container(
                      width: hDimen(120),
                      height: hDimen(45),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1AA8E6),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Center(
                        child: Text(
                          "VERIFY",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignUpMusic()),
                      );

                      // Close the keyboard
                      FocusScope.of(context).unfocus();
                    },
                    child: RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: "NEW USER? ",
                            style: TextStyle(
                                color: const Color(0xFF92A4AC),
                                fontSize: hDimen(17),
                                fontFamily: "Rajdhani"),
                          ),
                          TextSpan(
                            text: 'SIGN UP',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF1AA8E6),
                                fontSize: hDimen(17),
                                fontFamily: "Rajdhani"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



}
