import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:music/views/DJ/dashboard.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utils/app_dimen.dart';
import '../../utils/common.dart';
import 'package:http/http.dart' as http;

import '../../utils/store.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> with SingleTickerProviderStateMixin {
  late Animation animation;

  double beginAnim = 0.0;
  double endAnim = 1.0;

  bool isObsecure = true;

  TextEditingController email = TextEditingController(text: '');
  TextEditingController password = TextEditingController(text: '');
  TextEditingController username = TextEditingController(text: '');
  TextEditingController bio = TextEditingController(text: '');
  TextEditingController mobile = TextEditingController(text: '');
  late var avatar="";
  late FocusNode emailFocusNode;
  late FocusNode mobileFocusNode;
  late FocusNode passwordFocusNode;
  late FocusNode userNameFocusNode;
  String countryCode = "+1";

  @override
  void initState() {
    super.initState();

    // To manage the lifecycle, creating focus nodes in
    // the initState method
    mobileFocusNode = FocusNode();
    emailFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
    userNameFocusNode = FocusNode();

  }

  // Called when the object is removed
  // from the tree permanently
  @override
  void dispose() {

    // Clean up the focus nodes
    // when the form is disposed
    mobileFocusNode.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    userNameFocusNode.dispose();
    super.dispose();
  }

  selectAvatar() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png'],
    );
    if (result != null) {
      setState(() {
        avatar = result.files.first.path!;
      });
    }
  }


  signup() async {
    EasyLoading.show(status: 'loading...');
    Map<String, String> data = {
      "name": username.text,
      'country_code': countryCode,
      'phone': mobile.text,
      "email": email.text,
      "password": password.text,
      "bio": bio.text,
      "type": "dj",
    };
    var request = http.MultipartRequest('POST', generateUrl('sign_up'));
    request.fields.addAll(data);
    if (avatar != null) {
      var multipartFile = await http.MultipartFile.fromPath(
          'avatar', avatar); //returns a Future<MultipartFile>
      request.files.add(multipartFile);
    }
    http.StreamedResponse response = await request.send();
    final respStr = await response.stream.bytesToString();
    var body = jsonDecode(respStr);
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
              Container(
                  padding: EdgeInsets.only(
                    left: hDimen(20),
                    right: hDimen(20),
                  ),
                  child: const LinearProgressIndicator(
                    minHeight: 2,
                    color: Color(0xFFFBBB16),
                    backgroundColor: Color(0xFF5D4E76),
                    value: 0.25,
                  )),
              Padding(
                padding: EdgeInsets.only(left: hDimen(20), top: hDimen(5)),
                child: const Text(
                  "Sign Up as DJ",
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w300,
                      color: Color(0xFF92A4AC)),
                ),
              ),
              Center(
                child: Padding(
                    padding: EdgeInsets.only(top: hDimen(20)),
                    child: GestureDetector(
                      onTap: selectAvatar,
                      child: SizedBox(
                        height: 150,
                        child: Stack(
                          children: [
                            Container(
                              height: hDimen(100),
                              width: hDimen(100),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(color: const Color(0xFF1AA8E6))),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: avatar == null
                                      ? const Image(
                                          image: AssetImage(
                                              "assets/images/user.png"),
                                          fit: BoxFit.contain,
                                        )
                                      :
                                  Image.file(
                                           File(avatar),
                                          fit: BoxFit.contain,
                                       )
                                       ,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 80,
                              bottom: 30,
                              left: 30,
                              right: 30,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: const Color(0xFF1AA8E6),
                                    borderRadius: BorderRadius.circular(50)),
                                child: const Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Image(
                                    image:
                                        AssetImage("assets/images/camera.png"),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 60, right: 60),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "User Name *",
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
                    controller: username,
                    focusNode: userNameFocusNode,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF1AA8E6)),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF1AA8E6)),
                        ),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(13),
                          child: Image.asset(
                            'assets/images/profile.png',
                            width: 10,
                            height: 10,
                            fit: BoxFit.contain,
                          ),
                        ),
                        hintText: "Enter your name",
                        hintStyle: const TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontFamily: "Rajdhani")),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: hDimen(122),
                child: Column(
                  children: [
                    const Padding(
                      padding:
                      EdgeInsets.only(left: 60, right: 60, top: 20),
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
                        focusNode: mobileFocusNode,
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

                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 60, right: 60, top: 15),
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
                    focusNode: emailFocusNode,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF1AA8E6)),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF1AA8E6)),
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
                padding: EdgeInsets.only(left: 60, right: 60, top: 15),
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
                    focusNode: passwordFocusNode,
                    style: const TextStyle(color: Colors.white),
                    obscureText: isObsecure,
                    decoration: InputDecoration(
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF1AA8E6)),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF1AA8E6)),
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
              const Padding(
                padding: EdgeInsets.only(left: 60, right: 60, top: 10),
                child: Text(
                  "Must be 8 char or long. Please use 1 uppercase and 1 number. ",
                  style: TextStyle(
                      color: Color(0xFF92A4AC),
                      fontFamily: "Rajdhani",
                      fontSize: 16),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 60, right: 60, top: 15),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "About Myself *",
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
                  child: SizedBox(
                    height: 100,
                    child: TextField(
                      controller: bio,
                      minLines: 6,
                      maxLines: 6,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF1AA8E6)),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF1AA8E6)),
                          ),
                          hintText: "Type in",
                          hintStyle: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontFamily: "Rajdhani")),
                    ),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: GestureDetector(
                    onTap: () {
                      if (email.text.isEmpty &&
                          password.text.isEmpty &&
                          username.text.isEmpty) {
                        showToast(message: "Please fill up the username, password and email");
                      } else if (username.text.trim().isEmpty) { //RegExp(r"\s").hasMatch(username.text)
                        showToast(message: "Please fill up the username with no space");
                        userNameFocusNode.requestFocus();
                      }else if (mobile.text.isEmpty || RegExp(r"\s").hasMatch(mobile.text)) {
                        showToast(message: "Please enter a valid mobile number");
                        mobileFocusNode.requestFocus();
                      }else if (email.text.isEmpty ||
                          RegExp(r"\s").hasMatch(email.text) ||
                          !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                              .hasMatch(email.text)) {
                        showToast(message: "Please fill up the valid email id");
                        emailFocusNode.requestFocus();
                      } else if (password.text.isEmpty ||
                          RegExp(r"\s").hasMatch(password.text) ||
                          !RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$')
                              .hasMatch(password.text)) {
                        showToast(message: "Please type the properly formatted password");
                        passwordFocusNode.requestFocus();
                      } else {
                        signup();
                      }
                    },
                    child: Container(
                      width: hDimen(100),
                      height: hDimen(40),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1AA8E6),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Center(
                        child: Text(
                          "SIGN UP",
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
                      Navigator.pop(context);
                    },
                    child: RichText(
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
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 5, top: 30),
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Color(0xFF92A4AC), fontSize: 13),
                    children: <TextSpan>[
                      const TextSpan(text: 'By registering, you agree to our'),
                      TextSpan(
                          text: ' Terms of Service',
                          style:
                              const TextStyle(color: Color(0xFF1AA8E6), fontSize: 12),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              var url =
                                  "";
                              if (await canLaunch(url)) {
                                await launch(url);
                              } else {
                                throw 'Could not launch $url';
                              }
                            }),
                      const TextSpan(text: ' and '),
                      TextSpan(
                          text: 'Privacy Policy',
                          style:
                              const TextStyle(color: Color(0xFF1AA8E6), fontSize: 12),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              var url =
                                  "";
                              if (await canLaunch(url)) {
                                await launch(url);
                              } else {
                                throw 'Could not launch $url';
                              }
                            }),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: hDimen(20),
              )
            ],
          ),
        ),
      ),
    );
  }



}
