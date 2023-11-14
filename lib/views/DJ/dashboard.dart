import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:music/views/user_selection.dart';

import '../../notificationservice/local_notification_service.dart';
import '../../utils/app_dimen.dart';
import '../../utils/common.dart';
import '../../utils/http_service.dart';
import '../../utils/shared_preference.dart';
import '../../utils/store.dart';
import '../widget/more.dart';
import '../widget/request.dart';
import 'dj_profile.dart';
import 'dj_stat_screen.dart';
import 'dj_venues.dart';

class DJDashboard extends StatefulWidget {
  const DJDashboard({Key? key}) : super(key: key);
  @override
  _DJDashboardState createState() => _DJDashboardState();
}

class _DJDashboardState extends State<DJDashboard> {
  String _email = '';
  String _name = '';
  List<Widget> pages = [
    const RequestScreen(),
    const DjStatScreen(),
    //MyStats(),
    const DjProfile(),
    const MoreScreen(),
  ];
  int pageIndex = 0;

  @override
  void initState() {
    super.initState();

    // 1. This method call when app in terminated state and you get a notification
    // when you click on notification app open from terminated state and you can get notification data in this method

    FirebaseMessaging.instance.getInitialMessage().then(
      (message) {
        print("FirebaseMessaging.instance.getInitialMessage");
        if (message != null) {
          print("New Notification");
          // switch (message.data['_id']) {
          //   case 'request_song':
          //      Navigator.of(context).push(
          //     MaterialPageRoute(
          //       builder: (context) => DjVenues(
          //           //  id: message.data['_id'],
          //           ),
          //     ),
          //   );
          //     break;
          //   case 'accept_song':
          //      Navigator.of(context).push(
          //     MaterialPageRoute(
          //       builder: (context) => DjVenues(
          //           //  id: message.data['_id'],
          //           ),
          //     ),
          //   );
          //     break;
          //   case 'reject_song':
          //      Navigator.of(context).push(
          //     MaterialPageRoute(
          //       builder: (context) => DjVenues(
          //           //  id: message.data['_id'],
          //           ),
          //     ),
          //   );
          //     break;
          //   case 'request_for_vote_song':
          //      Navigator.of(context).push(
          //     MaterialPageRoute(
          //       builder: (context) => DjVenues(
          //           //  id: message.data['_id'],
          //           ),
          //     ),
          //   );
          //     break;
          //   case 'rvote_for_song':
          //      Navigator.of(context).push(
          //     MaterialPageRoute(
          //       builder: (context) => DjVenues(
          //           //  id: message.data['_id'],
          //           ),
          //     ),
          //   );
          //     break;
          //      default:
          //      determinePage();
          // }
          // if (message.data['_id'] != null) {
          //   Navigator.of(context).push(
          //     MaterialPageRoute(
          //       builder: (context) => DjVenues(
          //           //  id: message.data['_id'],
          //           ),
          //     ),
          //   );
          // }
        }
      },
    );

    // 2. This method only call when App in forground it mean app must be opened
    FirebaseMessaging.onMessage.listen(
      (message) {
        print("FirebaseMessaging.onMessage.listen");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data11 ${message.data['_id']}");
          // if (message.data['_id'] != null) {
          //   Navigator.of(context).push(
          //     MaterialPageRoute(
          //       builder: (context) => DjVenues(
          //           //  id: message.data['_id'],
          //           ),
          //     ),
          //   );
          // }
          // switch (message.data['_id']) {
          //   case 'request_song':
          //      Navigator.of(context).push(
          //     MaterialPageRoute(
          //       builder: (context) => DjVenues(
          //           //  id: message.data['_id'],
          //           ),
          //     ),
          //   );
          //     break;
          //   case 'accept_song':
          //      Navigator.of(context).push(
          //     MaterialPageRoute(
          //       builder: (context) => DjVenues(
          //           //  id: message.data['_id'],
          //           ),
          //     ),
          //   );
          //     break;
          //   case 'reject_song':
          //      Navigator.of(context).push(
          //     MaterialPageRoute(
          //       builder: (context) => DjVenues(
          //           //  id: message.data['_id'],
          //           ),
          //     ),
          //   );
          //     break;
          //   case 'request_for_vote_song':
          //      Navigator.of(context).push(
          //     MaterialPageRoute(
          //       builder: (context) => DjVenues(
          //           //  id: message.data['_id'],
          //           ),
          //     ),
          //   );
          //     break;
          //   case 'rvote_for_song':
          //      Navigator.of(context).push(
          //     MaterialPageRoute(
          //       builder: (context) => DjVenues(
          //           //  id: message.data['_id'],
          //           ),
          //     ),
          //   );
          //     break;
          //      default:
          //      determinePage();
          // }
          LocalNotificationService.createanddisplaynotification(message);
        }
      },
    );

