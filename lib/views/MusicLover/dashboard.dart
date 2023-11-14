import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:music/utils/app_dimen.dart';
import 'package:music/utils/common.dart';
import 'package:music/views/widget/djs.dart';
import 'package:music/views/widget/more.dart';
import 'package:music/views/widget/profile.dart';

import '../../notificationservice/local_notification_service.dart';
import '../../utils/http_service.dart';
import '../../utils/shared_preference.dart';
import 'my _stats.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<Widget> pages = [
    const DjScreen(),
    //StatScreen(),
    // PlaceVisited(),
    const MyStats(),
    //RequestedSongs(),
    const ProfileScreen(),
    const MoreScreen(),
  ];
  int pageIndex = 0;

  Widget bottomItems({
    String imgPath = '',
    String itemName = '',
    bool isSelected = false,
    Function? onSelected,
  }) {
    return GestureDetector(
      onTap: () {
        onSelected!();
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          itemName == 'DJs'
              ? SizedBox(
                  width: hDimen(40),
                  child: Stack(
                    children: [
                      SizedBox(
                          height: hDimen(30),
                          width: hDimen(30),
                          child: Image(
                            image: AssetImage(imgPath),
                            height: hDimen(30),
                            width: hDimen(30),
                            fit: BoxFit.contain,
                          )),
                      Align(
                        alignment: Alignment.topRight,
                        child: SizedBox(
                          height: hDimen(17),
                          child: Image.asset(
                            'assets/images/music.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : SizedBox(
                  width: hDimen(40),
                  child: SizedBox(
                      height: hDimen(30),
                      width: hDimen(30),
                      child: Image(
                        image: AssetImage(imgPath),
                        height: hDimen(30),
                        width: hDimen(30),
                        fit: BoxFit.contain,
                      )),
                ),
          vSpacing(hDimen(2)),
          Text(
            itemName,
            style: TextStyle(
              color: isSelected ? const Color(0xFF1AA8E6) : const Color(0xFF566B75),
              fontSize: hDimen(15),
            ),
          )
        ],
      ),
    );
  }

  Widget CustomBottomSheet() {
    return Container(
      height: hDimen(75),
      padding: EdgeInsets.only(
        left: hDimen(15),
        right: hDimen(15),
      ),
      color: const Color(0xFF1D1D1D),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          bottomItems(
              imgPath: pageIndex == 0
                  ? 'assets/images/Group 3.png'
                  : 'assets/images/Group 3_Unselected.png',
              isSelected: pageIndex == 0 ? true : false,
              itemName: 'DJs',
              onSelected: () {
                setState(() {
                  pageIndex = 0;
                });
              }),
          bottomItems(
              imgPath: pageIndex == 1
                  ? 'assets/images/stat_selected.png'
                  : 'assets/images/stats.png',
              isSelected: pageIndex == 1 ? true : false,
              itemName: 'My Stats',
              onSelected: () {
                setState(() {
                  pageIndex = 1;
                });
              }),
          bottomItems(
              imgPath: pageIndex == 2
                  ? 'assets/images/user_selected.png'
                  : 'assets/images/user2.png',
              isSelected: pageIndex == 2 ? true : false,
              itemName: 'My Profile',
              onSelected: () {
                setState(() {
                  pageIndex = 2;
                });
              }),
          bottomItems(
              imgPath: pageIndex == 3
                  ? 'assets/images/more_selected.png'
                  : 'assets/images/more.png',
              isSelected: pageIndex == 3 ? true : false,
              itemName: 'More',
              onSelected: () {
                setState(() {
                  pageIndex = 3;
                });
              }),
        ],
      ),
    );
  }

  fetchconfig() async {


    EasyLoading.show(status: 'loading...');
    var httpClient = HttpService();
    var resp = await httpClient.get(
      generateUrl('config'),
    );
    if (resp.statusCode == 200) {
      final body = jsonDecode(resp.body);
      print(body);
      if (body['status'] == true) {
        // showToast(message: "Data fetched");
        var setting = body['settings'];
        var pages = body['pages'];
        print(pages);
        for (int i = 0; i < pages.length; i++) {
          // print(pages[0]['url']);
          SharedPreference.saveStringPreference('ABOUT_US', pages[0]['url']);
        }
      //  SharedPreference.saveStringPreference('FAQ', pages[1]['url']);
        SharedPreference.saveStringPreference(
            'TERMS_OF_SERVICE', pages[1]['url']);
        SharedPreference.saveStringPreference(
            'PRIVACY_POLICY', pages[2]['url']);
        SharedPreference.saveStringPreference('FAQ', pages[3]['url']);
        SharedPreference.saveStringPreference(
            'TIPS_TRANSACTION', setting[5]['value'].toString());
        print('TIPS_TRANSACTION ${setting[5]['value']}');
      } else {
        showToast(message: body['message']);
      }
    } else {
      showToast(message: 'Oops! Something went wrong.');
    }
    EasyLoading.dismiss();
  }

  @override
  void initState() {
    super.initState();

    FirebaseMessaging.instance.getInitialMessage().then(
      (message) {
        print("FirebaseMessaging.instance.getInitialMessage");
        if (message != null) {
          print("New Notification");
        
       
        }
        
      },
    );

    FirebaseMessaging.onMessage.listen(
      (message) {
        print("FirebaseMessaging.onMessage.listen");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data11 ${message.data['_id']}");
        
          
          LocalNotificationService.createanddisplaynotification(message);
        }
      },
    );

    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) {
        print("FirebaseMessaging.onMessageOpenedApp.listen");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
       
          print("message.data22 ${message.data['_id']}");
        }
      },
    );
    

    fetchconfig();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.black,
        body: pages[pageIndex],
        bottomSheet: CustomBottomSheet(),
      ),
      onWillPop: () async => false,
    );
  }
}
