import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:music/utils/PrefConstants.dart';
import 'package:music/utils/app_dimen.dart';
import 'package:music/utils/common.dart';
import 'package:music/utils/store.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../locator.dart';
import '../../models/bank_account_model.dart';
import '../../models/profile_model.dart';
import '../../models/user_model.dart';
import '../../repos/update_profile_repo.dart';
import '../../utils/http_service.dart';

class DjProfile extends StatefulWidget {
  const DjProfile({Key? key}) : super(key: key);

  @override
  State<DjProfile> createState() => _DjProfileState();
}

class _DjProfileState extends State<DjProfile> {
  bool isPic = false;
  String otpField = '';
  bool isEditBio= false;
  bool isEditPhn = false;
  bool isEditCard = false;
  bool isVerifyAccnt = false;
  bool isSaveMessage=false;
  bool isEditName = false;
  bool isVerifyNum = false;
  String initialValue = '+1';
  bool isChangePassword=false;
  String countryCode = "+1";
  String imagePath='';
  String verifyMsg='';
  bool isEditAmount= false;
  String userId='';
  String bankId='';
  String bankStatus='0';

  UserDetailsModel userDetailsModel = locator<UserDetailsModel>();

  TextEditingController mobileNo = TextEditingController(text: ''),
      cardNo = TextEditingController(text: ''),
      name = TextEditingController(text: ''),
      accNumber = TextEditingController(text: ''),
      ibn = TextEditingController(text: ''),
      oldPassword = TextEditingController(text: ''),
      newPassword = TextEditingController(text: ''),
      cvv = TextEditingController(text: ''),
      amount = TextEditingController(text: ''),
      bio = TextEditingController(text: ''),

      transamount1 = TextEditingController(text: ''),
      transamount2 = TextEditingController(text: '');


  UpdateProfileRepo profileRepo = UpdateProfileRepo();

  List<String> countryCodes = [
    '+1',
    '+2',
    '+91',
    '+975',
    '+81',
  ];

  String token='';
  User? user;
  BankAccountModel? bankAccnt;

  String compressedpath="";


  @override
  void initState() {
    getUserDetails();
    // initialiseModel();

    getBankStatus();

    super.initState();
  }

  getBankStatus() async {
    final  prefs = await SharedPreferences.getInstance();

    setState((){
      bankStatus = (prefs.getString('bankStatus') ?? '');
    });
  }

  bool isGettingDetails=false;
  getUserDetails() async
  {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    // setState((){
    //   isGettingDetails=true;
    // });
    token = await Store.getToken();
    print(token);
    user = User.fromJson(await Store.getUser());
    userId=user!.id.toString();

/*
    bankAccnt= BankAccountModel.fromJson(await Store.getBank());
    bankId =bankAccnt!.stripe_id.toString();*/

    print('Name: ${user!.name}');

    // String? accNo;
    // for(var i=0;i<10;i++) {
    //   accNo = await SharedPreference.getStringPreference(
    //       'key$cardCounter');
    //   if(accNo!=null && accNo.isNotEmpty)
    //     {
    //       accountNos.add(accNo);
    //     }
    //   else
    //     break;
    // }
    // setState((){
    //   isGettingDetails=false;
    // });
    if(user != null)
      {
        print('User Bio:$user');

      }

    bio.text = user?.bio ?? '';
    amount.text = '${user?.amountPerRequest ?? ''}';

    getBankAccountList();
  }

  getBankAccountList() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    //EasyLoading.show(status: 'loading...');
    var httpClient = HttpService();
    var resp = await httpClient.get(generateUrl('bank-details'));

