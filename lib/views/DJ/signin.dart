import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:music/views/DJ/signup.dart';
import 'package:music/views/DJ/signup_verify.dart';

import '../../utils/app_dimen.dart';
import '../../utils/common.dart';
import '../../utils/http_service.dart';
import '../../utils/store.dart';

import 'dashboard.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final List<String> _status = [
    "Email",
     "Phone",
  ];
  String _verticalGroupValue = "Email";

  bool isObsecure = true;
  TextEditingController email = TextEditingController(text: '');
  TextEditingController forgotpasswordemail = TextEditingController(text: '');
  TextEditingController password = TextEditingController(text: '');
  TextEditingController mobile = TextEditingController(text: '');
  String countryCode = "+1";

  signin(context) async {
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
    var resp = await httpClient.post(generateUrl('login-dj'), body: {
      'email': email.text,
      'password': password.text,
      'type': 'dj',
      'device_type': type,
      'device_token': token.toString(),
    });
    if (resp.statusCode == 200) {
      final body = jsonDecode(resp.body);
      if (body['status']) {
        await Store.setToken(body['access_token']);
        await Store.setUser(body['user']);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const DJDashboard(),
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

  sendOtp() async {
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
      'phone': mobile.text,
      'type': 'dj',
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
            builder: (context) => SignUpVerify(
              phone: mobile.text,
              countryCode: countryCode,
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

  forgotPassword(String emailID) async {
    forgotpasswordemail.text = '';
    EasyLoading.show(status: 'loading...');
    var httpClient = HttpService();
    var resp = await httpClient.post(generateUrl('forgot-password'), body: {
      'email': emailID,
    });
    if (resp.statusCode == 200) {
      final body = jsonDecode(resp.body);
      print('Response: $body');
      if (body['status_flag']) {
        showToast(message: body['message']);
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
                  "Sign In as DJ",
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w300,
                      color: Color(0xFF92A4AC)),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: hDimen(20),left: 40),
                child: Theme(
                  data: ThemeData(
                    //here change to your color
                    unselectedWidgetColor: const Color(0xFF1AA8E6),
                  ),
                  child: SizedBox(),
                  // child: RadioGroup<String>.builder(
                  //   direction: Axis.horizontal,
                  //   groupValue: _verticalGroupValue,
                  //   activeColor: const Color(0xFF1AA8E6),
                  //   horizontalAlignment: MainAxisAlignment.spaceAround,
                  //   onChanged: (value) => setState(() {
                  //     _verticalGroupValue = value!;
                  //   }),
                  //   items: _status,
                  //   textStyle: const TextStyle(fontSize: 15, color: Colors.blue),
                  //   itemBuilder: (item) => RadioButtonBuilder(
                  //     item,
                  //   ),
                  // ),
                ),
              ),
              _verticalGroupValue == "Email"
                  ? SizedBox(
                      width: double.infinity,
                      height: hDimen(220),
                      child: Column(
                        children: [
                          const Padding(
                            padding:
                                EdgeInsets.only(left: 60, right: 60, top: 30),
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
                          const Padding(
                            padding:
                                EdgeInsets.only(left: 60, right: 60, top: 15),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Password *",
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
                                controller: password,
                                style: const TextStyle(color: Colors.white),
                                obscureText: isObsecure,
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
                                        'assets/images/password.png',
                                        width: 10,
                                        height: 10,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    suffixIcon: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          isObsecure = !isObsecure;
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(13),
                                        child: Image.asset(
                                          'assets/images/invisible.png',
                                          width: 10,
                                          height: 10,
                                          fit: BoxFit.contain,
                                        ),
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
                        ],
                      ),
                    ):
                  SizedBox(
                      width: double.infinity,
                      height: hDimen(180),
                      child: Column(
                        children: [
                          const Padding(
                            padding:
                                EdgeInsets.only(left: 60, right: 60, top: 40),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Mobile Number *",
                                style: TextStyle(
                                    color: Color(0xFF92A4AC),
                                    fontFamily: "Rajdhani",
                                    fontSize: 16),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 10, left: 55, right: 55),
                            child: IntlPhoneField(
                              controller: mobile,
                              dropdownIcon: const Icon(
                                Icons.arrow_drop_down,
                                color: Color(0xFF1AA8E6),
                              ),
                              dropdownTextStyle: const TextStyle(
                                  color: Colors.white, fontFamily: "Rajdhani"),
                              style: const TextStyle(
                                  color: Colors.white, fontFamily: "Rajdhani"),
                              decoration: const InputDecoration(
                                hintText: 'Phone Number',
                                hintStyle: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "Rajdhani"),
                                helperStyle: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "Rajdhani"),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xFF1AA8E6)),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xFF1AA8E6)),
                                ),
                                // border: OutlineInputBorder(
                                //   // borderSide: BorderSide(color: Colors.transparent,width: 0),
                                // ),
                              ),
                              onChanged: (phone) {
                                countryCode = phone.countryCode;
                              },
                              onCountryChanged: (country) {
                                countryCode = country.dialCode;
                              },
                            ),
                          ),
                          const Padding(
                            padding:
                                EdgeInsets.only(left: 60, right: 60, top: 10),
                            child: Text(
                              "4 digit verification code will be sent",
                              style: TextStyle(
                                  color: Color(0xFF92A4AC),
                                  fontFamily: "Rajdhani",
                                  fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: hDimen(20)),
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              backgroundColor: Colors.black.withOpacity(0.8),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      10.0)), //this right here
                              child: Container(
                                height: hDimen(330),
                                decoration: BoxDecoration(
                                    color: const Color(0xFF1E2126),
                                    borderRadius: BorderRadius.circular(10.0)),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            "Forgot Password",
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFF92A4AC)),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            child: const SizedBox(
                                              width: 35,
                                              height: 35,
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(0)),
                                                child: Image(
                                                  image: AssetImage(
                                                      "assets/images/cross.png"),
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: hDimen(00), top: hDimen(25)),
                                        child: const Text(
                                          "Please type in the registered email address",
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white),
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(
                                            left: 0, right: 0, top: 25),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "Email ID",
                                            style: TextStyle(
                                                color: Color(0xFF92A4AC),
                                                fontFamily: "Rajdhani",
                                                fontSize: 16),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 0, right: 0),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: TextField(
                                            controller: forgotpasswordemail,
                                            style:
                                                const TextStyle(color: Colors.white),
                                            decoration: InputDecoration(
                                                enabledBorder:
                                                    const UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Color(0xFF1AA8E6)),
                                                ),
                                                focusedBorder:
                                                    const UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Color(0xFF1AA8E6)),
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
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: hDimen(00), top: hDimen(25)),
                                        child: const Text(
                                          "The link to reset the password will be sent to your mail address",
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w300,
                                              color: Colors.white),
                                        ),
                                      ),
                                      Center(
                                        child: Padding(
                                          padding:
                                              EdgeInsets.only(top: hDimen(20)),
                                          child: GestureDetector(
                                            onTap: () {
                                              if (forgotpasswordemail
                                                      .text.isEmpty ||
                                                  RegExp(r"\s").hasMatch(
                                                      forgotpasswordemail
                                                          .text) ||
                                                  !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                                      .hasMatch(
                                                          forgotpasswordemail
                                                              .text)) {
                                                showToast(
                                                    message:
                                                        "Please enter the valid email address");
                                              } else {
                                                print('Email: ${forgotpasswordemail.text}');
                                                forgotPassword(forgotpasswordemail.text);
                                                Navigator.pop(context);
                                              }
                                            },
                                            child: Container(
                                              width: hDimen(100),
                                              height: hDimen(40),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF1AA8E6),
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                              ),
                                              child: const Center(
                                                child: Text(
                                                  "SUBMIT",
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black),
                                                ),
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
                          });
                    },
                    child: const Text(
                      "Forgot Password",
                      style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF1AA8E6),
                          fontFamily: "Rajdhani",
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),

              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: GestureDetector(
                    onTap: () {
                      _verticalGroupValue == "Email"
                          ? emailValidation()
                          : mobileValidation();
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
                          "SIGN IN",
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
                        MaterialPageRoute(builder: (context) => const SignUp()),
                      );
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

  void emailValidation() {
    if (email.text.isEmpty && password.text.isEmpty) {
      showToast(message: "Email and Password cannot be blank");
    } else if (email.text.isEmpty ||
        RegExp(r"\s").hasMatch(email.text) ||
        !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email.text)) {
      showToast(message: "Please enter a valid email id");
    } else if (password.text.isEmpty
        // || RegExp(r"\s").hasMatch(password.text) || !RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$').hasMatch(password.text)
        ) {
      showToast(message: "Please enter a password");
    } else {
      signin(context);
    }
  }

  void mobileValidation() {
    if (mobile.text.isEmpty || RegExp(r"\s").hasMatch(mobile.text)) {
      showToast(message: "Please enter a valid mobile number");
    } else {
      sendOtp();
    }
  }
}
