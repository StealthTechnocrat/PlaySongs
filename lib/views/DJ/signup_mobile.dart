import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:music/views/DJ/signup.dart';
import 'package:music/views/DJ/signup_verify.dart';

import '../../utils/app_dimen.dart';
import '../../utils/common.dart';

class SignUpMobile extends StatefulWidget{
  const SignUpMobile({Key? key}) : super(key: key);

  @override
  _SignUpMobileState createState() => _SignUpMobileState();
}

class _SignUpMobileState extends State<SignUpMobile>{

  TextEditingController mobile = TextEditingController(text: '');


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
                fit: BoxFit.cover
            )
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: hDimen(50),),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: (){
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
                      child: const Text('WELCOME TO',style: TextStyle(color: Colors.white,fontSize: 22,fontWeight: FontWeight.w500,fontFamily: "Rajdhani"),),
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
                  padding: EdgeInsets.only(left: hDimen(20),right: hDimen(20),),
                  child: const LinearProgressIndicator(
                    minHeight: 2,
                    color: Color(0xFFFBBB16),
                    backgroundColor: Color(0xFF5D4E76),
                    value: 0.5,
                  )),
              Padding(
                padding: EdgeInsets.only(left: hDimen(20),top: hDimen(5)),
                child: const Text("Sign Up as DJ",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w300,color: Color(0xFF92A4AC)),),
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: hDimen(20)),
                  child:  Container(
                    height: hDimen(100),
                    width: hDimen(100),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(color: const Color(0xFF1AA8E6))
                    ),
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
              const Padding(
                padding: EdgeInsets.only(left: 60,right: 60,top: 40),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Mobile Number *",style: TextStyle(color: Color(0xFF92A4AC),fontFamily: "Rajdhani",fontSize: 16),),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10,left: 55,right: 55),
                child: IntlPhoneField(
                  controller: mobile,
                  dropdownIcon: const Icon(Icons.arrow_drop_down,color: Color(0xFF1AA8E6),),
                  dropdownTextStyle: const TextStyle(color: Colors.white,fontFamily: "Rajdhani"),
                  style: const TextStyle(color: Colors.white,fontFamily: "Rajdhani"),
                  decoration: const InputDecoration(
                    hintText: 'Phone Number',
                    hintStyle: TextStyle(color: Colors.white,fontFamily: "Rajdhani"),
                    helperStyle: TextStyle(color: Colors.white,fontFamily: "Rajdhani"),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF1AA8E6)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF1AA8E6)),
                    ),
                    // border: OutlineInputBorder(
                    //   // borderSide: BorderSide(color: Colors.transparent,width: 0),
                    // ),
                  ),
                  onChanged: (phone) {
                    print(phone.completeNumber);
                  },
                  onCountryChanged: (country) {
                    print('Country changed to: ${country.name}');
                  },
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 60,right: 60,top: 10),
                child: Text("4 digit verification code will be sent",style: TextStyle(color: Color(0xFF92A4AC),fontFamily: "Rajdhani",fontSize: 16),),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: GestureDetector(
                    onTap: (){
                      if(mobile.text.isEmpty || RegExp(r"\s").hasMatch(mobile.text)){
                        showToast(message: "Please enter a valid mobile number");
                      } else{
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => SignUpVerify(),
                          ),
                        );
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
                        child: Text("VERIFY",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500,color: Colors.black),),
                      ),
                    ),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: GestureDetector(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignUp()),
                      );
                    },
                    child: RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: "EXISTING USER? ",
                            style: TextStyle(
                                color: const Color(0xFF92A4AC),
                                fontSize: hDimen(17),
                                fontFamily: "Rajdhani"
                            ),
                          ),
                          TextSpan(
                            text: 'SIGN IN',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF1AA8E6),
                                fontSize: hDimen(16),
                                fontFamily: "Rajdhani"
                            ),
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