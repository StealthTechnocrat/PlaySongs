import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:music/utils/app_dimen.dart';
import 'package:music/utils/common.dart';
import 'package:music/utils/shared_preference.dart';
import 'package:webview_flutter/webview_flutter.dart';


import '../../utils/http_service.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  TextEditingController typeIn = TextEditingController(text: '');
  String? about_url = '';
  bool urlLoaded = false;

  late WebViewController _controller;

  contactUs() async {
    EasyLoading.show(status: 'loading...');
    var httpClient = HttpService();
    var resp = await httpClient.post(generateUrl('contact-us'), body: {
      'message': typeIn.text,
    });
    if (resp.statusCode == 200) {
      final body = jsonDecode(resp.body);
      showToast(message: body['message']);
    } else {
      showToast(message: 'Oops! Something went wrong.');
    }
    EasyLoading.dismiss();
  }

  @override
  void initState() {
    getAboutString();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    super.initState();
  }

  getAboutString() async {
    setState(() {
      urlLoaded = true;
    });
    // EasyLoading.show(status: 'loading url...');
    about_url = await SharedPreference.getStringPreference('ABOUT_US');
    if (about_url != null && about_url!.isNotEmpty) {
      setState(() {
        urlLoaded = false;
      });
      print(about_url);
    }
    // EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: false,
      left: false,
      right: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          height: double.infinity,
          width: double.infinity,
          padding: EdgeInsets.only(
            top: hDimen(20),
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
              Padding(
                padding: EdgeInsets.only(
                  right: hDimen(20),
                  left: hDimen(20),
                ),
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
                      'About Us',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: hDimen(24),
                      ),
                    ),
                    const Spacer(
                      flex: 2,
                    ),
                  ],
                ),
              ),
              vSpacing(hDimen(10)),
              !urlLoaded
                  ? SizedBox(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.55,
                      // the most important part of this example
                      child: GestureDetector(
                        // onVerticalDragUpdate: (updateDetails){ },
                        child: WebView(
                          backgroundColor: Colors.transparent,
                          initialUrl: about_url!,
                          // Enable Javascript on WebView
                          javascriptMode: JavascriptMode.unrestricted,
                          onWebViewCreated:
                              (WebViewController webViewController) {
                            _controller = webViewController;
                            // _controller.loadUrl(Uri.dataFromString(about_url!, mimeType: 'text/html', encoding: utf8).toString());
                          },
                          javascriptChannels: <JavascriptChannel>{
                            _extractDataJSChannel(context),
                          },
                          onPageStarted: (String url) {
                            EasyLoading.show(status: 'loading...');
                          },
                          onPageFinished: (String url) {
                            print(url);
                            EasyLoading.dismiss();
                          },
                        ),
                      ))
                  : Center(
                      child: SizedBox(
                        height: hDimen(25),
                        width: hDimen(25),
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ),
                    ),
              vSpacing(hDimen(10)),
              Padding(
                padding: EdgeInsets.only(
                  left: hDimen(20),
                ),
                child: Text(
                  'Get in Touch',
                  style: TextStyle(
                    color: const Color(0xFF92A4AC),
                    fontSize: hDimen(16),
                  ),
                ),
              ),
              vSpacing(hDimen(10)),
              Padding(
                padding: EdgeInsets.only(
                  left: hDimen(60),
                  right: hDimen(60),
                ),
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Message",
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
                        label: const Text(
                          "Type in",
                          style: TextStyle(
                            color: Color(0xFF566B75),
                            fontFamily: "Rajdhani",
                            fontSize: 16,
                          ),
                        ),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF1AA8E6),
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF1AA8E6),
                            width: 1.5,
                          ),
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
              vSpacing(hDimen(10)),
              Padding(
                padding: EdgeInsets.only(
                  right: hDimen(60),
                ),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    'Within 50 words',
                    style: TextStyle(
                      color: const Color(0xFF92A4AC),
                      fontSize: hDimen(16),
                    ),
                  ),
                ),
              ),
              vSpacing(hDimen(20)),
              Center(
                child: GestureDetector(
                  child: Container(
                    height: hDimen(45),
                    width: hDimen(130),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1AA8E6),
                      borderRadius: BorderRadius.circular(hDimen(25)),
                    ),
                    child: Center(
                      child: Text(
                        'SUBMIT',
                        style: TextStyle(
                          color: const Color(0xFF1E2126),
                          fontSize: hDimen(16),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    final List l = typeIn.text.split(' ');
                    if (typeIn.text.isEmpty) {
                      showToast(message: 'Please type in something');
                      return;
                    }
                    if (l.length > 50) {
                      showToast(
                          message:
                              'Please type your message within 50 words');
                      return;
                    }
                    contactUs();
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  JavascriptChannel _extractDataJSChannel(BuildContext context) {
    return JavascriptChannel(
      name: 'Flutter',
      onMessageReceived: (JavascriptMessage message) {
        String pageBody = message.message;
      },
    );
  }
}
