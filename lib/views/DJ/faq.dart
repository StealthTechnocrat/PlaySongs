import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:music/utils/app_dimen.dart';
import 'package:music/utils/common.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../utils/shared_preference.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({Key? key}) : super(key: key);

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  List<String> titles = [
    'How do I send request to my favourite DJ?',
    'How do I know my request has been accepeted by the DJ?',
    'Do I scan the QR code to get details of my favourite DJ?',
    'As a DJ, how do I get my part of payment?',
    'How do I change my fees per request as DJ?',
  ];

  List<String> bodies = [
    'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using \'Content here, content here\', making it look like readable English.'
  ];

  ExpansionPanel expansionTile({String title = '', String body = ''}) {
    return ExpansionPanel(
      headerBuilder: (BuildContext context, bool isExpanded) {
        return ListTile(
          tileColor: const Color(0xFF1E2126),
          iconColor: const Color(0xFF1AA8E6),
          trailing: Icon(
            Icons.keyboard_arrow_down_outlined,
            color: const Color(0xFF1AA8E6),
            size: hDimen(25),
          ),
          focusColor: const Color(0xFF1E2126),
          selectedColor: const Color(0xFF1E2126),
          selectedTileColor: const Color(0xFF1E2126),
          enabled: false,
          title: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: hDimen(16),
            ),
          ),
        );
      },
      backgroundColor: Colors.transparent,
      body: ListTile(
        selectedColor: Colors.transparent,
        tileColor: Colors.transparent,
        selectedTileColor: Colors.transparent,
        title: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: hDimen(16),
          ),
        ),
        subtitle: Text(
          body,
          style: TextStyle(
            color: Colors.white,
            fontSize: hDimen(14),
          ),
        ),
      ),
      canTapOnHeader: true,
      isExpanded: true,
    );
  }

  List<bool> selecteds = [
    false,
    false,
    false,
    false,
    false,
  ];

  Widget expandPanel({
    String title = '',
    String body = '',
    bool isSelected = false,
    Function? onSelected,
    Function? onUnselected,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: hDimen(65),
          padding: EdgeInsets.only(left: hDimen(10),right: hDimen(10)),
          decoration: BoxDecoration(
            color: const Color(0xFF1E2126),
            border: Border.all(
              color: const Color(0xFF2A2A36),
              width: 1.3,
            ),
            borderRadius: BorderRadius.circular(hDimen(15)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: hDimen(16),
                  ),
                ),
              ),
              isSelected
                  ? GestureDetector(
                      onTap: () {
                        onUnselected!();
                      },
                      child: Image.asset(
                        'assets/images/arrow_up.png',
                        height: hDimen(25),
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        onSelected!();
                      },
                      child: Image.asset(
                        'assets/images/arrow_down.png',
                        height: hDimen(25),
                      ),
                    ),
            ],
          ),
        ),
        vSpacing(hDimen(15)),
        isSelected
            ? Padding(
                padding: EdgeInsets.only(
                  left: hDimen(10),
                  right: hDimen(10),
                ),
                child: Text(
                  body,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: hDimen(14),
                  ),
                ),
              )
            : Container(),
      ],
    );
  }

  String? faq_url = '';
  late WebViewController _controller;
  bool urlLoaded = false;

  @override
  void initState() {
    getPrivacyString();
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  getPrivacyString() async{
    setState(() {
      urlLoaded = true;

    });
    // EasyLoading.show(status: 'loading url...');
    faq_url = await SharedPreference.getStringPreference('FAQ');
    if(faq_url != null && faq_url!.isNotEmpty){
      setState((){
        urlLoaded=false;
      });
      print(faq_url);
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
                      'FAQ',
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
              !urlLoaded ?
              SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.85,
                  // the most important part of this example
                  child: GestureDetector(
                    // onVerticalDragUpdate: (updateDetails){ },
                    child: WebView(
                      backgroundColor: Colors.transparent,
                      initialUrl: faq_url!,
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
          )
          /*Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
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
                  Spacer(),
                  Text(
                    'FAQ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: hDimen(24),
                    ),
                  ),
                  Spacer(
                    flex: 1,
                  ),
                ],
              ),
              vSpacing(hDimen(25)),
              Expanded(child: ListView.builder(itemBuilder: (context,index)=>Padding(
                padding: EdgeInsets.only(bottom: hDimen(5)),
                child: expandPanel(
                    title: titles[index],
                    body: bodies[0],
                    isSelected: selecteds[index],
                    onSelected: (){
                      print('S');
                      setState((){
                        for(var i=0;i<selecteds.length;i++)
                          {
                            selecteds[i]=false;
                          }
                        selecteds[index]=true;
                      });
                    },
                    onUnselected:  (){
                      setState((){
                        for(var i=0;i<selecteds.length;i++)
                        {
                          selecteds[i]=false;
                        }
                      });
                    }
                ),
              ),itemCount: selecteds.length,physics: BouncingScrollPhysics(),),
              )

            ],
          ),*/
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
