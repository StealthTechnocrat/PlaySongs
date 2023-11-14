import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:address_search_field/address_search_field.dart' as AddressPlace;
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:intl/intl.dart';
import 'package:music/utils/app_dimen.dart';
import 'package:music/utils/common.dart';
import 'package:music/utils/scanner.dart';
import 'package:music/views/MusicLover/dj_details.dart';
import '../../models/user_model.dart';
import '../../utils/http_service.dart';
import 'package:address_search_field/address_search_field.dart';

import '../../utils/store.dart';
import '../notifications_list.dart';

class DjScreen extends StatefulWidget {
  const DjScreen({Key? key}) : super(key: key);

  @override
  State<DjScreen> createState() => _DjScreenState();
}

class _DjScreenState extends State<DjScreen> {
  TextEditingController typeIn = TextEditingController(text: '');
  TextEditingController location = TextEditingController(text: '');
  TextEditingController songName = TextEditingController(text: '');
  final geoMethods = GeoMethods(
    googleApiKey: 'AIzaSyDzK9yvhzt8Ytn8BA2NprlJzGRf018vkG0',
    language: 'en',
  );

  bool isRequest = false;
  bool isPay = false;
  var club;
  List djs = [];
  List allDJS = [];
  List openForVotes = [];
  var requested_dj;
  final double _sigmaX = 5.0; // from 0-10
  final double _sigmaY = 5.0; // from 0-10
  final double _opacity = 0.5; // from 0-1.0
  double latitude = 0.0;
  double longitude = 0.0;
  String transaction_key = '';
  int newNotification = 0;
  User? user;

  @override
  void initState() {
    super.initState();
    checkRunningEvent();
    getNotificationCount();
    fetchCreditBalance();
  }

  sendRequest() async {
    EasyLoading.show(status: 'loading...');
    var httpClient = HttpService();
    var resp = await httpClient.post(generateUrl('request-song'), body: {
      'dj_id': requested_dj['id'].toString(),
      'song': songName.text,
      'transaction_key': transaction_key,
      'type':'stripe'
    });
    if (resp.statusCode == 200) {
      final body = jsonDecode(resp.body);
      print(body);
      if (body['status']) {
        setState(() {
          isPay = false;
          isRequest = false;
          requested_dj = null;
          songName.text = '';
        });
      }
      showToast(message: body['message']);
    } else {
      print(resp.body.toString());
      showToast(message: 'Oops! Something went wrong.');
    }
    EasyLoading.dismiss();
  }

  sendRequestCredit() async {
    EasyLoading.show(status: 'loading...');
    var httpClient = HttpService();
    var resp = await httpClient.post(generateUrl('request-song'), body: {
      'dj_id': requested_dj['id'].toString(),
      'song': songName.text,
      'type':'credit'
    });
    if (resp.statusCode == 200) {
      final body = jsonDecode(resp.body);
      print(body);
      if (body['status']) {
        user?.creditBalance = body['credit_balance'];
        await Store.setUser2(user);
        setState(() {
          isPay = false;
          isRequest = false;
          requested_dj = null;
          songName.text = '';
        });
      }
      showToast(message: body['message']);
    } else {
      print(resp.body.toString());
      showToast(message: 'Oops! Something went wrong.');
    }
    EasyLoading.dismiss();
  }

  getNotificationCount() async {
    Uri uri = generateUrl('notification-count');
    var httpClient = HttpService();
    var resp = await httpClient.get(uri);
    if (resp.statusCode == 200) {
      final body = jsonDecode(resp.body);
      print('getNotificationCount $body');
      setState(() {
        newNotification = body['count'];
      });
    }
  }

