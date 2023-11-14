import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:music/utils/app_dimen.dart';
import 'package:music/utils/common.dart';
import 'package:music/views/DJ/privacy_policy.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../utils/shared_preference.dart';

class TermsService extends StatefulWidget {
  const TermsService({Key? key}) : super(key: key);

  @override
  State<TermsService> createState() => _TermsServiceState();
}

class _TermsServiceState extends State<TermsService> {

  String? terms_url = '';
  late WebViewController _controller;
  bool urlLoaded = false;

  @override
  void initState() {
    getTermsString();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  getTermsString() async{
    setState(() {
      urlLoaded = true;

    });
    // EasyLoading.show(status: 'loading url...');
    terms_url = await SharedPreference.getStringPreference('TERMS_OF_SERVICE');
    if(terms_url != null && terms_url!.isNotEmpty){
      setState((){
        urlLoaded=false;
      });
      print(terms_url);
    }
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
            top: hDimen(30),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  Text(
                    'Terms of Service',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: hDimen(24),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const PrivacyPolicy()),);
                    },
                    child: Text(
                      'Privacy Policy',
                      style: TextStyle(
                        color: const Color(0xFF1AA8E6),
                        fontSize: hDimen(16),
                      ),
                    ),
                  ),
                ],
              ),
              vSpacing(hDimen(10)),
              !urlLoaded ?
              SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.85,
                  // the most important part of this example
                  child: GestureDetector(
                    // onVerticalDragUpdate: (updateDetails){ },
                    child: WebView(
                      backgroundColor: Colors.transparent,
                      initialUrl: terms_url!,
                      // Enable Javascript on WebView
                      javascriptMode: JavascriptMode.unrestricted,
                      onWebViewCreated: (WebViewController webViewController) {
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
                  )
              ): Center(
                child: SizedBox(
                  height: hDimen(25),
                  width: hDimen(25),
                  child: const CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              ),
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
        print(pageBody);
      },
    );
  }

}
