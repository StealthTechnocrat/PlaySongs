import 'dart:async';
import 'dart:convert';

import 'package:address_search_field/address_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../utils/app_dimen.dart';
import '../../utils/common.dart';
import '../../utils/http_service.dart';
import '../notifications_list.dart';

class RequestScreen extends StatefulWidget {
  const RequestScreen({Key? key}) : super(key: key);

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  TextEditingController typeIn = TextEditingController(text: '');
  TextEditingController location = TextEditingController(text: '');
  TextEditingController price = TextEditingController(text: '');
  final geoMethods = GeoMethods(
    googleApiKey: 'AIzaSyDzK9yvhzt8Ytn8BA2NprlJzGRf018vkG0',
    language: 'en',
    // countryCode: 'us',
    // countryCodes: ['us', 'es', 'co'],
    // country: 'United States',
  );

  bool isSearched = false;
  var club;
  var event;
  bool newRequestSelected = true;
  bool voteSelected = false;
  bool playedSelected = false;
  bool rejectedSelected = false;
  double width = 0;
  double height = 0;
  double latitude = 0.0;
  double longitude = 0.0;

  var pendingArr = [];
  var voteArr = [];
  var rejectedArr = [];
  var playedArr = [];

  var allpendingArr = [];
  var allvoteArr = [];
  var allrejectedArr = [];
  var allplayedArr = [];
  int newNotification = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    checkRunningEvent();
    getNotificationCount();
    timer = Timer.periodic(const Duration(seconds: 15), (Timer t) => checkCurrentTabAndCallEvent());
  }

  checkCurrentTabAndCallEvent() {
    print('newRequestSelected: $newRequestSelected');
    if(newRequestSelected) {
      fetchRequests();
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  checkRunningEvent() async {
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
          event = body['event'];
          fetchRequests();
          isSearched = true;
        });
      } else {
        setState(() {
          club = null;
          event = null;
          isSearched = false;
        });
      }
    } else {
      print(resp.body);
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

  reset() {
    // typeIn.text = '';
    // location.text = '';
    // setState(() {
    //   isSearched = false;
    //   club = null;
    // });

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.black.withOpacity(0.8),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    10.0)), //this right here
            child: Container(
              height: hDimen(130),
              decoration: BoxDecoration(
                  color: const Color(0xFF1E2126),
                  borderRadius: BorderRadius.circular(10.0)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment:
                  CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Are you sure you want to end this event?",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF92A4AC)),
                    ),
                    vSpacing(vDimen(25)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            width: hDimen(100),
                            height: hDimen(40),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1AA8E6),
                              borderRadius:
                              BorderRadius.circular(50),
                            ),
                            child: const Center(
                              child: Text(
                                "No",
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight:
                                    FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                        hSpacing(hDimen(20)),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();

                            //
                            changeRunningEvent();

                          },
                          child: Container(
                            width: hDimen(100),
                            height: hDimen(40),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1AA8E6),
                              borderRadius:
                              BorderRadius.circular(50),
                            ),
                            child: const Center(
                              child: Text(
                                "Yes",
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight:
                                    FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                      ]
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  searchClub() async {

    if(price.text.isEmpty || location.text.isEmpty || typeIn.text.isEmpty) {
        showToast(message: 'Please enter Venue, Location and charges per request');
    } else if(int.parse(price.text) < 1) {
      showToast(message: 'Enter charges per request should be greater than 0');
    } else {
      EasyLoading.show(status: 'loading...');
      var httpClient = HttpService();
      var resp = await httpClient.post(generateUrl('create-event'), body: {
        'name': typeIn.text,
        'lat': latitude.toString(),
        'lon': longitude.toString(),
        'price': price.text,
        'address': location.text
      });
      if (resp.statusCode == 200) {
        final body = jsonDecode(resp.body);
        print(body);
        if (body['status']) {
          setState(() {
            club = body['club'];
            event = body['event'];
            fetchRequests();
            isSearched = true;
            //fetchDjs(club['id'].toString());
          });
        } else {
          showToast(message: body['message']);
        }
      } else {
        print(resp.statusCode);
        showToast(message: 'Oops! Something went wrong.');
      }
      EasyLoading.dismiss();
    }
  }

  changeStatus(String action, var id) async {
    EasyLoading.show(status: 'loading...');
    var httpClient = HttpService();
    var resp = await httpClient.post(generateUrl('change-status'),
        body: {'request_id': id.toString(), 'status': action});
    if (resp.statusCode == 200) {
      final body = jsonDecode(resp.body);
      print(body);
      if (body['status']) {
        fetchRequests();
      } else {
        showToast(message: body['message']);
      }
    } else {
      print(resp.statusCode);
      showToast(message: 'Oops! Something went wrong.');
    }
    EasyLoading.dismiss();
  }

  fetchRequests() async {
    EasyLoading.show(status: 'loading...');
    print(event);
    Uri uri = generateUrl('get-requests');
    final finalUri = uri.replace(queryParameters: {
      'event_id': event != null ? event['id'].toString() : '0',
    });
    var httpClient = HttpService();
    var resp = await httpClient.get(finalUri);
    if (resp.statusCode == 200) {
      final body = jsonDecode(resp.body);
      print(body);
      if (body['status']) {
        setState(() {
          pendingArr = [];
          playedArr = [];
          rejectedArr = [];
          voteArr = [];
          for (var item in body['requests']) {
            if (item['status'] == 'pending') {
              pendingArr.add(item);
            } else if (item['status'] == 'accepted' || item['status'] == 'played') {
              playedArr.add(item);
            } else if (item['status'] == 'rejected') {
              rejectedArr.add(item);
            } else if (item['status'] == 'vote') {
              voteArr.add(item);
            }
          }

          allpendingArr = pendingArr;
          allplayedArr = playedArr;
          allrejectedArr = rejectedArr;
          allvoteArr = voteArr;

        });
      } else {
        showToast(message: body['message']);
      }
    } else {
      print(resp.statusCode);
      showToast(message: 'Oops! Something went wrong.');
    }
    EasyLoading.dismiss();
  }

  setAddress(address) {
    setState(() {
      latitude = address.coords.latitude;
      longitude = address.coords.longitude;
    });
  }

  Widget newRequestItem({
    var id = 0,
    String imgPath = '',
    String name = '',
    String detail = '',
    String price = '',
    Function? onAccept,
    Function? onVote,
    Function? onReject,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: hDimen(10)),
      child: Container(
        height: hDimen(140),
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
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  flex: 5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: hDimen(45),
                            width: hDimen(45),
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
                          hSpacing(8),
                          Text(
                            name,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: hDimen(14),
                            ),
                          ),
                        ],
                      ),
                      vSpacing(hDimen(20)),
                      Row(
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
                          Text(
                            detail,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: hDimen(13),
                            ),
                          ),
                        ],
                      ),
                      vSpacing(hDimen(5)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Request Fees: ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: hDimen(13),
                            ),
                          ),
                          Text(
                            '\$ $price',
                            style: TextStyle(
                              color: const Color(0xFFFBBB16),
                              fontSize: hDimen(14),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        changeStatus('accepted', id);
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
                            'ACCEPT',
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
                        changeStatus('vote', id);
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
                            'VOTE',
                            style: TextStyle(
                              color: const Color(0xFF1AA8E6),
                              fontSize: hDimen(16),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    vSpacing(hDimen(10)),
                    GestureDetector(
                      onTap: () {
                        changeStatus('rejected', id);
                      },
                      child: Container(
                        height: hDimen(30),
                        width: hDimen(90),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(hDimen(15)),
                          border: Border.all(
                            color: const Color(0xFFFF1E1E),
                            width: 1.5,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'REJECT',
                            style: TextStyle(
                              color: const Color(0xFFFF1E1E),
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
      ),
    );
  }

  Widget voteItem({
    var id = 0,
    String imgPath = '',
    String name = '',
    String detail = '',
    String price = '',
    var votes,
    Function? onAccept,
    Function? onUp,
    Function? onDown,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: hDimen(10)),
      child: Container(
        height: hDimen(145),
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
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  flex: 5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: hDimen(45),
                            width: hDimen(45),
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
                          hSpacing(8),
                          Text(
                            name,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: hDimen(14),
                            ),
                          ),
                        ],
                      ),
                      vSpacing(hDimen(20)),
                      Row(
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
                          Text(
                            detail,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: hDimen(13),
                            ),
                          ),
                        ],
                      ),
                      vSpacing(hDimen(5)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Request Fees: ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: hDimen(13),
                            ),
                          ),
                          Text(
                            '\$ $price',
                            style: TextStyle(
                              color: const Color(0xFFFBBB16),
                              fontSize: hDimen(14),
                            ),
                          ),
                          hSpacing(40),
                          GestureDetector(
                            onTap: () {
                              changeStatus('rejected', id);
                            },
                            child: Container(
                              height: hDimen(30),
                              width: hDimen(90),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(hDimen(15)),
                                border: Border.all(
                                  color: const Color(0xFFFF1E1E),
                                  width: 1.5,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'REJECT',
                                  style: TextStyle(
                                    color: const Color(0xFFFF1E1E),
                                    fontSize: hDimen(16),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                        onTap: () {
                          onUp!();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
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
                            Text(
                              votes != null ? votes['up_vote'] : 0,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: hDimen(20),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        )),
                    vSpacing(hDimen(10)),
                    GestureDetector(
                        onTap: () {
                          onDown!();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
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
                            Text(
                              votes != null ? votes['down_vote'] : 0,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: hDimen(20),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        )),
                    vSpacing(hDimen(16)),
                    GestureDetector(
                      onTap: () {
                        changeStatus('accepted', id);
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
                            'ACCEPT',
                            style: TextStyle(
                                color: const Color(0xFF1E2126),
                                fontSize: hDimen(16),
                                fontWeight: FontWeight.bold),
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
      ),
    );
  }

  Widget playedItem({
    var id = 0,
    String imgPath = '',
    String name = '',
    String detail = '',
    String price = '',
    String status = '',
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: hDimen(10)),
      child: Container(
        height: hDimen(140),
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
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  flex: 5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: hDimen(45),
                            width: hDimen(45),
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
                          hSpacing(8),
                          Text(
                            name,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: hDimen(14),
                            ),
                          ),
                        ],
                      ),
                      vSpacing(hDimen(20)),
                      Row(
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
                          Text(
                            detail,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: hDimen(13),
                            ),
                          ),
                        ],
                      ),
                      vSpacing(hDimen(5)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Request Fees: ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: hDimen(13),
                            ),
                          ),
                          Text(
                            '\$ $price',
                            style: TextStyle(
                              color: const Color(0xFFFBBB16),
                              fontSize: hDimen(14),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    status != 'played' ?
                    GestureDetector(
                      onTap: () {
                       if (status != 'played') {
                         changeStatus('played', id);
                       }
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
                            status == 'played' ? 'PLAYED': 'PLAY',
                            style: TextStyle(
                                color: const Color(0xFF1E2126),
                                fontSize: hDimen(16),
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ) : GestureDetector(
                            onTap: () {
                              if (status != 'played') {
                                changeStatus('played', id);
                              }
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
                                  status == 'played' ? 'PLAYED' : 'PLAY',
                                  style: TextStyle(
                                      color: const Color(0xFF1AA8E6),
                                      fontSize: hDimen(16),
                                      fontWeight: FontWeight.bold),
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
      ),
    );
  }

  Widget rejectedItem({
    var id = 0,
    String imgPath = '',
    String name = '',
    String detail = '',
    String price = '',
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: hDimen(10)),
      child: Container(
        height: hDimen(140),
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
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  flex: 5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: hDimen(45),
                            width: hDimen(45),
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
                          hSpacing(8),
                          Text(
                            name,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: hDimen(14),
                            ),
                          ),
                        ],
                      ),
                      vSpacing(hDimen(20)),
                      Row(
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
                          Text(
                            detail,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: hDimen(13),
                            ),
                          ),
                        ],
                      ),
                      vSpacing(hDimen(5)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Request Fees: ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: hDimen(13),
                            ),
                          ),
                          Text(
                            '\$ $price',
                            style: TextStyle(
                              color: const Color(0xFFFBBB16),
                              fontSize: hDimen(14),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget searchDjLocation(context) {
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
                'Song Requests',
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
              //                     '$newNotification',
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
                          onDone: (Address address) => {setAddress(address)},
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
          Padding(
            padding: EdgeInsets.only(
                left: hDimen(60), right: hDimen(60), top: hDimen(20)),
            child: const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Charges per Request",
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
                controller: price,
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
                        'assets/images/charges.png',
                        width: 10,
                        height: 10,
                        fit: BoxFit.contain,
                      ),
                    ),
                    hintText: "Type in",
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
                    'START RECEIVING REQUESTS',
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
            flex: 5,
          ),
        ],
      ),
    );
  }

  Widget SearchedDjLocation() {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
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
                // Container(
                //     width: hDimen(40),
                //     height: hDimen(35),
                //     child: Image.asset(
                //       'assets/images/scan.png',
                //       fit: BoxFit.contain,
                //     )),
                hSpacing(hDimen(10)),
                SizedBox(
                    width: hDimen(40),
                    height: hDimen(33),
                    child: InkWell(
                      onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const NotificationsList()),
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
                          hintText: "search by songs",
                          hintStyle: TextStyle(
                            fontSize: hDimen(16),
                            color: Colors.white54,
                            fontFamily: "Rajdhani",
                          ),
                        ),
                        onChanged: (contain){
                          filterSongs(contain);
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      newRequestSelected = true;
                      playedSelected = false;
                      rejectedSelected = false;
                      voteSelected = false;
                    });
                  },
                  child:
                      //   Text(
                      //     "New Requests [${pendingArr.length}]",
                      //     style: TextStyle(
                      //         decoration: TextDecoration.underline,
                      //         fontSize: height == 667.0 ? 16 : 17,
                      //         fontWeight: FontWeight.w600,
                      //         color: newRequestSelected
                      //             ? Color(0xFF1AA8E6)
                      //             : Color(0xFF92A4AC)),
                      //   ),
                      // ),
                      Container(
                    padding: const EdgeInsets.only(
                      bottom: 5, // Space between underline and text
                    ),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                      color: newRequestSelected
                          ? const Color(0xFF1AA8E6)
                          : Colors.transparent,
                      width: 1.0, // Underline thickness
                    ))),
                    child: Text(
                      "Requests [${pendingArr.length}]",
                      style: TextStyle(
                          fontSize: height == 667.0 ? 16 : 16,
                          fontWeight: FontWeight.w600,
                          color: newRequestSelected
                              ? const Color(0xFF1AA8E6)
                              : const Color(0xFF92A4AC)),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      newRequestSelected = false;
                      playedSelected = false;
                      rejectedSelected = false;
                      voteSelected = true;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.only(
                      bottom: 5, // Space between underline and text
                    ),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                      color: voteSelected
                          ? const Color(0xFF1AA8E6)
                          : Colors.transparent,
                      width: 1.0, // Underline thickness
                    ))),
                    child: Text(
                      "Vote [${voteArr.length}]",
                      style: TextStyle(
                          fontSize: height == 667.0 ? 16 : 16,
                          fontWeight: FontWeight.w600,
                          color: voteSelected
                              ? const Color(0xFF1AA8E6)
                              : const Color(0xFF92A4AC)),
                    ),
                  ),

                  // Text(
                  //   "Vote [${voteArr.length}]",
                  //   style: TextStyle(
                  //       fontSize: height == 667.0 ? 16 : 17,
                  //       fontWeight: FontWeight.w600,
                  //       color: voteSelected
                  //           ? Color(0xFF1AA8E6)
                  //           : Color(0xFF92A4AC)),
                  // ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      newRequestSelected = false;
                      playedSelected = true;
                      rejectedSelected = false;
                      voteSelected = false;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.only(
                      bottom: 5, // Space between underline and text
                    ),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                      color: playedSelected
                          ? const Color(0xFF1AA8E6)
                          : Colors.transparent,
                      width: 1.0, // Underline thickness
                    ))),
                    child: Text(
                      "Playlist [${playedArr.length}]",
                      style: TextStyle(
                          fontSize: height == 667.0 ? 16 : 16,
                          fontWeight: FontWeight.w600,
                          color: playedSelected
                              ? const Color(0xFF1AA8E6)
                              : const Color(0xFF92A4AC)),
                    ),
                  ),
                  // Text(
                  //   "Played [${playedArr.length}]",
                  //   style: TextStyle(
                  //       fontSize: height == 667.0 ? 16 : 17,
                  //       fontWeight: FontWeight.w600,
                  //       color: playedSelected
                  //           ? Color(0xFF1AA8E6)
                  //           : Color(0xFF92A4AC)),
                  // ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      newRequestSelected = false;
                      playedSelected = false;
                      rejectedSelected = true;
                      voteSelected = false;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.only(
                      bottom: 5, // Space between underline and text
                    ),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                      color: rejectedSelected
                          ? const Color(0xFF1AA8E6)
                          : Colors.transparent,
                      width: 1.0, // Underline thickness
                    ))),
                    child: Text(
                      "Rejected [${rejectedArr.length}]",
                      style: TextStyle(
                          fontSize: height == 667.0 ? 16 : 16,
                          fontWeight: FontWeight.w600,
                          color: rejectedSelected
                              ? const Color(0xFF1AA8E6)
                              : const Color(0xFF92A4AC)),
                    ),
                  ),
                  // Text(
                  //   "Rejected [${rejectedArr.length}]",
                  //   style: TextStyle(
                  //       fontSize: height == 667.0 ? 16 : 17,
                  //       fontWeight: FontWeight.w600,
                  //       color: rejectedSelected
                  //           ? Color(0xFF1AA8E6)
                  //           : Color(0xFF92A4AC)),
                  // ),
                ),
              ],
            ),
            vSpacing(hDimen(20)),
            RefreshIndicator(
                onRefresh: () async => {await fetchRequests()},
                child: SizedBox(
                  width: double.infinity,
                  height: height == 667.0
                      ? MediaQuery.of(context).size.height * 0.48
                      : MediaQuery.of(context).size.height * 0.56,
                  child: newRequestSelected
                      ? ListView.builder(
                          itemCount: pendingArr.length,
                          itemBuilder: (BuildContext context, int index) {
                            return newRequestItem(
                                id: pendingArr[index]['id'],
                                imgPath: pendingArr[index]['avatar'],
                                detail: pendingArr[index]['song'],
                                name: pendingArr[index]['name'],
                                price: "${pendingArr[index]['dj_price_set']}",
                                onAccept: () {
                                  // djs[i]['club_address'] =
                                  // club != null ? club['address'] : '';
                                  // Navigator.of(context).push(
                                  //   MaterialPageRoute(
                                  //     builder: (context) => DjDetailsScreen(dj: djs[i]),
                                  //   ),
                                  // );
                                },
                                onVote: () {
                                  setState(() {
                                    // requested_dj = djs[i];
                                    // isRequest = true;
                                  });
                                },
                                onReject: () {
                                  setState(() {
                                    // requested_dj = djs[i];
                                    // isRequest = true;
                                  });
                                });
                          },
                        )
                      : voteSelected
                          ? ListView.builder(
                              itemCount: voteArr.length,
                              itemBuilder: (BuildContext context, int index) {
                                return voteItem(
                                    id: voteArr[index]['id'],
                                    imgPath: voteArr[index]['avatar'],
                                    detail: voteArr[index]['song'],
                                    name: voteArr[index]['name'],
                                    price: "${voteArr[index]['dj_price_set']}",
                                    votes: voteArr[index]['votes'],
                                    onAccept: () {
                                      // djs[i]['club_address'] =
                                      // club != null ? club['address'] : '';
                                      // Navigator.of(context).push(
                                      //   MaterialPageRoute(
                                      //     builder: (context) => DjDetailsScreen(dj: djs[i]),
                                      //   ),
                                      // );
                                    },
                                    onUp: () {
                                      setState(() {
                                        // requested_dj = djs[i];
                                        // isRequest = true;
                                      });
                                    },
                                    onDown: () {
                                      setState(() {
                                        // requested_dj = djs[i];
                                        // isRequest = true;
                                      });
                                    });
                              },
                            )
                          : playedSelected
                              ? ListView.builder(
                                  itemCount: playedArr.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return playedItem(
                                      id: playedArr[index]['id'],
                                      imgPath: playedArr[index]['avatar'],
                                      detail: playedArr[index]['song'],
                                      name: playedArr[index]['name'],
                                      price:
                                          "${playedArr[index]['dj_price_set']}",
                                      status: playedArr[index]['status'],
                                    );
                                  },
                                )
                              : rejectedSelected
                                  ? ListView.builder(
                                      itemCount: rejectedArr.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return rejectedItem(
                                          id: rejectedArr[index]['id'],
                                          imgPath: rejectedArr[index]['avatar'],
                                          detail: rejectedArr[index]['song'],
                                          name: rejectedArr[index]['name'],
                                          price:
                                              "${rejectedArr[index]['dj_price_set']}",
                                        );
                                      },
                                    )
                                  : Container(),
                ))
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      top: true,
      bottom: false,
      left: false,
      right: false,
      child: Stack(
        children: [
          searchDjLocation(context),
          isSearched ? SearchedDjLocation() : Container(),
        ],
      ),
    );
  }

  filterSongs(String contain) {
    print("***** 1");
    setState(() {
      if (contain.isEmpty) {
        pendingArr = allpendingArr;
        voteArr = allvoteArr;
        rejectedArr = allrejectedArr;
        playedArr = allplayedArr;
      } else {
        pendingArr = allpendingArr.where((element) =>
            element["song"].toString().toLowerCase().contains(contain.toLowerCase())
        ).toList();

        voteArr = allvoteArr.where((element) =>
            element["song"].toString().toLowerCase().contains(contain.toLowerCase())
        ).toList();

        rejectedArr = allrejectedArr.where((element) =>
            element["song"].toString().toLowerCase().contains(contain.toLowerCase())
        ).toList();

        playedArr = allplayedArr.where((element) =>
            element["song"].toString().toLowerCase().contains(contain.toLowerCase())
        ).toList();
      }
    });
  }

  changeRunningEvent() async {
    EasyLoading.show(status: 'loading...');
    var httpClient = HttpService();
    var resp = await httpClient.post(generateUrl('end-event'), body: {
      'event_id': event != null ? event['id'].toString() : '0',
    });
    if (resp.statusCode == 200) {
      final body = jsonDecode(resp.body);
      print('Change Event1 $resp');
      print('Change Event2 $body');
      if (body['status']) {
        setState(() {
          club = null;
          event = null;
          isSearched = false;
          typeIn.text = '';
          location.text = '';
          price.text = '';
        });
      } else {
        showToast(message: body['message']);
      }
    } else {
      print(resp.body);
      showToast(message: 'Oops! Something went wrong.');
    }
    EasyLoading.dismiss();
  }
}
