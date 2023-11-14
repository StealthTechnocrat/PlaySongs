
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:music/notificationservice/local_notification_service.dart';
import 'package:music/views/DJ/requested_songs.dart';
import 'package:music/views/MusicLover/requested_songs.dart';
import 'package:music/views/notifications_list.dart';
import 'package:music/views/splash.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'locator.dart';
import 'package:flutter_stripe/flutter_stripe.dart';


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}
  Future<void> getDeviceTokenToSendNotification() async {
    final FirebaseMessaging fcm = FirebaseMessaging.instance;
    final token = await fcm.getToken();
    var deviceTokenToSendPushNotification = token.toString();
    print("Token Value $deviceTokenToSendPushNotification");
  }

// AndroidNotificationChannel? channel;

// FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
// late FirebaseMessaging messaging;

// final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

Future<void> backgroundHandler(RemoteMessage message) async {
  print(message.data.toString());
  //print(message.notification!.title);
}
void main()async {
WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
   await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);

WidgetsFlutterBinding.ensureInitialized();
//Stripe.publishableKey = "pk_test_51LSL8zAgXO63Dg6vsaqylMQ6wEaELRwo4oLLAogtO7ypdByDm4wIDXPScdmA5ilMvGzioo0pMQSYemBOKIt25E6d006WTiUNpH";
Stripe.publishableKey = "pk_live_51LSL8zAgXO63Dg6voPfCDGvAOVUFYjmcXywUINjRdf2qUzxiqZLVYnT8nW6pHCpiVdJbmrNGb60f04ml6Yjqh4Pk00DfiK6PAB";
await Stripe.instance.applySettings();

  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({ Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LocalNotificationService.initialize(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Rajdhani',
        primarySwatch: Colors.blue,
      ),
      home: const Splash(),
      builder: EasyLoading.init(),
      routes: {
        '/RequestedSongsMusicLover': (context) => const RequestedSongs(),
        '/RequestedDjSongs': (context) => const RequestedDjSongs(),
        '/NotificationList': (context) => const NotificationsList(),

      },
    );
  }
}
