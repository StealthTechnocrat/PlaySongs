import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:music/utils/app_dimen.dart';
import 'package:music/utils/common.dart';
import 'package:music/utils/store.dart';
import 'package:music/views/DJ/about_us.dart';
import 'package:music/views/DJ/faq.dart';
import 'package:music/views/DJ/privacy_policy.dart';
import 'package:music/views/user_selection.dart';
import 'package:music/views/welcome.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../utils/http_service.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({Key? key}) : super(key: key);

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  logout() async {
    await Store.clearStorage();
    await Future.delayed(const Duration(seconds: 1));
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (BuildContext context) => const UserSelection(),
      ),
      (Route route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: false,
      left: false,
      right: false,
      child: Scaffold(
        body: Container(
          height: double.infinity,
          width: double.infinity,
          padding: EdgeInsets.only(
            top: hDimen(20),
            right: hDimen(20),
            left: hDimen(20),
          ),
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/splash_background.png'),
                fit: BoxFit.cover),
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
                    flex: 1,
                  ),
                  Text(
                    'More',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: hDimen(24),
                    ),
                  ),
                  const Spacer(),
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
                  //           padding: EdgeInsets.only(top: hDimen(5), left: 2),
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
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Welcome(
                            isMore: true,
                          )));
                },
                child: Container(
                  height: hDimen(60),
                  padding: EdgeInsets.only(
                    left: hDimen(20),
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E2126),
                    border: Border.all(
                      color: const Color(0xFF2A2A36),
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(hDimen(15)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: hDimen(25),
                        width: hDimen(25),
                        child: Image.asset(
                          'assets/images/works.png',
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                      hSpacing(hDimen(20)),
                      Text(
                        'How it Works',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: hDimen(18),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              vSpacing(hDimen(20)),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const AboutUs()),
                  );
                },
                child: Container(
                  height: hDimen(60),
                  padding: EdgeInsets.only(
                    left: hDimen(20),
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E2126),
                    border: Border.all(
                      color: const Color(0xFF2A2A36),
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(hDimen(15)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: hDimen(25),
                        width: hDimen(25),
                        child: Image.asset(
                          'assets/images/about.png',
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                      hSpacing(hDimen(20)),
                      Text(
                        'About Us',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: hDimen(18),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              vSpacing(hDimen(20)),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const FAQScreen()),
                  );
                },
                child: Container(
                  height: hDimen(60),
                  padding: EdgeInsets.only(
                    left: hDimen(20),
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E2126),
                    border: Border.all(
                      color: const Color(0xFF2A2A36),
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(hDimen(15)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: hDimen(25),
                        width: hDimen(25),
                        child: Image.asset(
                          'assets/images/works.png',
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                      hSpacing(hDimen(20)),
                      Text(
                        'FAQ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: hDimen(18),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              vSpacing(hDimen(20)),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const PrivacyPolicy()),
                  );
                },
                child: Container(
                  height: hDimen(60),
                  padding: EdgeInsets.only(
                    left: hDimen(20),
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E2126),
                    border: Border.all(
                      color: const Color(0xFF2A2A36),
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(hDimen(15)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: hDimen(25),
                        width: hDimen(25),
                        child: Image.asset(
                          'assets/images/policy.png',
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                      hSpacing(hDimen(20)),
                      Text(
                        'Policies',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: hDimen(18),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              Container(
                margin: EdgeInsets.only(bottom: hDimen(35)),
                child: GestureDetector(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/images/logout.png',
                        width: hDimen(25),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Logout',
                            style: TextStyle(
                              color: const Color(0xFFFF1E1E),
                              fontSize: hDimen(16),
                            ),
                          ),
                          Text(
                            'Version 1.0.0',
                            style: TextStyle(
                              color: const Color(0xFF92A4AC),
                              fontSize: hDimen(16),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  onTap: () {
                    logout();
                  },
                ),
              ),

              Container(
                margin: EdgeInsets.only(bottom: hDimen(95)),
                child: GestureDetector(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Delete Account',
                            style: TextStyle(
                              color: const Color(0xFFFF1E1E),
                              fontSize: hDimen(16),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  onTap: () {
                    _delete(context);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _delete(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: const Text('Do you really want to delete your account?'),
            content: const Text('It will delete all corresponding data to your account and this cation cannot be undone.'),
            actions: [
              // The "Yes" button
              TextButton(
                  onPressed: () {
                    // Remove the box

                    deleteAcoount();
                    // Close the dialog
                    Navigator.of(context).pop();
                  },
                  child: const Text('DELETE')),
              TextButton(
                  onPressed: () {
                    // Close the dialog
                    Navigator.of(context).pop();
                  },
                  child: const Text('CANCEL'))
            ],
          );
        });
  }

  deleteAcoount() async {
    EasyLoading.show(status: 'loading...');
    var httpClient = HttpService();
    var resp = await httpClient.post(generateUrl('close-account'), body: {
    });
    if (resp.statusCode == 200) {
      final body = jsonDecode(resp.body);
      print(body);
      showToast(message: body['message']);
      logout();
    } else {
      showToast(message: 'Oops! Something went wrong.');
    }
    EasyLoading.dismiss();
  }

}