  createPaymentIntent() async {
    EasyLoading.show(status: 'loading...');
    var httpClient = HttpService();
    var resp = await httpClient.post(generateUrl('make-payment'),
        body: {'amount': requested_dj['amount_per_request'].toString()});

    print(resp.body.toString());
    if (resp.statusCode == 200) {
      final body = jsonDecode(resp.body);
      if (body['status']) {
        await Stripe.instance.initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: body['payment_intent'],
          merchantDisplayName: 'DJ Play my Song',
          customerId: body['customer_stripe_id'],
          customerEphemeralKeySecret: body['emphemeral_key'],
          style: ThemeMode.dark,
        ));
        try {
          await Stripe.instance.presentPaymentSheet();
          setState(() {
            isPay = false;
            transaction_key = body['payment_intent'];
            // isRequest = false;
            // requested_dj = null;
            // songName.text = '';
          });

          sendRequest();
        } catch (e) {
          if (e is StripeException) {
            showToast(
                message: 'Error from Stripe: ${e.error.localizedMessage}');
          } else {
            log(e.toString());
            showToast(message: 'Something went wrong');
          }
          setState(() {
            isPay = false;
            isRequest = false;
            requested_dj = null;
            songName.text = '';
            transaction_key = '';
          });
        }
      }
    } else {
      showToast(message: 'Sorry! Can not process your payment at this moment');
    }
    EasyLoading.dismiss();
  }

  setAddress(address) {
    setState(() {
      latitude = address.coords.latitude;
      longitude = address.coords.longitude;
    });
  }

  void fetchCreditBalance() async {
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
  }

  checkRunningEvent() async {
    user = User.fromJson(await Store.getUser());
    EasyLoading.show(status: 'loading...');
    Uri uri = generateUrl('check-running-event');
    var httpClient = HttpService();
    var resp = await httpClient.get(uri);
    if (resp.statusCode == 200) {
      final body = jsonDecode(resp.body);
      print(body);
      if (body['status']) {
        setState(() {
          club = body['club'];
          isSearched = true;
          fetchDjs(club['id'].toString());
        });
      } else {
        reset();
      }
    } else {
      print(resp.body);
      showToast(message: 'Oops! Something went wrong.');
    }
    EasyLoading.dismiss();
  }

  searchClub() async {
    EasyLoading.show(status: 'loading...');
    Uri uri = generateUrl('search-club');
    final finalUri = uri.replace(queryParameters: {
      'name': typeIn.text,
      'lat': latitude.toString(),
      'lon': longitude.toString(),
    });
    var httpClient = HttpService();
    var resp = await httpClient.get(finalUri);
    if (resp.statusCode == 200) {
      final body = jsonDecode(resp.body);
      print(body);
      if (body['status']) {
        setState(() {
          club = body['club'];
          isSearched = true;
          fetchDjs(club['id'].toString());
        });
      } else {
        showToast(message: body['message']);
      }
    } else {
      showToast(message: 'Oops! Something went wrong.');
    }
    EasyLoading.dismiss();
  }

  fetchDjs(clubId) async {
    EasyLoading.show(status: 'loading...');
    Uri uri = generateUrl('djs');
    final finalUri = uri.replace(queryParameters: {
      'club_id': clubId,
    });
    var httpClient = HttpService();
    var resp = await httpClient.get(finalUri);
    if (resp.statusCode == 200) {
      final body = jsonDecode(resp.body);
      print(body);
      if (body['status']) {
        setState(() {
          djs = body['djs'];
          allDJS = body['djs'];
          openForVotes = body['open_for_votes'];
        });
      } else {
        showToast(message: body['message']);
      }
    } else {
      showToast(message: 'Oops! Something went wrong.');
    }
    EasyLoading.dismiss();
  }

  reset() {
    typeIn.text = '';
    location.text = '';
    djs.clear();
    allDJS.clear();
    setState(() {
      isSearched = false;
      club = null;
    });
  }

  castVote(int id, int status) async {
    EasyLoading.show(status: 'loading...');
    var httpClient = HttpService();
    var resp = await httpClient
        .post(generateUrl('make-payment'), body: {'amount': '1'});
    if (resp.statusCode == 200) {
      final body = jsonDecode(resp.body);
      if (body['status']) {
        await Stripe.instance.initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: body['payment_intent'],
          merchantDisplayName: 'DJ Play my Song',
          customerId: body['customer_stripe_id'],
          customerEphemeralKeySecret: body['emphemeral_key'],
          style: ThemeMode.dark,
        ));
        try {
          await Stripe.instance.presentPaymentSheet();
          var httpClient = HttpService();
          var resp = await httpClient.post(generateUrl('cast-vote'), body: {
            'request_id': id.toString(),
            'status': status.toString(),
            'transaction_key': body['payment_intent'],
          });
          if (resp.statusCode == 200) {
            final body = jsonDecode(resp.body);
            showToast(message: body['message']);
          }

          setState(() {
            openForVotes.removeWhere((item) => item['id'] == id);
          });
        } catch (e) {
          if (e is StripeException) {
            showToast(
                message: 'Error from Stripe: ${e.error.localizedMessage}');
          } else {
            log(e.toString());
            showToast(message: 'Something went wrong');
          }
        }
      }
    }
    EasyLoading.dismiss();
  }

  Widget songRequest() {
    return Container(
      height: hDimen(315),
      width: hDimen(280),
      padding: EdgeInsets.only(
        left: hDimen(15),
        right: hDimen(15),
        top: hDimen(20),
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2126),
        borderRadius: BorderRadius.circular(hDimen(25)),
        border: Border.all(
          color: const Color(0xFF313131),
          width: 1,
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: _sigmaX, sigmaY: _sigmaY),
        child: Container(
          padding: const EdgeInsets.all(10.0),
          color: Colors.black.withOpacity(_opacity),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Request a Song',
                    style: TextStyle(
                      color: const Color(0xFF92A4AC),
                      fontSize: hDimen(17),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isRequest = false;
                      });
                    },
                    child: Image.asset(
                      'assets/images/cross.png',
                      width: hDimen(25),
                    ),
                  ),
                ],
              ),
              vSpacing(hDimen(10)),
              SizedBox(
                height: hDimen(45),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: hDimen(45),
                      child: requested_dj != null
                          ? Image.network(
                              requested_dj['avatar'],
                              fit: BoxFit.cover,
                            )
                          : const SizedBox.shrink(),
                    ),
                    hSpacing(hDimen(10)),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          requested_dj != null ? requested_dj['name'] : '',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: hDimen(16),
                          ),
                        ),
                        Text(
                          club != null ? club['name'] : '',
                          style: TextStyle(
                            color: const Color(0xFF5587D2),
                            fontSize: hDimen(14),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              vSpacing(hDimen(15)),
              Padding(
                padding: EdgeInsets.only(
                  left: hDimen(15),
                  right: hDimen(15),
                ),
                child: const Text(
                  "Song Name",
                  style: TextStyle(
                      color: Color(0xFF92A4AC),
                      fontFamily: "Rajdhani",
                      fontSize: 16),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: hDimen(15), right: hDimen(15)),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TextField(
                    controller: songName,
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
                          'assets/images/audio.png',
                          width: 10,
                          height: 10,
                          fit: BoxFit.contain,
                        ),
                      ),
                      hintText: "Type in",
                      hintStyle: const TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
                        fontFamily: "Rajdhani",
                      ),
                    ),
                  ),
                ),
              ),
              vSpacing(hDimen(15)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Amount deducted will be ',
                    style: TextStyle(
                      color: const Color(0xFF92A4AC),
                      fontSize: hDimen(16),
                    ),
                  ),
                  Text(
                    '\$ ${requested_dj != null ? requested_dj['amount_per_request'] : ''}',
                    style: TextStyle(
                      color: const Color(0xFFFBBB16),
                      fontSize: hDimen(16),
                    ),
                  )
                ],
              ),
              vSpacing(hDimen(1)),
              Text(
                '',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: hDimen(16),
                ),
              ),
              vSpacing(hDimen(5)),
              GestureDetector(
                onTap: () {
                  if (isPay) {
                    if (songName.text.isEmpty) {
                      showToast(message: 'Please enter a song name');
                      return;
                    }
                    sendRequest();
                  } else {
                    if (songName.text.isEmpty) {
                      showToast(message: 'Please enter a song name');
                      return;
                    }
                    if(user != null && user!.creditBalance != null && user!.creditBalance! > 0) {
                        sendRequestCredit();
                    } else {
                        createPaymentIntent();
                    }
                  }
                },
                child: Center(
                  child: Container(
                    height: hDimen(45),
                    width: hDimen(140),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1AA8E6),
                      borderRadius: BorderRadius.circular(hDimen(25)),
                    ),
                    child: Center(
                      child: Text(
                        isPay ? 'SEND REQUEST' : 'MAKE PAYMENT',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: hDimen(16),
                            fontWeight: FontWeight.bold),
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

  Widget searchDjLocation() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      padding: EdgeInsets.only(
        top: hDimen(60),
        right: hDimen(20),
        left: hDimen(15),
      ),
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/splash_background.png'),
            fit: BoxFit.cover),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(
                flex: 1,
              ),
              Text(
                'Music Lover',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: hDimen(22),
                ),
              ),
              const Spacer(),
              // SizedBox(
              //     width: hDimen(40),
              //     height: hDimen(33),
              //     child: InkWell(
              //       onTap: () {
              //         Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //               builder: (context) => const NotificationsList()),
              //         );
              //       },
              //       child: Stack(
              //         children: [
              //           SizedBox(
              //               height: hDimen(33),
              //               child: Image.asset(
              //                 'assets/images/notification.png',
              //                 fit: BoxFit.cover,
              //               )),
              //           Padding(
              //             padding: EdgeInsets.only(top: hDimen(5), left: 2),
              //             child: Align(
              //               alignment: Alignment.topRight,
              //               child: Container(
              //                 height: hDimen(25),
              //                 width: hDimen(25),
              //                 decoration: BoxDecoration(
              //                   color: Color(0xFFFBBB16),
              //                   shape: BoxShape.circle,
              //                 ),
              //                 child: Center(
              //                   child: Text(
              //                     '5',
              //                     style: TextStyle(
              //                         color: Colors.black,
              //                         fontSize: hDimen(16)),
              //                   ),
              //                 ),
              //               ),
              //             ),
              //           )
              //         ],
              //       ),
              //     )),
            ],
          ),
          const Spacer(),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Please enter the details of the Event',
              style: TextStyle(
                color: const Color(0xFF92A4AC),
                fontSize: hDimen(16),
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: EdgeInsets.only(
              left: hDimen(60),
              right: hDimen(60),
            ),
            child: const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Venue *",
                style: TextStyle(
                  color: Color(0xFF92A4AC),
                  fontFamily: "Rajdhani",
                  fontSize: 16,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: hDimen(60), right: hDimen(60)),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextField(
                controller: typeIn,
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
                        'assets/images/venue.png',
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
          Padding(
            padding: EdgeInsets.only(
                left: hDimen(60), right: hDimen(60), top: hDimen(20)),
            child: const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Location *",
                style: TextStyle(
                    color: Color(0xFF92A4AC),
                    fontFamily: "Rajdhani",
                    fontSize: 16),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: hDimen(60), right: hDimen(60)),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextField(
                controller: location,
                onTap: () => showDialog(
                    context: context,
                    builder: (BuildContext context) => AddressSearchDialog(
                          geoMethods: geoMethods,
                          controller: location,
                          onDone: (AddressPlace.Address address) =>
                              {setAddress(address)},
                        )),
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
                        'assets/images/location.png',
                        width: 10,
                        height: 10,
                        fit: BoxFit.contain,
                      ),
                    ),
                    hintText: "Select",
                    hintStyle: const TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontFamily: "Rajdhani",
                    )),
              ),
            ),
          ),
          vSpacing(hDimen(30)),
          Padding(
            padding: EdgeInsets.only(
              left: hDimen(60),
              right: hDimen(60),
            ),
            child: GestureDetector(
              onTap: () {
                searchClub();
              },
              child: Container(
                height: hDimen(55),
                decoration: BoxDecoration(
                  color: const Color(0xFF1AA8E6),
                  borderRadius: BorderRadius.circular(hDimen(25)),
                ),
                child: Center(
                  child: Text(
                    'START SENDING REQUESTS',
                    style: TextStyle(
                        color: const Color(0xFF1E2126),
                        fontSize: hDimen(16),
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
          const Spacer(
            flex: 2,
          ),
        ],
      ),
    );
  }

  Widget DjItem({
    String imgPath = '',
    String name = '',
    String detail = '',
    String price = '',
    Function? onRequest,
    Function? onDetails,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: hDimen(10)),
      child: Container(
        height: hDimen(110),
        padding: EdgeInsets.only(
          left: hDimen(0),
          top: hDimen(0),
          bottom: hDimen(0),
          right: hDimen(10),
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF1E2126),
          border: Border.all(
              color: const Color(
                0xFF2A2A36,
              ),
              width: 1.5),
          borderRadius: BorderRadius.circular(
            hDimen(15),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(hDimen(15)),
                        bottomLeft: Radius.circular(hDimen(15)))),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(hDimen(15)),
                      bottomLeft: Radius.circular(hDimen(15))),
                  child: Image.network(
                    imgPath,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            hSpacing(10),
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: hDimen(16),
                    ),
                  ),
                  vSpacing(hDimen(5)),
                  Text(
                    detail.length > 40
                        ? '${detail.substring(0, 40)}...'
                        : detail,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: hDimen(13),
                    ),
                  ),
                  vSpacing(hDimen(5)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '\$ $price',
                        style: TextStyle(
                          color: const Color(0xFFFBBB16),
                          fontSize: hDimen(14),
                        ),
                      ),
                      Text(
                        '/request',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: hDimen(14),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      onRequest!();
                    },
                    child: Container(
                      height: hDimen(30),
                      width: hDimen(90),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(hDimen(15)),
                        color: const Color(0xFF1AA8E6),
                      ),
                      child: Center(
                        child: Text(
                          'REQUEST',
                          style: TextStyle(
                              color: const Color(0xFF1E2126),
                              fontSize: hDimen(16),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  vSpacing(hDimen(10)),
                  GestureDetector(
                    onTap: () {
                      onDetails!();
                    },
                    child: Container(
                      height: hDimen(30),
                      width: hDimen(90),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(hDimen(15)),
                        color: const Color(0xFF1E2126),
                        border: Border.all(
                          color: const Color(0xFF1AA8E6),
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'TIP’s/BIO',
                          style: TextStyle(
                            color: const Color(0xFF1AA8E6),
                            fontSize: hDimen(16),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget VoteItem({
    String title = 'All I wanna do is have some fun ...',
    String dj = 'DJ Tiessa',
    String djPrice = '0',
    String time = '9:15 pm',
    Function? onUp,
    Function? onDown,
        Function? skip,

  }) {
    String detail = '$dj | Fees: \$ $djPrice';
    return Padding(
      padding: EdgeInsets.only(bottom: hDimen(10)),
      child: Container(
        height: hDimen(80),
        padding: EdgeInsets.only(
          left: hDimen(3),
          top: hDimen(3),
          bottom: hDimen(3),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: _sigmaX, sigmaY: _sigmaY),
          child: Container(
            color: Colors.black.withOpacity(_opacity),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: Image.asset(
                    'assets/images/audio_y.png',
                    fit: BoxFit.cover,
                  ),
                ),
                hSpacing(5),
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: hDimen(16),
                        ),
                      ),
                      Text(
                        detail,
                        style: TextStyle(
                          color: const Color(0xFF92A4AC),
                          fontSize: hDimen(13),
                        ),
                      ),
                      vSpacing(2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              skip!();
                            },
                            child: Container(
                              // height: hDimen(30),
                              // width: hDimen(40),
                              // decoration: BoxDecoration(
                              //   color: Color(0xFFFF1E1E),
                              //   borderRadius: BorderRadius.circular(hDimen(12)),
                              // ),
                              child: Center(
                                child: Image.asset(
                                  'assets/images/cast.png',
                                  width: hDimen(65),
                                ),
                              ),
                            ),
                          ),
                          hSpacing(hDimen(5)),
                          GestureDetector(
                            onTap: () {
                              onDown!();
                            },
                            child: Container(
                              height: hDimen(30),
                              width: hDimen(40),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF1E1E),
                                borderRadius: BorderRadius.circular(hDimen(12)),
                              ),
                              child: Center(
                                child: Image.asset(
                                  'assets/images/thumsDn.png',
                                  width: hDimen(25),
                                ),
                              ),
                            ),
                          ),
                          hSpacing(hDimen(10)),
                          GestureDetector(
                            onTap: () {
                              onUp!();
                            },
                            child: Container(
                              height: hDimen(30),
                              width: hDimen(40),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1AA8E6),
                                borderRadius: BorderRadius.circular(hDimen(12)),
                              ),
                              child: Center(
                                child: Image.asset(
                                  'assets/images/thumsUp.png',
                                  width: hDimen(25),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Text(
                  time,
                  style: TextStyle(
                    color: const Color(0xFFFBBB16),
                    fontSize: hDimen(16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool isSearched = false;

  Widget SearchedDjLocation() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/splash_background.png'),
            fit: BoxFit.cover),
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.only(
          top: hDimen(20),
          right: hDimen(20),
          left: hDimen(15),
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
                  'DJs',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: hDimen(24),
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  child: SizedBox(
                      width: hDimen(40),
                      height: hDimen(35),
                      child: Image.asset(
                        'assets/images/scan.png',
                        fit: BoxFit.contain,
                      )),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Scanner()),
                    );
                  },
                ),
                hSpacing(hDimen(10)),
                SizedBox(
                    width: hDimen(40),
                    height: hDimen(33),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const NotificationsList()),
                        );
                      },
                      child: Stack(
                        children: [
                          SizedBox(
                              height: hDimen(33),
                              child: Image.asset(
                                'assets/images/notification.png',
                                fit: BoxFit.cover,
                              )),
                          Padding(
                            padding: EdgeInsets.only(top: hDimen(5), left: 2),
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Container(
                                height: hDimen(25),
                                width: hDimen(25),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFFBBB16),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '$newNotification',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: hDimen(16)),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )),
              ],
            ),
            vSpacing(hDimen(20)),
            Padding(
              padding: EdgeInsets.only(
                left: hDimen(15),
                right: hDimen(15),
              ),
              child: Container(
                height: hDimen(55),
                padding: EdgeInsets.only(right: hDimen(15)),
                decoration: BoxDecoration(
                    color: const Color(0xFF18191E),
                    borderRadius: BorderRadius.circular(hDimen(25)),
                    border: Border.all(
                      color: const Color(0xFF5D4E76),
                      width: 1.5,
                    )),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: typeIn,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.transparent,
                            ),
                          ),
                          icon: hSpacing(hDimen(20)),
                          hintText: "Search DJs",
                          hintStyle: TextStyle(
                            fontSize: hDimen(16),
                            color: Colors.white54,
                            fontFamily: "Rajdhani",
                          ),
                        ),
                        onChanged: (contain){
                          filterDJs(contain);
                        },
                      ),
                    ),
                    SizedBox(
                      width: hDimen(25),
                      child: Image.asset(
                        'assets/images/search.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            vSpacing(hDimen(20)),
            Row(
              children: [
                Text(
                  club != null ? club['name'] : '',
                  style: TextStyle(
                      color: const Color(0xFF5587D2),
                      fontSize: hDimen(18),
                      fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                GestureDetector(
                    onTap: reset,
                    child: Text(
                      'Change',
                      style: TextStyle(
                          color: const Color(0xFF5587D2),
                          fontSize: hDimen(12),
                          fontWeight: FontWeight.bold),
                    ))
              ],
            ),
            vSpacing(hDimen(2)),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/images/location_y.png',
                  height: hDimen(18),
                ),
                hSpacing(hDimen(2)),
                Text(
                  club != null ? club['address'] : '',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: hDimen(14),
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
            vSpacing(hDimen(20)),
            Text(
              'DJ Details [${djs.length}]',
              style: TextStyle(
                color: const Color(0xFF92A4AC),
                fontSize: hDimen(18),
              ),
            ),
            vSpacing(hDimen(10)),
            for (var i = 0; i < djs.length; i++)
              DjItem(
                  imgPath: djs[i]['avatar'],
                  detail: djs[i]['bio'] ?? '',
                  name: djs[i]['name'],
                  price: djs[i]['amount_per_request'].toString(),
                  onDetails: () {
                    djs[i]['club_address'] =
                        club != null ? club['address'] : '';
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => DjDetailsScreen(dj: djs[i]),
                      ),
                    );
                  },
                  onRequest: () {
                    setState(() {
                      requested_dj = djs[i];
                      isRequest = true;
                    });
                  }),
            vSpacing(hDimen(15)),
            openForVotes.isNotEmpty
                ? Text(
                    'Cast Your Vote [${openForVotes.length}]',
                    style: TextStyle(
                      color: const Color(0xFF92A4AC),
                      fontSize: hDimen(18),
                    ),
                  )
                : const SizedBox.shrink(),
            vSpacing(hDimen(10)),
            for (var i = 0; i < openForVotes.length; i++)
              VoteItem(
                title: openForVotes[i]['song'],
                dj: openForVotes[i]['dj_name'],
                djPrice: openForVotes[i]['dj_price_set'].toString(),
                time: DateFormat('hh:mm a')
                    .format(DateTime.parse(openForVotes[i]['created_at'])),
                onDown: () {
                  castVote(openForVotes[i]['id'], 0);
                },
                onUp: () {
                  castVote(openForVotes[i]['id'], 1);
                },
                skip: () {
                  castVote(openForVotes[i]['id'], -1);
                },
              ),
            vSpacing(hDimen(10)),
          ],
        ),
      ),
    );
  }

  bool isUp = false;
  bool isVote = false;

  Widget Vote() {
    return Center(
      child: Container(
        height: hDimen(375),
        width: hDimen(290),
        padding: EdgeInsets.only(
          left: hDimen(15),
          right: hDimen(15),
          top: hDimen(20),
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF1E2126),
          borderRadius: BorderRadius.circular(hDimen(25)),
          border: Border.all(
            color: const Color(0xFF313131),
            width: 1,
          ),
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
                  'Vote for a Song',
                  style: TextStyle(
                    color: const Color(0xFF92A4AC),
                    fontSize: hDimen(17),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isVote = false;
                    });
                  },
                  child: Image.asset(
                    'assets/images/cross.png',
                    width: hDimen(25),
                  ),
                ),
              ],
            ),
            vSpacing(hDimen(15)),
            Padding(
              padding: EdgeInsets.only(
                left: hDimen(15),
              ),
              child: SizedBox(
                height: hDimen(45),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: hDimen(45),
                      child: Image.asset(
                        'assets/images/dp.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    hSpacing(hDimen(10)),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Adam Bravo',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: hDimen(16),
                          ),
                        ),
                        Text(
                          'Discovery Cube',
                          style: TextStyle(
                            color: const Color(0xFF5587D2),
                            fontSize: hDimen(14),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            vSpacing(hDimen(15)),
            Padding(
              padding: EdgeInsets.only(
                left: hDimen(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    padding: const EdgeInsets.all(10),
                    child: Image.asset(
                      'assets/images/audio_y.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  hSpacing(hDimen(10)),
                  Text(
                    'All I wanna do is have some fun',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: hDimen(16),
                    ),
                  ),
                ],
              ),
            ),
            vSpacing(hDimen(15)),
            Padding(
              padding: EdgeInsets.only(
                left: hDimen(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Valid till ',
                    style: TextStyle(
                      color: const Color(0xFF92A4AC),
                      fontSize: hDimen(16),
                    ),
                  ),
                  Text(
                    '9:15 pm',
                    style: TextStyle(
                      color: const Color(0xFFFBBB16),
                      fontSize: hDimen(16),
                    ),
                  )
                ],
              ),
            ),
            vSpacing(hDimen(15)),
            Padding(
              padding: EdgeInsets.only(
                left: hDimen(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Amount will be deducted: ',
                    style: TextStyle(
                      color: const Color(0xFF92A4AC),
                      fontSize: hDimen(15),
                    ),
                  ),
                  Text(
                    '\$ 1.00',
                    style: TextStyle(
                      color: const Color(0xFFFBBB16),
                      fontSize: hDimen(16),
                    ),
                  )
                ],
              ),
            ),
            vSpacing(hDimen(15)),
            Padding(
              padding: EdgeInsets.only(
                left: hDimen(15),
              ),
              child: Text(
                'from your saved card ending with 3424',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: hDimen(15),
                ),
              ),
            ),
            vSpacing(hDimen(15)),
            Padding(
              padding: EdgeInsets.only(
                left: hDimen(15),
              ),
              child: Text(
                'Want to change card?',
                style: TextStyle(
                  color: const Color(0xFF1AA8E6),
                  fontSize: hDimen(16),
                ),
              ),
            ),
            vSpacing(hDimen(25)),
            GestureDetector(
              onTap: () {
                if (isUp) {
                  setState(() {
                    isVote = false;
                  });
                } else {
                  setState(() {
                    isVote = false;
                  });
                }
              },
              child: Center(
                child: Container(
                  height: hDimen(45),
                  width: hDimen(150),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1AA8E6),
                    borderRadius: BorderRadius.circular(hDimen(25)),
                  ),
                  child: Center(
                    child: Text(
                      isUp ? 'CAST VOTE TO YES' : 'CAST VOTE TO NO',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: hDimen(16),
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: false,
      left: false,
      right: false,
      child: Stack(
        children: [
          searchDjLocation(),
          isSearched ? SearchedDjLocation() : Container(),
          isRequest ? Center(child: songRequest()) : Container(),
          isVote ? Vote() : Container(),
        ],
      ),
    );
  }

  filterDJs(String contain) {
    print("***** 1");
    setState(() {
      if (contain.isEmpty) {
        djs = allDJS;
      } else {
        djs = allDJS.where((element) =>
            element["name"].toString().toLowerCase().contains(contain.toLowerCase())
        ).toList();
      }
      print("***** $djs");
    });
  }

}