    print(resp);
    if (resp.statusCode == 200) {
      final body = jsonDecode(resp.body);
      if (body['status']) {
        //print(body['bank_details']);
        var rest = body["bank_details"] as List;
        print(rest);
        accountNos = rest.map<BankAccountModel>((json) => BankAccountModel.fromJson(json)).toList();
        /* List<BankAccountModel> users = (json.decode(rest) as List)
            .map((data) => BankAccountModel.fromJson(data))
             .toList();*/
        print(accountNos.length);

        for(var i=0;i<accountNos.length;i++){
          bankId=accountNos[i].stripe_id;
          bankStatus=accountNos[i].status.toString();
          sharedPreferences.setString(PrefConstants.bankId,bankId);
          sharedPreferences.setString(PrefConstants.bankStatus1,bankStatus);
        }

      } else {
        showToast(message: body['message']);
      }
    }
    //EasyLoading.dismiss();
    setState((){
      isGettingDetails=false;
    });

  }

  updateMobile({String country_code='',String phone=''}) async {
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
        showToast(message: body['message']);

        await Store.setUser(body['user']);
        setState((){
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

  verifyOtp({String phone='', String country_code='', String otp=''}) async{
    EasyLoading.show(status: 'loading...');
    var httpClient = HttpService();
    var resp = await httpClient.post(generateUrl('verifyotp'), body: {
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
        setState((){
          isVerifyNum = false;
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

  verifyBank({String amount1='', String amount2='',String token='',String bankID='',String userId=''}) async{
    EasyLoading.show(status: 'loading...');
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var httpClient = HttpService();
    var resp = await httpClient.post(generateUrl('verify-bank'), body: {
      'amount1': amount1,
      'amount2': amount2,
      'user_id': userId,
      'bank_id': bankID,
    });
    if (resp.statusCode == 200) {
      final body = jsonDecode(resp.body);
      if (body['status']) {
        print(body);
        //await Store.setToken(body['access_token']);
        //await Store.setUser(body['user']);
        setState((){
          isVerifyAccnt = false;
          isEditCard=false;
          transamount1.text='';
          transamount2.text='';
          //user?.phone = body['user']['phone'];
        });

        showToast(message: body['message']);
      } else {
        var msg=body['message'].toString();
        String msg1=msg.toString();
        if(msg1.toString().contains("Undefined offset: 1")){
          showToast(message: 'Please enter Decimal value');
        }else{
          showToast(message: body['message']);
          setState((){
            isVerifyAccnt = false;
            isEditCard=false;
            //user?.phone = body['user']['phone'];
          });
        }
      }
    } else {
      showToast(message: 'Oops! Something went wrong.');
    }
    EasyLoading.dismiss();
  }

  updateProfile({String imgPath='', String name='',String password='',String bio='',
  String amount_per_request='',
    String phone = '',
    String country_code = '',}) async
  {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    if(imgPath.isNotEmpty) {
      compressedpath= await testCompressAndGetFile(
        imgPath,
        outPath(imgPath: imgPath,),
      );
    }

    dynamic data= FormData.fromMap(
    {
        'avatar':compressedpath.isNotEmpty ? await MultipartFile.fromFile(compressedpath) :'',
        'name':name.isEmpty ? user!.name : name,
        'bio':bio.isEmpty ? user!.bio : bio,
        'password':password,
        'phone':phone,
        'country_code': country_code,
        'amount_per_request':amount_per_request.isEmpty ? user!.amountPerRequest : amount_per_request,
    });
    Response response = await profileRepo.updateProfile(data: data,header: token,);
    print('UserDetailsModel:$response');
    if (response.statusCode == 200) {
      UserDetailsModel userModel = UserDetailsModel.fromJson(response.data);
      print('UserModel:${userModel.user!.phone}');
      userDetailsModel = userModel;

      await Store.setUser(response.data['user']);
      print('UserDetailsModel:${userDetailsModel.user!.phone}');
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

  Widget changeMobileDialogue( var phone, var countryCode) {
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
                onTap: (){
                  setState((){
                    isEditPhn = false;
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
            initialCountryCode: WidgetsBinding.instance.window.locale.countryCode,
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
            ),
            onChanged: (phone) {
              countryCode = phone.countryCode;
            },
            onCountryChanged: (country) {
              countryCode = country.dialCode;
            },
          ),
          vSpacing(hDimen(20)),
          Center(
            child: GestureDetector(
              onTap: () {

                if(mobileNo.text.isNotEmpty ) {
                  setState(() {
                    isEditPhn = false;
                    isVerifyNum = false;
                  });
                  updateMobile(country_code: countryCode, phone: mobileNo.text,);
                  updateProfile(country_code: countryCode, phone: mobileNo.text,);
                }
                else
                  {
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
                onTap: (){
                  setState((){
                    isVerifyNum=false;
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
                onTap: (){
                  //updateMobile(country_code: countryCode, phone: mobileNo.text,);
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
                //verifyOtp(country_code: countryCode, phone: mobileNo.text,otp: otpField);
                 //updateProfile();
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

  List<ProfileModel> models=[];
  int cardCounter=1;

  Widget addCardDialogue({bool isPreferred=false,}) {
    return Center(
      child: Container(
        height: MediaQuery.of(context).size.height*0.7,
        width: MediaQuery.of(context).size.width*0.85,
        padding: EdgeInsets.only(
          left: hDimen(15),
          right: hDimen(15),
          top: hDimen(15),
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
                  onTap: (){
                    setState((){
                      isEditCard=false;
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
            Padding(
              padding:
              EdgeInsets.only(left: hDimen(15), right: hDimen(15),),
              child: const Text(
                "Bank Holder Name",
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
                decoration: InputDecoration(
                  enabledBorder: const UnderlineInputBorder(
                    borderSide:
                    BorderSide(color: Color(0xFF1AA8E6)),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide:
                    BorderSide(color: Color(0xFF1AA8E6)),
                  ),
                  hintText: "Type in",
                  hintStyle: TextStyle(
                    fontSize: hDimen(15),
                    color: const Color(0xFF566B75),
                    fontFamily: "Rajdhani",
                  ),
                ),
              ),
            ),
            vSpacing(hDimen(15)),
            Padding(
              padding:
              EdgeInsets.only(left: hDimen(15), right: hDimen(15),),
              child: const Text(
                "Account Number",
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
                controller: accNumber,
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
                  hintText: "Type in",
                  hintStyle: TextStyle(
                    fontSize: hDimen(15),
                    color: const Color(0xFF566B75),
                    fontFamily: "Rajdhani",
                  ),
                ),
              ),
            ),
            vSpacing(hDimen(15)),
            Padding(
              padding: EdgeInsets.only(left: hDimen(15), right: hDimen(15),),
              child: const Text(
                "Routing number",
                style: TextStyle(
                  color: Color(0xFF92A4AC),
                  fontFamily: "Rajdhani",
                  fontSize: 16,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: hDimen(15), right: hDimen(15),),
              child: TextField(
                controller: ibn,
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
                  hintText: "Type in",
                  hintStyle: TextStyle(
                    fontSize: hDimen(15),
                    color: const Color(0xFF566B75),
                    fontFamily: "Rajdhani",
                  ),
                ),
              ),
            ),
            vSpacing(hDimen(15)),
            // Padding(
            //   padding: EdgeInsets.only(left:hDimen(20),),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.start,
            //     crossAxisAlignment: CrossAxisAlignment.center,
            //     children: [
            //       GestureDetector(
            //         onTap: (){
            //           setState((){
            //             isPreferred=!isPreferred;
            //           });
            //           print('TAB');
            //         },
            //         child: Container(
            //           height: hDimen(18),
            //           width: hDimen(18),
            //           decoration: BoxDecoration(
            //             color: Color(0xFF1E2126),
            //             borderRadius: BorderRadius.circular(hDimen(3)),
            //             border: Border.all(color: Color(0xFF1AA8E6),width: 1.2,),
            //           ),
            //           child:isPreferred ?
            //           Center(
            //             child: Icon(Icons.check,color: Colors.white,size: hDimen(25),),
            //           ):Container(),
            //         ),
            //       ),
            //       hSpacing(hDimen(15)),
            //       Text('Preferred',style: TextStyle(
            //         color: Colors.white,
            //         fontSize: hDimen(17),
            //       ),),
            //     ],
            //   ),
            // ),
            // vSpacing(hDimen(10)),
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
            vSpacing(hDimen(15)),
            Center(
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children:[

                      Center(
                       child: GestureDetector(
                       onTap: () async {
                      if(accNumber.text.isNotEmpty &&ibn.text.isNotEmpty && ibn.text.length >= 9 && cardNo.text.isNotEmpty)
                      {
                        // setState(() {
                        //   accountNos.add(accNumber.text.substring(12, 16));
                        //   SharedPreference.saveStringPreference('key$cardCounter', accNumber.text.substring(12, 16));
                        //   accNumber.text='';
                        //   cardNo.text='';
                        //   ibn.text='';
                        //   isEditCard = false;
                        // });
                        // print('isEditCard:$isEditCard');
                        // models.add(ProfileModel(
                        //   cardNo: cardNo.text,
                        //   accNo: accNumber.text,
                        //   ibn: ibn.text,
                        // ),);
                        EasyLoading.show(status: 'loading...');
                        var btp = BankAccountTokenParams(accountNumber: accNumber.text, country: 'US', currency: 'usd', routingNumber: ibn.text, accountHolderName: cardNo.text);
                        var bankToken = CreateTokenParams.bankAccount(params: btp);
                        print(bankToken.toJson());
                        var token = await Stripe.instance.createToken(bankToken);

                        print(token.id);

                        var httpClient = HttpService();
                        var resp = await httpClient.post(generateUrl('save-bank-detail'), body: {
                          'token': token.id
                        });

                        if (resp.statusCode == 200) {
                          final body = jsonDecode(resp.body);
                          if (body['status']) {

                            //showToast(message: "Bank Added successfully!");
                            isSaveMessage = true;
                          } else {
                            showToast(message: body['message']);
                          }
                        } else {
                          showToast(message: 'Oops! Something went wrong.');
                        }
                        EasyLoading.dismiss();

                        setState((){
                          isEditCard=false;
                          accNumber.text='';
                          cardNo.text='';
                          ibn.text='';
                        });

                        getUserDetails();
                      }
                      else{
                        showToast(message: 'Please enter all the fields properly');
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
                       )
                      ),

                      Center(
                        child:GestureDetector(
                          onTap: () async{
                            final  prefs = await SharedPreferences.getInstance();
                            bankStatus = (prefs.getString('bankStatus') ?? '');
                            if(bankStatus.contains('0')) {
                              setState(() {
                                isVerifyAccnt = true;
                                isSaveMessage = false;
                                isEditCard = false;
                              });
                            }else{
                              showToast(message: 'Already Verified');
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
                          child: bankStatus== '0'?
                              Text("VERIFY",  style: TextStyle(
                                fontSize: hDimen(16),
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),):
                              Text("VERIFIED",  style: TextStyle(
                                fontSize: hDimen(16),
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),)
                            ),

                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ),
            vSpacing(hDimen(10)),
            Center(
              child: Text('Powered By',style: TextStyle(
                color: const Color(0xFF566B75),
                fontSize: hDimen(11),
              ),),
            ),
            Center(child: Image.asset('assets/images/stripe.png',width: hDimen(115), alignment: Alignment.center,)),
          ],
        ),
      ),
    );
  }

  Widget verifyAccountDialogue({bool isPreferred=false,}) {

    return Center(
      child: Container(
        height: MediaQuery.of(context).size.height*0.6,
        width: MediaQuery.of(context).size.width*0.85,
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
                  '',
                  style: TextStyle(
                    color: const Color(0xFFFFFFFF),
                    fontSize: hDimen(20),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    setState((){
                      isVerifyAccnt=false;
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
            Center(
              child: Text(
                'Verify Account',
                style: TextStyle(
                  color: const Color(0xFFFFFFFF),
                  fontSize: hDimen(20),
                ),
              ),
            ),
            vSpacing(hDimen(30)),
            Padding(
              padding:
              EdgeInsets.only(left: hDimen(15), right: hDimen(15),),
              child: const Text(
                "First Transaction Amount",
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
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
                  TextInputFormatter.withFunction((oldValue, newValue) {
                    try {
                      final text = newValue.text;
                      if (text.isNotEmpty) double.parse(text);
                      return newValue;
                    } catch (e) {}
                    return oldValue;
                  }),
                ],
                controller: transamount1,
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
                  hintText: "Type in",
                  hintStyle: TextStyle(
                    fontSize: hDimen(15),
                    color: const Color(0xFF566B75),
                    fontFamily: "Rajdhani",
                  ),
                ),
              ),
            ),
            vSpacing(hDimen(30)),
            Padding(
              padding:
              EdgeInsets.only(left: hDimen(15), right: hDimen(15),),
              child: const Text(
                "Second Transaction Amount",
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
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
                  TextInputFormatter.withFunction((oldValue, newValue) {
                    try {
                      final text = newValue.text;
                      if (text.isNotEmpty) double.parse(text);
                      return newValue;
                    } catch (e) {}
                    return oldValue;
                  }),
                ],
                controller: transamount2,
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
                  hintText: "Type in",
                  hintStyle: TextStyle(
                    fontSize: hDimen(15),
                    color: const Color(0xFF566B75),
                    fontFamily: "Rajdhani",
                  ),
                ),
              ),
            ),
            vSpacing(hDimen(40)),

            Center(
              child:GestureDetector(
                onTap: () async{
                  // Obtain shared preferences.
                  final prefs = await SharedPreferences.getInstance();

                  token = await Store.getToken();
                  print(token);


                  user = User.fromJson(await Store.getUser());
                  userId=user!.id.toString();

                  bankId = (prefs.getString('bankId') ?? '');

                  if(transamount1.text.isEmpty && transamount2.text.isEmpty)
                  {
                    showToast(message: 'Please enter all the fields');
                  }
                  else
                  {
                    verifyBank(amount1:transamount1.text.toString(),amount2:transamount2.text.toString(),token:token,bankID:bankId,userId: userId);

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
                    "SUBMIT",
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
            vSpacing(hDimen(10)),

                   ],
        ),
      ),
    );
  }

  Widget verifyPopup({bool isPreferred=false,})  {
    return Center(
      child: Container(
        height: MediaQuery.of(context).size.height*0.6,
        width: MediaQuery.of(context).size.width*0.85,
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
                  '' ,
                  style: TextStyle(
                    color: const Color(0xFFFFFFFF),
                    fontSize: hDimen(18),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState((){
                      isSaveMessage=false;
                    });
                  },
                  child: Image.asset(
                    'assets/images/close.png',
                    width: hDimen(25),
                  ),
                ),
              ],
            ),
            vSpacing(hDimen(20)),
            Center(
              child: Text(
                'Message',
                style: TextStyle(
                  color: const Color(0xFFFFFFFF),
                  fontSize: hDimen(18),
                ),
              ),
            ),
            vSpacing(hDimen(20)),
            Padding(
              padding: EdgeInsets.only(
                left: hDimen(15),
                right: hDimen(15),
              ),
              child: const Text(
                  'For bank account verification, we will send microdeposits to your account. These microdeposits will be small amounts, such as \$0.32 and \$0.04. The process may take 2 to 3 business days for the deposits to appear in your account. Once you receive these amounts, please log in to our portal and enter the exact deposit amounts to complete the verification process. Thank you!'
                ,
                style: TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontFamily: "Rajdhani",
                  fontSize: 16,
                ),
              ),
            ),
            vSpacing(hDimen(20)),
            Center(
              child: GestureDetector(
                onTap: () {
                    setState(() {
                      isSaveMessage = false;
                    });
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
                      "OK",
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

  Widget changePassDialogue() {
    return Center(
      child: Container(
        height: MediaQuery.of(context).size.height*0.5,
        width: MediaQuery.of(context).size.width*0.85,
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
                  'Change Password',
                  style: TextStyle(
                    color: const Color(0xFF92A4AC),
                    fontSize: hDimen(16),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    setState((){
                      newPassword.text='';
                      oldPassword.text='';
                      isChangePassword=false;
                    });
                  },
                  child: Image.asset(
                    'assets/images/close.png',
                    width: hDimen(25),
                  ),
                ),
              ],
            ),
            vSpacing(hDimen(20)),
            Padding(
              padding:
              EdgeInsets.only(left: hDimen(15), right: hDimen(15),),
              child: const Text(
                "Old Password",
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
                controller: oldPassword,
                obscureText: true,
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
                  hintText: "Type in",
                  hintStyle: TextStyle(
                    fontSize: hDimen(15),
                    color: Colors.white,
                    fontFamily: "Rajdhani",
                  ),
                ),
              ),
            ),
            vSpacing(hDimen(20)),
            Padding(
              padding:
              EdgeInsets.only(left: hDimen(15), right: hDimen(15),),
              child: const Text(
                "New Password",
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
                controller: newPassword,
                obscureText: true,
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
                "Password should be 8 char or long. Please use 1 uppercase and 1 number.",
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
                  // RegExp regex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                  if(newPassword.text!=oldPassword.text && oldPassword.text.isNotEmpty || validateStructure(oldPassword.text))
                    {
                      updateProfile(password: newPassword.text);
                      setState(() {
                        isChangePassword = false;
                        newPassword.text='';
                        oldPassword.text='';
                      });
                    }
                  else
                    {
                      print('Password:${newPassword.text}');
                      showToast(message: 'Please enter a valid password');
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

  bool validateStructure(String value){
    String  pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(value);
  }

  List<BankAccountModel> accountNos=[];
  bankDetails({Function? onDel, Function? onEdit,required String accNO, bool isPreferred=false,})
  {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 9,
          child: Text('Direct to Local Bank [USD] - Account ending in $accNO',
            style: TextStyle(
              color: Colors.white,
              fontSize: hDimen(13),
            ),),
        ),
        hSpacing(hDimen(10)),
        // GestureDetector(child: Image.asset('assets/images/edit_blue.png',width: hDimen(20),),onTap: (){
        //   onEdit!();
        // },),
        // SizedBox(height: hDimen(16),width: 2,child: VerticalDivider(
        //   width: 2,
        //   color: Color(0xFF566B75),
        // ),),
        Expanded(
          flex: 1,
          child: SizedBox(
            width: 20,
            height: 20,
            child: GestureDetector(child: Image.asset(
  'assets/images/cross_red.png',
    fit: BoxFit.scaleDown,),
            onTap: (){
              print('Delete...1');
              onDel!();
            },),
          ),
        ),
      ],);
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
                  onTap: (){
                    setState(() {
                      isImageTaking=false;
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
            isGettingDetails ?
            Center(
              child: SizedBox(
                height: hDimen(35),
                width: hDimen(35),
                child: const CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ):   SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(
              top: hDimen(20),
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
                    //           padding:
                    //           EdgeInsets.only(top: hDimen(5), left: 2),
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
              vSpacing(hDimen(10)),
                Text(
                  'My Personal Info',
                  style: TextStyle(
                    color: const Color(0xFF92A4AC),
                    fontSize: hDimen(16),
                  ),
                ),
                vSpacing(hDimen(10)),
                SizedBox(
                  height: hDimen(200),
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: hDimen(170),
                        width: hDimen(170),
                        child: Stack(
                          children: [
                            Container(
                              height: hDimen(150),
                              width: hDimen(150),
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
                                borderRadius: BorderRadius.circular(hDimen(100)),
                                    child: Image.file(File(imagePath),
                                fit: BoxFit.fitWidth,
                              ),
                                  ):Center(
                                child:user==null || user!.avatar!.isEmpty ?
                                Image.asset(
                                  'assets/images/user.png',
                                  width: hDimen(50),
                                )
                                    :
                                CircleAvatar(
                                  backgroundImage: NetworkImage(user!.avatar!),
                                  backgroundColor: Colors.transparent,
                                  radius: 80,
                                ),
                                //Image.network(user!.avatar!,fit: BoxFit.cover,),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isImageTaking=true;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 15.0),
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
                      hSpacing(hDimen(8)),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: hDimen(15),
                            bottom: hDimen(15),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: hDimen(66),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'DJ Name',
                                            style: TextStyle(
                                              color: const Color(0xFF92A4AC),
                                              fontSize: hDimen(14),
                                            ),
                                          ),
                                          /*Text(
                                            user!.name.isEmpty ? 'Adam Bravo':user!.name,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: hDimen(16),
                                            ),
                                          ),*/
                                          TextField(
                                            controller: name,
                                            style: const TextStyle(color: Colors.white),
                                            readOnly: !isEditName,
                                            decoration: InputDecoration(
                                              enabledBorder: UnderlineInputBorder(
                                                borderSide:
                                                BorderSide(color:isEditName? const Color(0xFF1AA8E6) :Colors.transparent),
                                              ),
                                              focusedBorder: UnderlineInputBorder(
                                                borderSide:
                                                BorderSide(color:isEditName? const Color(0xFF1AA8E6):Colors.transparent),
                                              ),
                                              hintText: user==null  ? '': user!.name,
                                              hintStyle: TextStyle(
                                                fontSize: hDimen(16),
                                                color: Colors.white,
                                                fontFamily: "Rajdhani",
                                              ),
                                            ),
                                            onSubmitted: (value){
                                              setState((){
                                                isEditName=false;
                                              });
                                              if(name.text.isNotEmpty){
                                                updateProfile(name: name.text);
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: ((){
                                       setState((){
                                         isEditName=true;
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
                              Text(
                                'Password.',
                                style: TextStyle(
                                  color: const Color(0xFF92A4AC),
                                  fontSize: hDimen(14),
                                ),
                              ),
                              GestureDetector(
                                onTap: (){
                                  setState((){
                                    isChangePassword=true;
                                  });
                                },
                                child: Text(
                                  'Change Password',
                                  style: TextStyle(
                                    color: const Color(0xFF1AA8E6),
                                    fontSize: hDimen(16),
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                                        user==null ||  user!.phone==null ? "" : "${user!.countryCode!} ${user!.phone!}" ,
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
                vSpacing(hDimen(10)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/email.png',width: hDimen(25),),
                    hSpacing(hDimen(10)),
                    Text(
                      user==null  ? '':user!.email!,style: TextStyle(
                      color: const Color(0xFF92A4AC),
                      fontSize: hDimen(16),
                    ),),
                    const Spacer(),
                    GestureDetector(
                        onTap: () {
                            print('Share QR code ${user?.qrCode}');
                            shareQR(context, user?.qrCode ?? '');
                        },
                        child: Container(
                    child: Image.asset('assets/images/qr_code.png',height: hDimen(30),width: hDimen(30),),
                        ),
                    ),
                  ],
                ),
                vSpacing(hDimen(8)),
                const Divider(
                  height: 2,
                  color: Color(0xFF5D4E76),
                ),
                vSpacing(hDimen(8)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('My Bio',
                      style: TextStyle(
                        color: const Color(0xFF92A4AC),
                        fontSize: hDimen(16),
                      ),),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isEditBio = true;
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
                vSpacing(hDimen(8)),
                // Text(user != null ?
                // user!.bio!
                //     :
                // '',
                //   style: TextStyle(
                //   color: Colors.white,
                //   fontSize: hDimen(14),
                // ),),

                //+++++++++++++??
                TextField(
                  controller: bio,
                  style: const TextStyle(color: Colors.white),
                  readOnly: !isEditBio,
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                      BorderSide(color:isEditBio? const Color(0xFF1AA8E6) :Colors.transparent),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                      BorderSide(color:isEditBio? const Color(0xFF1AA8E6):Colors.transparent),
                    ),

                    hintStyle: TextStyle(
                      fontSize: hDimen(16),
                      color: Colors.white,
                      fontFamily: "Rajdhani",
                    ),
                  ),
                  onSubmitted: (value){
                    setState((){
                      isEditBio=false;
                    });
                    if(bio.text.isNotEmpty){
                      updateProfile(bio: bio.text);
                    }
                  },
                ),

                vSpacing(hDimen(8)),
                const Divider(
                  height: 2,
                  color: Color(0xFF5D4E76),
                ),
                vSpacing(hDimen(8)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Fees/Request',
                      style: TextStyle(
                        color: const Color(0xFF92A4AC),
                        fontSize: hDimen(16),
                      ),),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isEditAmount = true;
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
                vSpacing(hDimen(5)),
                // Text('\$ ${user?.amountPerRequest?.toString() ?? '1'}',
                //   style: TextStyle(
                //   color: Color(0xFFFBBB16),
                //     fontSize: hDimen(18),
                // ),),

                //+++++++++++++??
                TextField(
                  controller: amount,
                  style: const TextStyle(color: Colors.white),
                  readOnly: !isEditAmount,
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                      BorderSide(color:isEditAmount? const Color(0xFF1AA8E6) :Colors.transparent),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                      BorderSide(color:isEditAmount? const Color(0xFF1AA8E6):Colors.transparent),
                    ),

                    hintStyle: TextStyle(
                      fontSize: hDimen(16),
                      color: Colors.white,
                      fontFamily: "Rajdhani",
                    ),
                  ),
                  onSubmitted: (value){
                    setState((){
                      isEditAmount=false;
                    });
                    if(amount.text.isNotEmpty){
                      updateProfile(amount_per_request: amount.text);
                    }
                  },
                ),
                vSpacing(hDimen(8)),
                const Divider(
                  height: 2,
                  color: Color(0xFF5D4E76),
                ),
                vSpacing(hDimen(8)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('My Bank Details',
                      style: TextStyle(
                        color: const Color(0xFF92A4AC),
                        fontSize: hDimen(16),
                      ),),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isEditCard = true;
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
                vSpacing(hDimen(10)),
                for(var i=0;i<accountNos.length;i++)
                  isGettingDetails ?
                  Center(
                    child: SizedBox(height: hDimen(20),width: hDimen(20),
                      child: CircularProgressIndicator(
                        color: Colors.yellow.shade900,
                      ),),
                  )
                      : Padding(
                    padding: EdgeInsets.only(bottom: hDimen(10),),
                    child: bankDetails(
                      onDel: (){
                        // setState((){
                        //   accountNos.removeAt(i);
                        // });
                        
                        print('Delete...' + accountNos[i].id);
                        bankId=accountNos[i].stripe_id;

                        print('Stripee...${accountNos[i].stripe_id}');

                        deleteBankAccount(accountNos[i].id);
                      },
                      onEdit: (){
                        // setState((){
                        //   isEditCard=true;
                        //   cardNo.text = models[i].cardNo;
                        //   ibn.text=models[i].ibn;
                        //   accNumber.text = models[i].accNo;
                        // });
                      },
                      accNO: accountNos[i].account_no

                    ),
                  ),
                vSpacing(5),
                // accountNos.isNotEmpty ?  Text('[Preferred]',style: TextStyle(
                //   color: Color(0xFFFBBB16),
                //   fontSize: hDimen(16),
                // ),):Container(),
              ],
            ),),
            isEditPhn || isVerifyNum ||isEditCard || isChangePassword || isImageTaking
                ? Container(
              color: Colors.black.withOpacity(0.5),
              height: double.infinity,
              width: double.infinity,
            )
                : Container(),
            isEditPhn
                ? Center(
              child: changeMobileDialogue(user!.phone, user!.countryCode ?? ''),
            )
                : Container(),
            isVerifyNum
                ? Center(
              child: verifyNumDialogue(),
            )
                : Container(),
            isEditCard ? addCardDialogue(isPreferred: false,):Container(),
            isVerifyAccnt ? verifyAccountDialogue(isPreferred: false,):Container(),
            isSaveMessage ? verifyPopup(isPreferred: false,) : Container(),
            isChangePassword ? changePassDialogue() : Container(),

            isImageTaking ? imagePicker(
              onImageTaken: (path){
                setState((){
                  imagePath=path;
                  isImageTaking=false;
                });
                updateProfile(imgPath:imagePath );
              },
            ):Container(),
          ],
        ),
      ),
    );
  }

  Future<String> testCompressAndGetFile(String filePath, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      filePath, targetPath,
      quality: 88,
      minHeight: 512,
      minWidth: 512,
    );

    // print(result!.lengthSync());
    if(result!=null) {
      return result.path;
    } else
    {
      showToast(message: 'Can not compressed');
      return filePath;
    }
  }

  String outPath({String imgPath='',})
  {
    final lastIndex = imgPath.lastIndexOf(RegExp(r'.jp'));
    final splitted = imgPath.substring(0, (lastIndex));
    final outPath = "${splitted}_out${imgPath.substring(lastIndex)}";
    return outPath;
  }

  deleteBankAccount(String bankAccountID) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    print('Delete.....@');
    //EasyLoading.show(status: 'loading...');
    var httpClient = HttpService();
    var resp = await httpClient.post(generateUrl('delete-bank-detail'), body: {
      'bank_details_id': bankAccountID,
    });
    if (resp.statusCode == 200) {
      final body = jsonDecode(resp.body);
      print(body);
      if (body['status']) {
        bankStatus='0';
        sharedPreferences.setString(PrefConstants.bankStatus1,'0');
        setState((){
          isVerifyAccnt = false;
          isEditCard=false;
        });
        getBankAccountList();

      } else {
        showToast(message: body['message']);
      }
    } else {
      showToast(message: 'Oops! Something went wrong.');
    }
    //EasyLoading.dismiss();
  }

  shareQR(BuildContext context, String qrURL) {
    final RenderObject? box = context.findRenderObject();
    var url = Uri.parse(qrURL);
    Share.share(
      "Please download, scan the QR code and send request for songs to the DJ. $url",
      sharePositionOrigin: box?.paintBounds,
    );
  }
}