    // 3. This method only call when App in background and not terminated(not closed)
    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) {
        print("FirebaseMessaging.onMessageOpenedApp.listen");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);

          // switch (message.data['_id']) {
          //   case 'request_song':
          //      Navigator.of(context).push(
          //     MaterialPageRoute(
          //       builder: (context) => DjVenues(
          //           //  id: message.data['_id'],
          //           ),
          //     ),
          //   );
          //     break;
          //   case 'accept_song':
          //      Navigator.of(context).push(
          //     MaterialPageRoute(
          //       builder: (context) => DjVenues(
          //           //  id: message.data['_id'],
          //           ),
          //     ),
          //   );
          //     break;
          //   case 'reject_song':
          //      Navigator.of(context).push(
          //     MaterialPageRoute(
          //       builder: (context) => DjVenues(
          //           //  id: message.data['_id'],
          //           ),
          //     ),
          //   );
          //     break;
          //   case 'request_for_vote_song':
          //      Navigator.of(context).push(
          //     MaterialPageRoute(
          //       builder: (context) => DjVenues(
          //           //  id: message.data['_id'],
          //           ),
          //     ),
          //   );
          //     break;
          //   case 'rvote_for_song':
          //      Navigator.of(context).push(
          //     MaterialPageRoute(
          //       builder: (context) => DjVenues(
          //           //  id: message.data['_id'],
          //           ),
          //     ),
          //   );
          //     break;
          //      default:
          //      determinePage();
          // }

          // if (message.data['_id'] != null) {
          //   Navigator.of(context).push(
          //     MaterialPageRoute(
          //       builder: (context) => DjVenues(
          //           //  id: message.data['_id'],
          //           ),
          //     ),
          //   );
          // }
          print("message.data22 ${message.data['_id']}");
        }
      },
    );
    fetchUser();
    fetchconfig();
  }

  Future<dynamic> onSelectNotification(payload) async {
    Map<String, dynamic> action = jsonDecode(payload);
    _handleMessage(action);
  }

  // Future<void> setupInteractedMessage() async {
  //   await FirebaseMessaging.instance
  //       .getInitialMessage()
  //       .then((value) => _handleMessage(value != null ? value.data : <String,>{}));
  // }

  void _handleMessage(Map<String, dynamic> data) {
    if (data['redirect'] == "product") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const DjVenues(
                  // message: data['message']
                  )));
    } else if (data['redirect'] == "product_details") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const DjVenues(
                  // message: data['message']
                  )));
    }
  }
    fetchconfig() async {
   SharedPreference.saveStringPreference('FAQ', 'http://52.6.237.5/webview/faq-dj');
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

  

  fetchUser() async {
    var user = await Store.getUser();
    print(user);

    if (user != null) {
      setState(() {
        _email = user['email'] ?? 'Signed Up using mobile';
        _name = user['name'];
      });
    }
  }

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
                      ))),
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
                  ? 'assets/images/request.png'
                  : 'assets/images/request_unselected.png',
              isSelected: pageIndex == 0 ? true : false,
              itemName: 'Requests',
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
    /*return WillPopScope(
      child: Scaffold(
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
                      height: hDimen(350),
                    ),
                    Center(
                        child: Text(
                      'Hi $_name',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          fontFamily: "Rajdhani"),
                    )),
                    Center(
                        child: Text(
                      _email,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          fontFamily: "Rajdhani"),
                    )),
                    Center(
                      child: ElevatedButton(
                          onPressed: logout, child: const Text('LOGOUT')),
                    )
                  ])))),
      onWillPop: () async => false,
    );*/
  }
}
