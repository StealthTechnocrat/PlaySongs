import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:music/utils/common.dart';
import 'package:flutter/gestures.dart';
import 'package:music/utils/store.dart';
import './dashboard.dart';
import '../../utils/app_dimen.dart';
import '../../utils/http_service.dart';

class SignUpMusicVerify extends StatefulWidget {
  var phone;

  var countryCode;

  var referedFrom;

  SignUpMusicVerify({Key? key, this.phone, this.countryCode, this.referedFrom})
      : super(key: key);

  resend() async {
    EasyLoading.show(status: 'loading...');
    var httpClient = HttpService();
    var resp = await httpClient.post(generateUrl('sendotp'), body: {
      'country_code': countryCode,
      'email': phone,
      'type': 'user',
    });
    if (resp.statusCode == 200) {
      final body = jsonDecode(resp.body);
      print(body);
      if (body['status']) {
        //showToast(message: "Your OTP is " + body['code'].toString());
      } else {
        showToast(message: body['message']);
      }
    } else {
      showToast(message: 'Oops! Something went wrong.');
    }
    EasyLoading.dismiss();
  }

  verifyOtp(otp, context) async {
    EasyLoading.show(status: 'loading...');
    var httpClient = HttpService();
    var resp = await httpClient.post(generateUrl('verifyotp'), body: {
      'country_code': countryCode,
      'email': phone,
      'type': 'user',
      'otp': otp,
    });
    if (resp.statusCode == 200) {
      final body = jsonDecode(resp.body);
      if (body['status']) {
        await Store.setToken(body['access_token']);
        print(body['access_token']);
        await Store.setUser(body['user']);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const Dashboard(),
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
  _SignUpMusicVerifyState createState() => _SignUpMusicVerifyState();
}

class _SignUpMusicVerifyState extends State<SignUpMusicVerify> {
  String otpField = '';

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
              Container(
                  padding: EdgeInsets.only(
                    left: hDimen(20),
                    right: hDimen(20),
                  ),
                  child: const LinearProgressIndicator(
                    minHeight: 2,
                    color: Color(0xFFFBBB16),
                    backgroundColor: Color(0xFF5D4E76),
                    value: 0.75,
                  )),
              Padding(
                padding: EdgeInsets.only(left: hDimen(20), top: hDimen(5)),
                child: Text(
                  widget.referedFrom == 'signup'
                      ? "Sign Up as Music Lover"
                      : "Sign In as Music Lover",
                  style: const TextStyle(
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
                          image: AssetImage("assets/images/signup_verify.png"),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: hDimen(30)),
                  child: const Text(
                    "Verification code has been sent by email to",
                    style: TextStyle(
                        color: Color(0xFF92A4AC),
                        fontFamily: "Rajdhani",
                        fontSize: 16),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: hDimen(10)),
                  child: Text(
                    '${widget.phone}',
                    style: const TextStyle(
                        color: Colors.white,
                        fontFamily: "Rajdhani",
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 60, right: 60, top: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Enter Code",
                    style: TextStyle(
                        color: Color(0xFF92A4AC),
                        fontFamily: "Rajdhani",
                        fontSize: 16),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 60,
                    right: 60,
                  ),
                  child: OtpTextField(
                    textStyle: const TextStyle(color: Colors.white),
                    numberOfFields: 4,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    borderColor: const Color(0xFF1AA8E6),
                    enabledBorderColor: const Color(0xFF1AA8E6),
                    focusedBorderColor: const Color(0xFF1AA8E6),
                    showFieldAsBox: false,
                    fieldWidth: 50,
                    borderWidth: 1.0,
                    //runs when a code is typed in
                    onCodeChanged: (String code) {
                      //handle validation or checks here if necessary
                    },
                    //runs when every textfield is filled
                    onSubmit: (String verificationCode) {
                      otpField = verificationCode;
                    },
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: GestureDetector(
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => SignUp()),
                      // );
                    },
                    child: RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: "Didn’t receive a code? ",
                            style: TextStyle(
                                color: const Color(0xFF92A4AC),
                                fontSize: hDimen(17),
                                fontFamily: "Rajdhani"),
                          ),
                          TextSpan(
                            text: 'RESEND',
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => widget.resend(),
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
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: GestureDetector(
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => SignUp()),
                      // );
                    },
                    child: widget.referedFrom == 'signin'
                        ? RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text: "Not the correct Email? ",
                                  style: TextStyle(
                                      color: const Color(0xFF92A4AC),
                                      fontSize: hDimen(17),
                                      fontFamily: "Rajdhani"),
                                ),
                                TextSpan(
                                  text: 'CHANGE',
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => Navigator.of(context).pop(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF1AA8E6),
                                      fontSize: hDimen(17),
                                      fontFamily: "Rajdhani"),
                                ),
                              ],
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: GestureDetector(
                    onTap: () {
                      if (otpField.length != 4) {
                        showToast(message: "Please enter the 4 digit otp");
                      } else {
                        widget.verifyOtp(otpField, context);
                      }
                      // Navigator.of(context).push(
                      //   MaterialPageRoute(
                      //     builder: (context) => SignUpVerify(),
                      //   ),
                      // );
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
                          "SUBMIT",
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
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => SignUp()),
                      // );
                    },
                    child: widget.referedFrom == 'signup'
                        ? RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text: "EXISTING USER? ",
                                  style: TextStyle(
                                      color: const Color(0xFF92A4AC),
                                      fontSize: hDimen(17),
                                      fontFamily: "Rajdhani"),
                                ),
                                TextSpan(
                                  text: 'SIGN IN',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF1AA8E6),
                                      fontSize: hDimen(17),
                                      fontFamily: "Rajdhani"),
                                ),
                              ],
                            ),
                          )
                        : const SizedBox.shrink(),
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
