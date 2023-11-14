import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:music/utils/app_dimen.dart';
import 'package:music/utils/common.dart';
import '../../models/user_model.dart';
import '../../utils/http_service.dart';
import '../../utils/shared_preference.dart';
import '../../utils/store.dart';

class DjDetailsScreen extends StatefulWidget {
  var dj;
  DjDetailsScreen({Key? key, required this.dj}) : super(key: key);

  @override
  State<DjDetailsScreen> createState() => _DjDetailsScreenState();
}

class _DjDetailsScreenState extends State<DjDetailsScreen> {
  TextEditingController songName = TextEditingController(text: '');
  TextEditingController tipsAmount = TextEditingController(text: '');
  User? user;
  var transactionFee;

  // sendRequest() async {
  //   EasyLoading.show(status: 'loading...');
  //   var httpClient = HttpService();
  //   var resp = await httpClient.post(generateUrl('request-song'),
  //       body: {'dj_id': widget.dj['id'].toString(), 'song': songName.text});
  //   if (resp.statusCode == 200) {
  //     final body = jsonDecode(resp.body);
  //     print(body);
  //     if (body['status']) {
  //       songName.text = '';
  //     }
  //     showToast(message: body['message']);
  //   } else {
  //     print(resp.body.toString());
  //     showToast(message: 'Oops! Something went wrong.');
  //   }
  //   EasyLoading.dismiss();
  // }

  @override
  void initState() {
    super.initState();
    getUserObject();
  }

