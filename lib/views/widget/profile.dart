import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../locator.dart';
import '../../models/profile_model.dart';
import '../../models/user_model.dart';
import '../../repos/update_profile_repo.dart';
import '../../utils/app_dimen.dart';
import '../../utils/common.dart';
import '../../utils/http_service.dart';
import '../../utils/shared_preference.dart';
import '../../utils/store.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController mobileNo = TextEditingController(text: ''),
      cardNo = TextEditingController(text: ''),
      cardHolderName = TextEditingController(text: ''),
      expiryDate = TextEditingController(text: ''),
      name = TextEditingController(text: ''),
      cvv = TextEditingController(text: '');

  FocusNode nodeCardNo = FocusNode(),
      nodeCardHolderName = FocusNode(),
      nodeExpiry = FocusNode(),
      nodeCVV = FocusNode();

  String otpField = '';
  List<ProfileModel> profileModels = [];
  List<bool> selecteds = [];

  bool isPic = false;
  bool isEditPhn = false;
  bool isVerifyNum = false;
  bool isAddCard = false;
  bool isEditCard = false;
  bool isEditName = false;
  int editIndex = 0;
  String initialValue = '+1';
  String countryCode = "+1";
  String imagePath = '';
  UpdateProfileRepo profileRepo = UpdateProfileRepo();
  UserDetailsModel userDetailsModel = locator<UserDetailsModel>();

  List<String> countryCodes = [
    '+1',
    '+2',
    '+91',
    '+975',
    '+81',
  ];

  String token = '';
  User? user;
  String compressedpath = "";
  bool isGettingDetails = false;

  @override
  void initState() {
    fetchCreditBalance();
    // initialiseModel();
    super.initState();
  }

  void fetchCreditBalance() async {
    EasyLoading.show(status: 'loading...');
    user = User.fromJson(await Store.getUser());
    var httpClient = HttpService();
    var resp = await httpClient.get(
      generateUrl('profile'),
    );
    if (resp.statusCode == 200) {
      final body = jsonDecode(resp.body);
      print('fetchCreditBalance***$body');
      if (body['status'] == 1) {
        user?.creditBalance = body['credit_balance'];
        await Store.setUser2(user);
      }
    }
    EasyLoading.dismiss();
    getUserDetails();
  }

  getUserDetails() async {
    setState(() {
      isGettingDetails = true;
    });
    token = await Store.getToken();
    print(token);
    String? cardNumber;
    List<String>? cardDetail = [];
    user = User.fromJson(await Store.getUser());
    print(user?.stripeId);
    for (var i = 1; i < 10; i++) {
      cardNumber = await SharedPreference.getStringPreference('key$i');
      if (cardNumber != null && cardNumber.isNotEmpty) {
        cardDetail = await SharedPreference.getListPreference(cardNumber);
        if (cardDetail != null && cardDetail.isNotEmpty) {
          profileModels.add(
            ProfileModel(
              cardNo: cardDetail[0],
              cardName: cardDetail[1],
              name: cardDetail[2],
              cvv: cardDetail[3],
              expiryDate: cardDetail[4],
              isPreferred: cardDetail[5] == 'true' ? true : false,
            ),
          );
          isPreferreds.add(cardDetail[5] == 'true' ? true : false);
          selecteds.add(false);
        }
      } else {
        break;
      }
    }

    // print('Name: ${user!.name}');
    setState(() {
      isGettingDetails = false;
    });
    if (user != null) {
      print('User Bio:${user!.bio}');
    }
  }

  updateMobile({
    String country_code = '',
    String phone = '',
  }) async {
    EasyLoading.show(status: 'loading...');
    var httpClient = HttpService();
    var resp = await httpClient.post(generateUrl('update-profile'), body: {
      'country_code': country_code,
      'phone': phone,
    });
    if (resp.statusCode == 200) {
      final body = jsonDecode(resp.body);
      print(body);
      if (body['status']) {
        //showToast(message: "Your OTP is ${body['code']}");
        //showToast(message: body['message']);

        await Store.setUser(body['user']);
        setState(() {
          isVerifyNum = false;
          isEditPhn = false;
          user?.phone = body['user']['phone'];
        });
      } else {
        showToast(message: body['message']);
      }
    } else {
      showToast(message: 'Oops! Something went wrong.');
    }
    EasyLoading.dismiss();

  }

  verifyOtp(
      {String phone = '', String country_code = '', String otp = ''}) async {
    EasyLoading.show(status: 'loading...');
    var httpClient = HttpService();
    var resp =
        await httpClient.post(generateUrl('verifyotp'), body: {
      'country_code': country_code,
      'phone': phone,
      'otp': otp,
    });
    if (resp.statusCode == 200) {
      final body = jsonDecode(resp.body);
      if (body['status']) {
        print(body);
        //await Store.setToken(body['access_token']);
        await Store.setUser(body['user']);
        setState(() {
          isVerifyNum = false;
          user?.phone = body['user']['phone'];
        });
      } else {
        //showToast(message: body['message']);
      }
    } else {
      //showToast(message: 'Oops! Something went wrong.');
    }
    EasyLoading.dismiss();
  }

  updateProfile({
    String imgPath = '',
    String name = '',
    String password = '',
    String phone = '',
    String country_code = '',
  }) async {
    if (imgPath.isNotEmpty) {
      compressedpath = await testCompressAndGetFile(
        imgPath,
        outPath(
          imgPath: imgPath,
        ),
      );
    }
    dynamic data = FormData.fromMap({
      'avatar': compressedpath.isNotEmpty
          ? await MultipartFile.fromFile(compressedpath)
          : '',
      'name': name.isEmpty ? user!.name : name,
      'password': password,
      'phone': phone,
      'country_code': country_code,
    });
    print('Music Lover Profile:$data');
    Response response = await profileRepo.updateProfile(
      data: data,
      header: token,
    );
    print('Music Lover Profile:$response');
    if (response.statusCode == 200) {
      UserDetailsModel userModel = UserDetailsModel.fromJson(response.data);
      print('UserModel:${userModel.user!.phone}');
      userDetailsModel = userModel;
      print('UserDetailsModel Music Lover :${userDetailsModel.user!.phone}');
      await Store.setUser(response.data['user']);
    }
  }

  final TextStyle textStyle = TextStyle(
    color: Colors.white,
    fontSize: hDimen(16),
  );

  Widget customDropDown({
    List<String>? items,
    bool isCity = false,
    Function? onSelected,
  }) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1E2126),
        border: Border(
            bottom: BorderSide(
          color: Color(0xFF1AA8E6),
          width: 1.2,
        )),
      ),
      child: DropdownButton<String>(
        isExpanded: true,
        dropdownColor: const Color(0xFF1E2126),
        value: initialValue,
        onChanged: (value) {
          setState(() {
            initialValue = value!;
          });
          onSelected!(value);
          print('selected');
        },
        elevation: 0,
        underline: Container(),
        icon: Icon(
          Icons.keyboard_arrow_down,
          size: hDimen(20),
          color: const Color(0xFF1AA8E6),
        ),
        // items: ,
        items: items!.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Padding(
              padding: EdgeInsets.only(left: hDimen(5)),
              child: Text(value),
            ),
          );
        }).toList(),
        style: textStyle,
        hint: Text(
          "Select",
          style: textStyle,
        ),
      ),
    );
  }

  Widget changeMobileDialogue(var phone, var countryCode) {
    mobileNo.text = phone;
    print(WidgetsBinding.instance.window.locale.countryCode);
    return Container(
      height: hDimen(300),
      width: hDimen(250),
      padding: EdgeInsets.only(
        left: hDimen(15),
        right: hDimen(15),
        top: hDimen(20),
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2126),
        border: Border.all(
          color: const Color(0xFF313131),
          width: 1.4,
        ),
        borderRadius: BorderRadius.circular(hDimen(15)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Change Mobile Number',
                style: TextStyle(
                  color: const Color(0xFF92A4AC),
                  fontSize: hDimen(16),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isEditPhn = false;
                  });
                  if (mobileNo
                      .text.isNotEmpty) {
                    updateProfile(
                        phone: mobileNo.text);
                  }

                },
                child: Image.asset(
                  'assets/images/close.png',
                  width: hDimen(25),
                ),
              ),
            ],
          ),
          vSpacing(hDimen(15)),
          Text(
            'Please type in your mobile number',
            style: TextStyle(
              color: Colors.white,
              fontSize: hDimen(13),
            ),
          ),
          vSpacing(hDimen(15)),
          Padding(
            padding: EdgeInsets.only(
              left: hDimen(20),
            ),
            child: const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Mobile Number",
                style: TextStyle(
                  color: Color(0xFF92A4AC),
                  fontFamily: "Rajdhani",
                  fontSize: 16,
                ),
              ),
            ),
          ),
          vSpacing(hDimen(10)),
          IntlPhoneField(
            controller: mobileNo,
            initialCountryCode:
                WidgetsBinding.instance.window.locale.countryCode,
            dropdownIcon: const Icon(
              Icons.arrow_drop_down,
              color: Color(0xFF1AA8E6),
            ),
            dropdownTextStyle:
                const TextStyle(color: Colors.white, fontFamily: "Rajdhani"),
            style: const TextStyle(color: Colors.white, fontFamily: "Rajdhani"),
            decoration: InputDecoration(
              hintText: phone,
              hintStyle: const TextStyle(color: Colors.white, fontFamily: "Rajdhani"),
              helperStyle:
                  const TextStyle(color: Colors.white, fontFamily: "Rajdhani"),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF1AA8E6)),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF1AA8E6)),
              ),
            ),
            onChanged: (phone) {
              countryCode = phone.countryCode;
            },
            onCountryChanged: (country) {
              countryCode = country.dialCode;
            },
          ),
          /*Padding(
            padding: EdgeInsets.only(left: hDimen(20), right: hDimen(20)),
            child: SizedBox(
              height: hDimen(50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: customDropDown(
                      onSelected: () {},
                      items: countryCodes,
                    ),
                  ),
                  hSpacing(10),
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: mobileNo,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF1AA8E6),
                            width: 1.4,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF1AA8E6),
                            width: 1.4,
                          ),
                        ),
                        hintText: "Mobile no",
                        hintStyle: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontFamily: "Rajdhani",
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),*/
          vSpacing(hDimen(20)),
          Center(
            child: GestureDetector(
              onTap: () {
                if (mobileNo.text.isNotEmpty) {
                  setState(() {
                    isEditPhn = false;
                    isVerifyNum = false;
                  });
                  updateMobile(
                    country_code: countryCode,
                    phone: mobileNo.text,
                  );
                  updateProfile(
                    country_code: countryCode,
                    phone: mobileNo.text,
                  );
                } else {
                  showToast(message: 'Please enter valid phone number.');
                }
              },
              child: Container(
                width: hDimen(120),
                height: hDimen(45),
                decoration: BoxDecoration(
                  color: const Color(0xFF1AA8E6),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Center(
                  child: Text(
                    "VERIFY",
                    style: TextStyle(
                      fontSize: hDimen(16),
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget verifyNumDialogue() {
    return Container(
      height: hDimen(330),
      width: hDimen(250),
      padding: EdgeInsets.only(
        left: hDimen(15),
        right: hDimen(15),
        top: hDimen(20),
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2126),
        border: Border.all(
          color: const Color(0xFF313131),
          width: 1.4,
        ),
        borderRadius: BorderRadius.circular(hDimen(15)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Verify Mobile Number',
                style: TextStyle(
                  color: const Color(0xFF92A4AC),
                  fontSize: hDimen(16),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isVerifyNum = false;
                  });
                },
                child: Image.asset(
                  'assets/images/close.png',
                  width: hDimen(25),
                ),
              ),
            ],
          ),
          vSpacing(hDimen(15)),
          Text(
            'Verification code has been sent by SMS to',
            style: TextStyle(
              color: const Color(0xFF92A4AC),
              fontSize: hDimen(13),
            ),
          ),
          vSpacing(hDimen(15)),
          Text(
            mobileNo.text,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: hDimen(20),
            ),
          ),
          vSpacing(hDimen(15)),
          Padding(
            padding: EdgeInsets.only(
              left: hDimen(20),
            ),
            child: const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Enter Code",
                style: TextStyle(
                  color: Color(0xFF92A4AC),
                  fontFamily: "Rajdhani",
                  fontSize: 16,
                ),
              ),
            ),
          ),
          // vSpacing(hDimen(10)),
          Container(
            height: hDimen(40),
            padding: const EdgeInsets.only(
              left: 15,
              right: 15,
            ),
            child: OtpTextField(
              keyboardType: TextInputType.number,
              numberOfFields: 4,
              textStyle: TextStyle(color: Colors.white, fontSize: hDimen(16)),
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              borderColor: const Color(0xFF1AA8E6),
              enabledBorderColor: const Color(0xFF1AA8E6),
              focusedBorderColor: const Color(0xFF1AA8E6),
              showFieldAsBox: false,
              fieldWidth: 30,
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
          vSpacing(hDimen(15)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Didn’t receive a code? ",
                style: TextStyle(
                  color: Color(0xFF92A4AC),
                  fontFamily: "Rajdhani",
                  fontSize: 13,
                ),
              ),
              GestureDetector(
                onTap: () {
                  updateMobile(
                    country_code: countryCode,
                    phone: mobileNo.text,
                  );
                },
                child: const Text(
                  "RESEND",
                  style: TextStyle(
                    color: Color(0xFF1AA8E6),
                    fontFamily: "Rajdhani",
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          vSpacing(hDimen(20)),
          Center(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isVerifyNum = false;
                });
                // verifyOtp(
                //     country_code: countryCode,
                //     phone: mobileNo.text,
                //     otp: otpField);
              },
              child: Container(
                width: hDimen(120),
                height: hDimen(45),
                decoration: BoxDecoration(
                  color: const Color(0xFF1AA8E6),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Center(
                  child: Text(
                    "VERIFY",
                    style: TextStyle(
                      fontSize: hDimen(16),
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<bool> isPreferreds = [];
  List<String> cardNos = [];
  int cardCounter = 1;
  bool isPreferred = false;

  Widget addCardDialogue() {
    return Center(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.7,
        width: MediaQuery.of(context).size.width * 0.85,
        padding: EdgeInsets.only(
          left: hDimen(15),
          right: hDimen(15),
          top: hDimen(20),
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF1E2126),
          border: Border.all(
            color: const Color(0xFF313131),
            width: 1.4,
          ),
          borderRadius: BorderRadius.circular(hDimen(15)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Add Card',
                  style: TextStyle(
                    color: const Color(0xFF92A4AC),
                    fontSize: hDimen(16),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isAddCard = false;
                    });
                  },
                  child: Image.asset(
                    'assets/images/close.png',
                    width: hDimen(25),
                  ),
                ),
              ],
            ),
            vSpacing(hDimen(15)),
            Text(
              'Please fill in the detials',
              style: TextStyle(
                color: Colors.white,
                fontSize: hDimen(13),
              ),
            ),
            vSpacing(hDimen(15)),
            Padding(
              padding: EdgeInsets.only(
                left: hDimen(15),
                right: hDimen(15),
              ),
              child: const Text(
                "Card Number",
                style: TextStyle(
                  color: Color(0xFF92A4AC),
                  fontFamily: "Rajdhani",
                  fontSize: 16,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: hDimen(15), right: hDimen(15)),
              child: TextField(
                controller: cardNo,
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF1AA8E6)),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF1AA8E6)),
                  ),
                  hintText: "Type in",
                  hintStyle: TextStyle(
                    fontSize: hDimen(15),
                    color: Colors.white,
                    fontFamily: "Rajdhani",
                  ),
                ),
              ),
            ),
            vSpacing(hDimen(15)),
            Padding(
              padding: EdgeInsets.only(
                left: hDimen(15),
                right: hDimen(15),
              ),
              child: const Text(
                "Card Holder Name",
                style: TextStyle(
                  color: Color(0xFF92A4AC),
                  fontFamily: "Rajdhani",
                  fontSize: 16,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: hDimen(15), right: hDimen(15)),
              child: TextField(
                controller: cardHolderName,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF1AA8E6)),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF1AA8E6)),
                  ),
                  hintText: "Type in",
                  hintStyle: TextStyle(
                    fontSize: hDimen(15),
                    color: Colors.white,
                    fontFamily: "Rajdhani",
                  ),
                ),
              ),
            ),
            vSpacing(hDimen(15)),
            SizedBox(
              height: hDimen(70),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: hDimen(15),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Exp",
                            style: TextStyle(
                              color: Color(0xFF92A4AC),
                              fontFamily: "Rajdhani",
                              fontSize: 16,
                            ),
                          ),
                          TextField(
                            controller: expiryDate,
                            style: const TextStyle(color: Colors.white),
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              enabledBorder: const UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFF1AA8E6)),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFF1AA8E6)),
                              ),
                              hintText: "mm/yy",
                              hintStyle: TextStyle(
                                fontSize: hDimen(15),
                                color: const Color(0xFF566B75),
                                fontFamily: "Rajdhani",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  hSpacing(hDimen(10)),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: hDimen(15),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "CVV",
                            style: TextStyle(
                              color: Color(0xFF92A4AC),
                              fontFamily: "Rajdhani",
                              fontSize: 16,
                            ),
                          ),
                          TextField(
                            controller: cvv,
                            style: const TextStyle(color: Colors.white),
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              enabledBorder: const UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFF1AA8E6)),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFF1AA8E6)),
                              ),
                              hintText: "cvv",
                              hintStyle: TextStyle(
                                fontSize: hDimen(15),
                                color: const Color(0xFF566B75),
                                fontFamily: "Rajdhani",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            vSpacing(hDimen(15)),
            Padding(
              padding: EdgeInsets.only(
                left: hDimen(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isPreferred = !isPreferred;
                      });
                    },
                    child: Container(
                      height: hDimen(18),
                      width: hDimen(18),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E2126),
                        borderRadius: BorderRadius.circular(hDimen(3)),
                        border: Border.all(
                          color: const Color(0xFF1AA8E6),
                          width: 1.2,
                        ),
                      ),
                      child: isPreferred
                          ? Center(
                              child: Icon(
                                Icons.check,
                                color: Colors.white,
                                size: hDimen(15),
                              ),
                            )
                          : Container(),
                    ),
                  ),
                  hSpacing(hDimen(15)),
                  Text(
                    'Preferred',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: hDimen(17),
                    ),
                  ),
                ],
              ),
            ),
            vSpacing(hDimen(10)),
            Padding(
              padding: EdgeInsets.only(
                left: hDimen(15),
                right: hDimen(15),
              ),
              child: const Text(
                "We do not store any bank related data to our database and never disclose any user information to any one.",
                style: TextStyle(
                  color: Color(0xFF92A4AC),
                  fontFamily: "Rajdhani",
                  fontSize: 16,
                ),
              ),
            ),
            vSpacing(hDimen(20)),
            Center(
              child: GestureDetector(
                onTap: () {
                  if (cardNo.text.isNotEmpty &&
                      cardNo.text.length == 16 &&
                      cardHolderName.text.isNotEmpty &&
                      cvv.text.isNotEmpty &&
                      expiryDate.text.isNotEmpty) {
                    setState(() {
                      isAddCard = false;
                      selecteds.add(false);
                      if (isEditCard) {
                        profileModels[editIndex].cvv = cvv.text;
                        profileModels[editIndex].cardName = cardHolderName.text;
                        profileModels[editIndex].cardNo = cardNo.text;
                        profileModels[editIndex].expiryDate = expiryDate.text;
                        profileModels[editIndex].isPreferred = isPreferred;
                        isPreferred = false;
                        cvv.text = '';
                        cardHolderName.text = '';
                        cardNo.text = '';
                        expiryDate.text = '';
                        isEditCard = false;
                      } else {
                        if (isPreferred) {
                          if (isPreferreds.isEmpty) {
                            isPreferreds.add(true);
                          } else {
                            for (var i = 0; i < isPreferreds.length; i++) {
                              if (isPreferreds[i]) {
                                showToast(
                                    message:
                                        'More than one card can\'t be added as prefered.');
                                isPreferreds.add(false);
                                break;
                              } else if (i == (isPreferreds.length - 1)) {
                                isPreferreds.add(true);
                              }
                            }
                          }
                        } else {
                          isPreferreds.add(false);
                        }
                        profileModels.add(
                          ProfileModel(
                            cardNo: cardNo.text,
                            cardName: cardHolderName.text,
                            name: 'Visa',
                            cvv: cvv.text,
                            expiryDate: expiryDate.text,
                            isPreferred: isPreferred,
                          ),
                        );
                        List<String> cardDetail = [
                          cardNo.text,
                          cardHolderName.text,
                          'Visa',
                          cvv.text,
                          expiryDate.text,
                          isPreferred ? 'true' : 'false'
                        ];
                        SharedPreference.saveListPreference(
                            cardNo.text, cardDetail);
                        SharedPreference.saveStringPreference(
                            'key$cardCounter', cardNo.text);
                        cardCounter++;
                        isPreferred = false;
                        cvv.text = '';
                        cardHolderName.text = '';
                        cardNo.text = '';
                        expiryDate.text = '';
                      }
                    });
                  } else {
                    showToast(
                        message: 'Please enter all card details properly');
                  }
                },
                child: Container(
                  width: hDimen(120),
                  height: hDimen(45),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1AA8E6),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Center(
                    child: Text(
                      "SAVE",
                      style: TextStyle(
                        fontSize: hDimen(16),
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget profileItem({
    String cardName = 'VISA',
    String cardNo = '1234567890123456',
    String name = 'AG',
    bool isSelected = false,
    bool isPrefer = false,
    int index = 0,
  }) {
    return SizedBox(
      height: hDimen(120),
      width: hDimen(170),
      child: Stack(
        children: [
          Container(
            height: hDimen(120),
            width: hDimen(170),
            padding: EdgeInsets.only(
              top: hDimen(15),
              left: hDimen(10),
              right: hDimen(10),
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF1E2126),
              border: Border.all(
                color: isPrefer
                    ? Colors.yellow.shade800
                    : isSelected
                        ? const Color(0xFF1AA8E6)
                        : const Color(0xFF2A2A36),
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(hDimen(15)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cardName,
                  style: TextStyle(
                    color: const Color(0xFF5587D2),
                    fontSize: hDimen(16),
                  ),
                ),
                /*Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      cardName,
                      style: TextStyle(
                        color: Color(0xFF5587D2),
                        fontSize: hDimen(16),
                      ),
                    ),
                    GestureDetector(
                      onTap: onDel!(),
                      child: Image.asset(
                        'assets/images/close.png',
                        width: hDimen(25),
                      ),
                    ),
                  ],
                ),*/
                vSpacing(hDimen(15)),
                Text(
                  name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: hDimen(15),
                  ),
                ),
                vSpacing(hDimen(15)),
                Text(
                  'ending with ${cardNo.substring(12, 16)}',
                  style: TextStyle(
                    color: const Color(0xFF92A4AC),
                    fontSize: hDimen(15),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              right: hDimen(8),
              top: hDimen(10),
            ),
            child: Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () {
                  print('DEL');
                  setState(() {
                    profileModels.removeAt(index);
                  });
                },
                child: Image.asset(
                  'assets/images/close.png',
                  width: hDimen(25),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  final ImagePicker picker = ImagePicker();

  Future<String> getCameraImage() async {
    var image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      return image.path;
    } else {
      return 'Null path';
    }
  }

  Future getGalleryImage() async {
    var image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      return image.path;
    } else {
      return 'Null path';
    }
  }

  bool isImageTaking = false;

  Widget imagePicker({
    Function? onImageTaken,
  }) {
    return Center(
      child: Container(
        padding: EdgeInsets.only(
          top: hDimen(25),
          left: hDimen(25),
          bottom: hDimen(25),
          right: hDimen(20),
        ),
        height: hDimen(200),
        width: hDimen(300),
        color: const Color(0xFFEABF9F),
        child: Column(
          mainAxisSize: MainAxisSize.max, // To make the card compact
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Add Photo",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: hDimen(20),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                GestureDetector(
                  child: Icon(
                    Icons.close,
                    size: hDimen(25),
                    color: Colors.black87,
                  ),
                  onTap: () {
                    setState(() {
                      isImageTaking = false;
                    });
                  },
                ),
              ],
            ),
            vSpacing(hDimen(20)),
            GestureDetector(
              onTap: () async {
                String imgPath = await getCameraImage();
                onImageTaken!(imgPath);
              },
              child: SizedBox(
                height: hDimen(35),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.camera_alt,
                      size: hDimen(30),
                      color: Colors.black,
                    ),
                    hSpacing(hDimen(10)),
                    Expanded(
                        child: Text(
                      "Take Photo",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: hDimen(16),
                        fontWeight: FontWeight.w500,
                      ),
                    ))
                  ],
                ),
              ),
            ),
            vSpacing(hDimen(15)),
            GestureDetector(
              onTap: () async {
                String imgPath = await getGalleryImage();
                onImageTaken!(imgPath);
              },
              child: SizedBox(
                height: hDimen(35),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.image,
                      size: hDimen(30),
                      color: Colors.black,
                    ),
                    hSpacing(hDimen(10)),
                    Expanded(
                        child: Text(
                      "Choose from Gallery",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: hDimen(16),
                        fontWeight: FontWeight.w500,
                      ),
                    ))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      left: false,
      right: false,
      bottom: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/splash_background.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            isGettingDetails
                ? Center(
                    child: SizedBox(
                      height: hDimen(35),
                      width: hDimen(35),
                      child: const CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.only(
                      top: hDimen(30),
                      right: hDimen(20),
                      left: hDimen(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Spacer(
                              flex: 2,
                            ),
                            Text(
                              'My Profile',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: hDimen(24),
                              ),
                            ),
                            const Spacer(),
                            // Container(
                            //     width: hDimen(40),
                            //     height: hDimen(35),
                            //     child: Image.asset(
                            //       'assets/images/scan.png',
                            //       fit: BoxFit.contain,
                            //     )),
                            hSpacing(hDimen(10)),
                            // SizedBox(
                            //     width: hDimen(40),
                            //     height: hDimen(33),
                            //     child: Stack(
                            //       children: [
                            //         SizedBox(
                            //             height: hDimen(33),
                            //             child: Image.asset(
                            //               'assets/images/notification.png',
                            //               fit: BoxFit.cover,
                            //             )),
                            //         Padding(
                            //           padding: EdgeInsets.only(
                            //               top: hDimen(5), left: 2),
                            //           child: Align(
                            //             alignment: Alignment.topRight,
                            //             child: Container(
                            //               height: hDimen(25),
                            //               width: hDimen(25),
                            //               decoration: BoxDecoration(
                            //                 color: Color(0xFFFBBB16),
                            //                 shape: BoxShape.circle,
                            //               ),
                            //               child: Center(
                            //                 child: Text(
                            //                   '5',
                            //                   style: TextStyle(
                            //                       color: Colors.black,
                            //                       fontSize: hDimen(16)),
                            //                 ),
                            //               ),
                            //             ),
                            //           ),
                            //         )
                            //       ],
                            //     )),
                          ],
                        ),
                        vSpacing(hDimen(20)),
                        Text(
                          'My Personal Info',
                          style: TextStyle(
                            color: const Color(0xFF92A4AC),
                            fontSize: hDimen(16),
                          ),
                        ),
                        vSpacing(hDimen(20)),
                        SizedBox(
                          height: hDimen(150),
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: hDimen(150),
                                width: hDimen(150),
                                child: Stack(
                                  children: [
                                    Container(
                                      height: hDimen(135),
                                      width: hDimen(135),
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        border: Border.all(
                                          color: isPic
                                              ? Colors.transparent
                                              : Colors.white,
                                          width: 1.5,
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                      child: imagePath.isNotEmpty
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      hDimen(100)),
                                              child: Image.file(
                                                File(imagePath),
                                                fit: BoxFit.fitWidth,
                                              ),
                                            )
                                          : Center(
                                              child: user == null ||
                                                      user!.avatar!.isEmpty
                                                  ? Image.asset(
                                                      'assets/images/user.png',
                                                      width: hDimen(50),
                                                    )
                                                  : CircleAvatar(
                                                backgroundImage: NetworkImage(user!.avatar!),
                                                backgroundColor: Colors.transparent,
                                                radius: 80,
                                              ),
                                            ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isImageTaking = true;
                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              right: 15.0),
                                          child: Container(
                                            height: hDimen(40),
                                            width: hDimen(40),
                                            decoration: const BoxDecoration(
                                              color: Color(0xFF1AA8E6),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Center(
                                              child: Image.asset(
                                                'assets/images/camera.png',
                                                width: hDimen(25),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              hSpacing(hDimen(10)),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    top: hDimen(15),
                                    bottom: hDimen(15),
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: hDimen(66),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'User Name',
                                                    style: TextStyle(
                                                      color: const Color(0xFF92A4AC),
                                                      fontSize: hDimen(14),
                                                    ),
                                                  ),
                                                  /* Text(
                                              user!.name.isEmpty? 'Ivan Mac':user!.name,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: hDimen(16),
                                              ),
                                            ),*/
                                                  TextField(
                                                    controller: name,
                                                    style: const TextStyle(
                                                        color: Colors.white),
                                                    readOnly: !isEditName,
                                                    decoration: InputDecoration(
                                                      enabledBorder:
                                                          UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: isEditName
                                                                ? const Color(
                                                                    0xFF1AA8E6)
                                                                : Colors
                                                                    .transparent),
                                                      ),
                                                      focusedBorder:
                                                          UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: isEditName
                                                                ? const Color(
                                                                    0xFF1AA8E6)
                                                                : Colors
                                                                    .transparent),
                                                      ),
                                                      hintText: user == null
                                                          ? 'Adam Bravo'
                                                          : user!.name!,
                                                      hintStyle: TextStyle(
                                                        fontSize: hDimen(16),
                                                        color: Colors.white,
                                                        fontFamily: "Rajdhani",
                                                      ),
                                                    ),
                                                    onSubmitted: (value) {
                                                      setState(() {
                                                        isEditName = false;
                                                      });
                                                      if (name
                                                          .text.isNotEmpty) {
                                                        updateProfile(
                                                            name: name.text);
                                                      }
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: (() {
                                                setState(() {
                                                  isEditName = true;
                                                });
                                                print('Edit Name:$isEditName');
                                              }),
                                              child: Container(
                                                height: hDimen(35),
                                                width: hDimen(35),
                                                decoration: const BoxDecoration(
                                                  color: Color(0xFF1AA8E6),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Center(
                                                  child: Image.asset(
                                                    'assets/images/edit.png',
                                                    width: hDimen(15),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Spacer(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Phone No.',
                                                style: TextStyle(
                                                  color: const Color(0xFF92A4AC),
                                                  fontSize: hDimen(14),
                                                ),
                                              ),
                                              Text(
                                                user != null &&
                                                        user!.phone!
                                                            .isNotEmpty &&
                                                        user!.phone != null
                                                    ? "${user!.countryCode!} ${user!.phone!}"
                                                    : "",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: hDimen(16),
                                                ),
                                              ),
                                            ],
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                isEditPhn = true;
                                              });
                                            },
                                            child: Container(
                                              height: hDimen(35),
                                              width: hDimen(35),
                                              decoration: const BoxDecoration(
                                                color: Color(0xFF1AA8E6),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Center(
                                                child: Image.asset(
                                                  'assets/images/edit.png',
                                                  width: hDimen(15),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        vSpacing(hDimen(25)),
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          crossAxisAlignment:
                          CrossAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment:
                              MainAxisAlignment.start,
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'My Credit Balance',
                                  style: TextStyle(
                                    color: const Color(0xFF92A4AC),
                                    fontSize: hDimen(14),
                                  ),
                                ),
                                Text(
                                  user != null &&
                                      user!.creditBalance != null
                                      ? user!.creditBalance.toString()
                                      : '0',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: hDimen(16),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        vSpacing(hDimen(20)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'My Card Details',
                              style: TextStyle(
                                color: const Color(0xFF92A4AC),
                                fontSize: hDimen(16),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isAddCard = true;
                                });
                              },
                              child: Container(
                                height: hDimen(35),
                                width: hDimen(35),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF1AA8E6),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Image.asset(
                                    'assets/images/add.png',
                                    width: hDimen(15),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        vSpacing(hDimen(20)),
                        Expanded(
                          child: isGettingDetails
                              ? Center(
                                  child: SizedBox(
                                    height: hDimen(20),
                                    width: hDimen(20),
                                    child: CircularProgressIndicator(
                                      color: Colors.yellow.shade900,
                                    ),
                                  ),
                                )
                              : GridView(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 1.3,
                                    crossAxisSpacing: hDimen(10),
                                    mainAxisSpacing: hDimen(10),
                                  ),
                                  physics: const BouncingScrollPhysics(),
                                  children: [
                                    for (var index = 0;
                                        index < profileModels.length;
                                        index++)
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            for (var i = 0;
                                                i < selecteds.length;
                                                i++) {
                                              selecteds[i] = false;
                                            }
                                            selecteds[index] = true;
                                            cardHolderName.text =
                                                profileModels[index].cardName;
                                            cardNo.text =
                                                profileModels[index].cardNo;
                                            expiryDate.text =
                                                profileModels[index].expiryDate;
                                            cvv.text = profileModels[index].cvv;
                                            isPreferred = profileModels[index]
                                                .isPreferred;
                                            isAddCard = true;
                                            isEditCard = true;
                                            editIndex = index;
                                          });
                                          print('Name:$isPreferred');
                                        },
                                        child: profileItem(
                                          name: profileModels[index].name,
                                          cardName:
                                              profileModels[index].cardName,
                                          cardNo: profileModels[index].cardNo,
                                          isSelected: selecteds[index],
                                          index: index,
                                          isPrefer: isPreferreds[index],
                                        ),
                                      ),
                                  ],
                                ),
                        ),
                      ],
                    ),
                  ),
            isEditPhn || isVerifyNum || isImageTaking
                ? Container(
                    color: Colors.black.withOpacity(0.5),
                    height: double.infinity,
                    width: double.infinity,
                  )
                : Container(),
            isEditPhn
                ? Center(
                    child:
                        changeMobileDialogue(user!.phone, user!.countryCode!),
                  )
                : Container(),
            isVerifyNum
                ? Center(
                    child: verifyNumDialogue(),
                  )
                : Container(),
            isAddCard ? addCardDialogue() : Container(),
            isImageTaking
                ? imagePicker(
                    onImageTaken: (path) {
                      setState(() {
                        imagePath = path;
                        isImageTaking = false;
                      });
                      updateProfile(imgPath: imagePath);
                    },
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  Future<String> testCompressAndGetFile(
      String filePath, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      filePath,
      targetPath,
      quality: 88,
      minHeight: 512,
      minWidth: 512,
    );

    // print(result!.lengthSync());
    if (result != null) {
      return result.path;
    } else {
      showToast(message: 'Can not compressed');
      return filePath;
    }
  }

  String outPath({
    String imgPath = '',
  }) {
    final lastIndex = imgPath.lastIndexOf(RegExp(r'.jp'));
    final splitted = imgPath.substring(0, (lastIndex));
    final outPath = "${splitted}_out${imgPath.substring(lastIndex)}";
    return outPath;
  }
}
