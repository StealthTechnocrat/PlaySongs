import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:music/utils/store.dart';
import 'package:music/views/DJ/dashboard.dart';
import 'package:music/views/MusicLover/dashboard.dart' as music;
import 'dart:async';

import 'package:music/views/welcome.dart';


class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  String deviceTokenToSendPushNotification = '';
  @override
  initState() {
    determinePage();
    super.initState();

    // // 1. This method call when app in terminated state and you get a notification
    // // when you click on notification app open from terminated state and you can get notification data in this method

    // FirebaseMessaging.instance.getInitialMessage().then(
    //   (message) {
    //     print("FirebaseMessaging.instance.getInitialMessage");
    //     if (message != null) {
    //       print("New Notification");
    //       // switch (message.data['_id']) {
    //       //   case 'request_song':
    //       //      Navigator.of(context).push(
    //       //     MaterialPageRoute(
    //       //       builder: (context) => DjVenues(
    //       //           //  id: message.data['_id'],
    //       //           ),
    //       //     ),
    //       //   );
    //       //     break;
    //       //   case 'accept_song':
    //       //      Navigator.of(context).push(
    //       //     MaterialPageRoute(
    //       //       builder: (context) => DjVenues(
    //       //           //  id: message.data['_id'],
    //       //           ),
    //       //     ),
    //       //   );
    //       //     break;
    //       //   case 'reject_song':
    //       //      Navigator.of(context).push(
    //       //     MaterialPageRoute(
    //       //       builder: (context) => DjVenues(
    //       //           //  id: message.data['_id'],
    //       //           ),
    //       //     ),
    //       //   );
    //       //     break;
    //       //   case 'request_for_vote_song':
    //       //      Navigator.of(context).push(
    //       //     MaterialPageRoute(
    //       //       builder: (context) => DjVenues(
    //       //           //  id: message.data['_id'],
    //       //           ),
    //       //     ),
    //       //   );
    //       //     break;
    //       //   case 'rvote_for_song':
    //       //      Navigator.of(context).push(
    //       //     MaterialPageRoute(
    //       //       builder: (context) => DjVenues(
    //       //           //  id: message.data['_id'],
    //       //           ),
    //       //     ),
    //       //   );
    //       //     break;
    //       //      default:
    //       //      determinePage();
    //       // }
    //       // if (message.data['_id'] != null) {
    //       //   Navigator.of(context).push(
    //       //     MaterialPageRoute(
    //       //       builder: (context) => DjVenues(
    //       //           //  id: message.data['_id'],
    //       //           ),
    //       //     ),
    //       //   );
    //       // }
    //     }
    //   },
    // );

    // // 2. This method only call when App in forground it mean app must be opened
    // FirebaseMessaging.onMessage.listen(
    //   (message) {
    //     print("FirebaseMessaging.onMessage.listen");
    //     if (message.notification != null) {
    //       print(message.notification!.title);
    //       print(message.notification!.body);
    //       print("message.data11 ${message.data['_id']}");
    //       // if (message.data['_id'] != null) {
    //       //   Navigator.of(context).push(
    //       //     MaterialPageRoute(
    //       //       builder: (context) => DjVenues(
    //       //           //  id: message.data['_id'],
    //       //           ),
    //       //     ),
    //       //   );
    //       // }
    //       // switch (message.data['_id']) {
    //       //   case 'request_song':
    //       //      Navigator.of(context).push(
    //       //     MaterialPageRoute(
    //       //       builder: (context) => DjVenues(
    //       //           //  id: message.data['_id'],
    //       //           ),
    //       //     ),
    //       //   );
    //       //     break;
    //       //   case 'accept_song':
    //       //      Navigator.of(context).push(
    //       //     MaterialPageRoute(
    //       //       builder: (context) => DjVenues(
    //       //           //  id: message.data['_id'],
    //       //           ),
    //       //     ),
    //       //   );
    //       //     break;
    //       //   case 'reject_song':
    //       //      Navigator.of(context).push(
    //       //     MaterialPageRoute(
    //       //       builder: (context) => DjVenues(
    //       //           //  id: message.data['_id'],
    //       //           ),
    //       //     ),
    //       //   );
    //       //     break;
    //       //   case 'request_for_vote_song':
    //       //      Navigator.of(context).push(
    //       //     MaterialPageRoute(
    //       //       builder: (context) => DjVenues(
    //       //           //  id: message.data['_id'],
    //       //           ),
    //       //     ),
    //       //   );
    //       //     break;
    //       //   case 'rvote_for_song':
    //       //      Navigator.of(context).push(
    //       //     MaterialPageRoute(
    //       //       builder: (context) => DjVenues(
    //       //           //  id: message.data['_id'],
    //       //           ),
    //       //     ),
    //       //   );
    //       //     break;
    //       //      default:
    //       //      determinePage();
    //       // }
    //       LocalNotificationService.createanddisplaynotification(message);
    //     }
    //   },
    // );

    // // 3. This method only call when App in background and not terminated(not closed)
    // FirebaseMessaging.onMessageOpenedApp.listen(
    //   (message) {
    //     print("FirebaseMessaging.onMessageOpenedApp.listen");
    //     if (message.notification != null) {
    //       print(message.notification!.title);
    //       print(message.notification!.body);

    //       // switch (message.data['_id']) {
    //       //   case 'request_song':
    //       //      Navigator.of(context).push(
    //       //     MaterialPageRoute(
    //       //       builder: (context) => DjVenues(
    //       //           //  id: message.data['_id'],
    //       //           ),
    //       //     ),
    //       //   );
    //       //     break;
    //       //   case 'accept_song':
    //       //      Navigator.of(context).push(
    //       //     MaterialPageRoute(
    //       //       builder: (context) => DjVenues(
    //       //           //  id: message.data['_id'],
    //       //           ),
    //       //     ),
    //       //   );
    //       //     break;
    //       //   case 'reject_song':
    //       //      Navigator.of(context).push(
    //       //     MaterialPageRoute(
    //       //       builder: (context) => DjVenues(
    //       //           //  id: message.data['_id'],
    //       //           ),
    //       //     ),
    //       //   );
    //       //     break;
    //       //   case 'request_for_vote_song':
    //       //      Navigator.of(context).push(
    //       //     MaterialPageRoute(
    //       //       builder: (context) => DjVenues(
    //       //           //  id: message.data['_id'],
    //       //           ),
    //       //     ),
    //       //   );
    //       //     break;
    //       //   case 'rvote_for_song':
    //       //      Navigator.of(context).push(
    //       //     MaterialPageRoute(
    //       //       builder: (context) => DjVenues(
    //       //           //  id: message.data['_id'],
    //       //           ),
    //       //     ),
    //       //   );
    //       //     break;
    //       //      default:
    //       //      determinePage();
    //       // }

    //       // if (message.data['_id'] != null) {
    //       //   Navigator.of(context).push(
    //       //     MaterialPageRoute(
    //       //       builder: (context) => DjVenues(
    //       //           //  id: message.data['_id'],
    //       //           ),
    //       //     ),
    //       //   );
    //       // }
    //       print("message.data22 ${message.data['_id']}");
    //     }
    //   },
    // );
    // //determinePage();
  }

  determinePage() async {
    var user = await Store.getUser();
    print(user);
    if (user != null && user['type'] == 'dj') {
      Timer(
          const Duration(seconds: 3),
          () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DJDashboard(),
                    maintainState: false,
                  ),
                ),);
    } else if (user != null && user['type'] == 'user') {
      Timer(
          const Duration(seconds: 3),
          () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const music.Dashboard(),
                    maintainState: false,
                  ),
                ),);
    } else {
      Timer(
          const Duration(seconds: 3),
          () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Welcome(
                      isMore: false,
                    ),
                    maintainState: false,
                  ),
                ),);
    }
  }

  Future<void> getDeviceTokenToSendNotification() async {
    final FirebaseMessaging fcm = FirebaseMessaging.instance;
    final token = await fcm.getToken();
    deviceTokenToSendPushNotification = token.toString();
    print("Token Value $deviceTokenToSendPushNotification");
  }

  @override
  Widget build(BuildContext context) {
    getDeviceTokenToSendNotification();
    return Scaffold(
        body: Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/splash_background.png'),
              fit: BoxFit.cover)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Container(
              child: const Image(
                image: AssetImage("assets/images/splash_logo.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