  getUserObject() async {
    user = User.fromJson(await Store.getUser());
    transactionFee =  await SharedPreference.getStringPreference('TIPS_TRANSACTION');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: false,
      left: false,
      right: false,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          height: double.infinity,
          width: double.infinity,
          margin: const EdgeInsets.all(0),
          padding: EdgeInsets.only(
            top: hDimen(25),
            left: 0,
            right: 0,
          ),
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/splash_background.png'),
                fit: BoxFit.cover),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: hDimen(15)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        child: Image.asset(
                          'assets/images/back_btn.png',
                          width: hDimen(25),
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      const Spacer(),
                      Text(
                        'DJ Details',
                        style: TextStyle(
                          fontFamily: "Rajdhani",
                          color: Colors.white,
                          fontSize: hDimen(22),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
                vSpacing(hDimen(15)),
                Padding(
                  padding: EdgeInsets.only(left: hDimen(15)),
                  child: Text(
                    'Details',
                    style: TextStyle(
                      fontFamily: "Rajdhani",
                      color: const Color(0xFF92A4AC),
                      fontSize: hDimen(16),
                    ),
                  ),
                ),
                vSpacing(hDimen(10)),
                SizedBox(
                  height: hDimen(230),
                  child: Stack(
                    children: [
                      SizedBox(
                        height: hDimen(200),
                        width: double.infinity,
                        child: Image.network(
                          widget.dj['avatar'],
                          fit: BoxFit.cover,
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: SizedBox(
                          height: hDimen(56),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.only(
                                    left: hDimen(15), top: 2, bottom: 2),
                                color: Colors.black.withOpacity(0.5),
                                width: double.infinity,
                                child: Text(
                                  widget.dj['name'],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: hDimen(20),
                                  ),
                                ),
                              ),
                              vSpacing(3),
                              Padding(
                                padding: EdgeInsets.only(left: hDimen(15)),
                                child: Text(
                                  'DISCOVERY CUBE',
                                  style: TextStyle(
                                    color: const Color(0xFF5587D2),
                                    fontSize: hDimen(18),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          padding: const EdgeInsets.only(
                            right: 10,
                          ),
                          height: hDimen(140),
                          width: hDimen(140),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Image.network(
                              widget.dj['qr_code'],
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                vSpacing(hDimen(15)),
                Padding(
                  padding: EdgeInsets.only(left: hDimen(15)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/location_y.png',
                        height: hDimen(25),
                      ),
                      hSpacing(hDimen(10)),
                      Text(
                        widget.dj['club_address'] ?? '',
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
                  padding: EdgeInsets.only(left: hDimen(15)),
                  child: Text(
                    'Brief Bio',
                    style: TextStyle(
                      color: const Color(0xFF92A4AC),
                      fontSize: hDimen(18),
                    ),
                  ),
                ),
                vSpacing(hDimen(10)),
                Padding(
                  padding: EdgeInsets.only(left: hDimen(15)),
                  child: Text(
                    widget.dj['bio'] ?? '',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: hDimen(14),
                    ),
                  ),
                ),
                vSpacing(hDimen(15)),
                //widget.eventID != null ?
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: hDimen(15)),
                      child: Text(
                        'Request a Song',
                        style: TextStyle(
                          color: const Color(0xFF92A4AC),
                          fontSize: hDimen(18),
                        ),
                      ),
                    ),
                    vSpacing(hDimen(15)),
                    Padding(
                      padding: EdgeInsets.only(
                        left: hDimen(50),
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
                      padding: EdgeInsets.only(left: hDimen(50), right: hDimen(50)),
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
                            hintText: "Once",
                            hintStyle: const TextStyle(
                              fontSize: 15,
                              color: Colors.white,
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
                          '\$${widget.dj['amount_per_request']}',
                          style: TextStyle(
                            color: const Color(0xFFFBBB16),
                            fontSize: hDimen(16),
                          ),
                        )
                      ],
                    ),
                    vSpacing(hDimen(10)),
                    // Center(
                    //   child: Text(
                    //     'from your saved card ending with 3424',
                    //     style: TextStyle(
                    //       color: Colors.white,
                    //       fontSize: hDimen(16),
                    //     ),
                    //   ),
                    // ),
                    vSpacing(hDimen(25)),
                    GestureDetector(
                      onTap: () {
                        if (songName.text.isEmpty) {
                          showToast(message: 'Please enter a song name');
                          return;
                        }
                        if(user != null && user!.creditBalance != null && user!.creditBalance! > 0) {
                          sendRequestCredit();
                        } else {
                          createPaymentIntent();
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
                              'SEND REQUEST',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: hDimen(16),
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    vSpacing(hDimen(15)),
                    GestureDetector(
                      onTap: () async {
                        final amount = await openTipsDialog();
                        print('Amount: $amount');
                        //
                        var ttAmount = double.parse(amount!) + double.parse(transactionFee);
                        createPaymentTIPsIntent(ttAmount.toString());
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
                              'TIP',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: hDimen(16),
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    vSpacing(hDimen(15)),
                  ],
                ), //: SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<String?> openTipsDialog() => showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.white,
      title: Text('TIPS', style: TextStyle(
        fontFamily: "Rajdhani",
        color: Colors.black,
        fontSize: hDimen(22),
      ),),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            TextField(
              decoration: const InputDecoration(hintText: 'Enter amount'),
              controller: tipsAmount,
              keyboardType: TextInputType.number,
           style: TextStyle(
      fontFamily: "Rajdhani",
          color: Colors.black,
          fontSize: hDimen(18),
    ),
            ),
            hSpacing(5),
            Text('All tips are subject to a transaction fees \$$transactionFee', style: TextStyle(
              fontFamily: "Rajdhani",
              color: Colors.black,
              fontSize: hDimen(18),
            ),),
          ],
        ),
      ),
      actions: const [

        //FlatButton(onPressed: submit, child: Text('Submit'), color: Color(0xFF1AA8E6),)
      ],
    )
  );

  void submit() {
      Navigator.of(context).pop(tipsAmount.text);
      tipsAmount.clear();
  }

  createPaymentIntent() async {
    EasyLoading.show(status: 'loading...');
    var httpClient = HttpService();
    var resp = await httpClient.post(generateUrl('make-payment'),
        body: {'amount': widget.dj['amount_per_request'].toString()});

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


          sendPaymentRequest(body['payment_intent']);
        } catch (e) {
          if (e is StripeException) {
            showToast(
                message: 'Error from Stripe: ${e.error.localizedMessage}');
          } else {
            showToast(message: 'Something went wrong');
          }
        }
      }
    } else {
      showToast(message: 'Sorry! Can not process your payment at this moment');
    }
    EasyLoading.dismiss();
  }

  sendPaymentRequest(String transactionKey) async {
    EasyLoading.show(status: 'loading...');
    var httpClient = HttpService();
    var resp = await httpClient.post(generateUrl('request-song'), body: {
      'dj_id': widget.dj['id'].toString(),
      'song': songName.text,
      'transaction_key': transactionKey,
      'type':'stripe'
    });
    if (resp.statusCode == 200) {
      final body = jsonDecode(resp.body);
      print(body);
      if (body['status']) {
        setState(() {
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
      'dj_id': widget.dj['id'].toString(),
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

  createPaymentTIPsIntent(String amountT) async {
    EasyLoading.show(status: 'loading...');
    var httpClient = HttpService();
    var resp = await httpClient.post(generateUrl('make-payment'),
        body: {'amount': amountT});

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


          sendPaymentTIPsRequest(body['payment_intent'], amountT);
        } catch (e) {
          if (e is StripeException) {
            showToast(
                message: 'Error from Stripe: ${e.error.localizedMessage}');
          } else {
            showToast(message: 'Something went wrong');
          }
        }
      }
    } else {
      showToast(message: 'Sorry! Can not process your payment at this moment');
    }
    EasyLoading.dismiss();
  }

  sendPaymentTIPsRequest(String transactionKey, String tipAmount) async {
    EasyLoading.show(status: 'loading...');
    var httpClient = HttpService();
    var resp = await httpClient.post(generateUrl('send-tip'), body: {
      'dj_id': widget.dj['id'].toString(),
      'tip_amount': tipAmount,
      'transaction_key': transactionKey,
    });
    if (resp.statusCode == 200) {
      final body = jsonDecode(resp.body);
      print(body);
      showToast(message: 'Thank you for the tip');
    } else {
      print(resp.body.toString());
      showToast(message: 'Oops! Something went wrong.');
    }
    EasyLoading.dismiss();
  }
}
