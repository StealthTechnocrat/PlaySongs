import 'dart:async';

import 'package:flutter/material.dart';
import 'package:music/utils/app_dimen.dart';
import 'package:music/views/user_selection.dart';


class Welcome extends StatefulWidget {
  late bool isMore;
  Welcome({Key? key, required this.isMore}) : super(key: key);

  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> with TickerProviderStateMixin {
  late TabController tabController;
  Timer? timer;

  @override
  void initState() {
    allTab = [
      tab1(),
      tab2(),
      tab3(),
      tab4(),
    ];
    saveTabbar();
    tabController = TabController(length: 4, vsync: this, initialIndex: 0);
    timer = Timer.periodic(const Duration(seconds: 4), (Timer t) => changeTab());
    print(widget.isMore);
    super.initState();
  }

  void saveTabbar() {
    allTabBar = [
      tabBars1(),
      tabBars2(),
      tabBars3(),
      tabBars4(),
    ];
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  changeTab() {
    if (isTab1) {
      print('Hello1');
      setState((){
        isTab1 = false;
        isTab2 = true;
        isTab3 = false;
        isTab4 = false;
      });
      tabController.animateTo(
        1,
        curve: Curves.easeInOut,
        duration: const Duration(seconds: 1),
      );
    } else if (isTab2) {
      print('Hello2');
      setState((){
        isTab1 = false;
        isTab2 = false;
        isTab3 = true;
        isTab4 = false;
      });
      tabController.animateTo(
        2,
        curve: Curves.easeInOut,
        duration: const Duration(seconds: 1),
      );
    } else if (isTab3) {
      print('Hello3');
      setState((){
        isTab1 = false;
        isTab2 = false;
        isTab3 = false;
        isTab4 = true;
      });
      tabController.animateTo(
        3,
        curve: Curves.easeInOut,
        duration: const Duration(seconds: 1),
      );
    } else if (isTab4) {
      print('Hello4');
      setState((){
        isTab1 = true;
        isTab2 = false;
        isTab3 = false;
        isTab4 = false;
      });
      tabController.animateTo(
        0,
        curve: Curves.easeInOut,
        duration: const Duration(seconds: 1),
      );
    }

    saveTabbar();
  }

  Widget tab1({
    String imgPath = '',
    String heading = '',
    String heading2 = '',
    String heading3 = '',
    String details = '',
  }) {
    return Column(
      children: [
        SizedBox(
          height: hDimen(40),
        ),
        SizedBox(
          height: hDimen(75),
          width: hDimen(150),
          child: Image.asset(
            'assets/images/appicon.png',
            fit: BoxFit.cover,
          ),
        ),
        Container(
          padding: const EdgeInsets.only(left: 20, right: 20),
          height: hDimen(350),
          width: hDimen(350),
          child: Image.asset(
            'assets/images/promotion_banner1.png',
            fit: BoxFit.contain,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: hDimen(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'A new interactive way of',
                    style: TextStyle(
                      fontSize: hDimen(16),
                      fontFamily: "Rajdhani",
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF92A4AC),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    'REQUESTING SONGS',
                    style: TextStyle(
                      fontSize: hDimen(22),
                      fontWeight: FontWeight.bold,
                      fontFamily: "Rajdhani",
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    'to your favorite DJs',
                    style: TextStyle(
                      fontSize: hDimen(16),
                      fontFamily: "Rajdhani",
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFFBBB16),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  // vSpacing(hDimen(10)),
                  // signIn(),
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  Widget tab2({
    String imgPath = '',
    String heading = '',
    String heading2 = '',
    String heading3 = '',
    String details = '',
  }) {
    return Column(
      children: [
        SizedBox(
          height: hDimen(40),
        ),
        SizedBox(
          height: hDimen(75),
          width: hDimen(150),
          child: Image.asset(
            'assets/images/appicon.png',
            fit: BoxFit.cover,
          ),
        ),
        Container(
          padding: const EdgeInsets.only(left: 20, right: 20),
          height: hDimen(350),
          width: hDimen(350),
          child: Image.asset(
            'assets/images/promotion_banner2.png',
            fit: BoxFit.contain,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: hDimen(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Your chance to',
                    style: TextStyle(
                      fontSize: hDimen(16),
                      fontFamily: "Rajdhani",
                      color: const Color(0xFF92A4AC),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    'VOTE A SONG',
                    style: TextStyle(
                      fontSize: hDimen(22),
                      fontWeight: FontWeight.bold,
                      fontFamily: "Rajdhani",
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    "on or off the DJ’s request list",
                    style: TextStyle(
                      fontSize: hDimen(16),
                      fontWeight: FontWeight.bold,
                      fontFamily: "Rajdhani",
                      color: const Color(0xFFFBBB16),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  // vSpacing(hDimen(10)),
                  // signIn(),
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  Widget tab3({
    String imgPath = '',
    String heading = '',
    String heading2 = '',
    String heading3 = '',
    String details = '',
  }) {
    return Column(
      children: [
        SizedBox(
          height: hDimen(40),
        ),
        SizedBox(
          height: hDimen(75),
          width: hDimen(150),
          child: Image.asset(
            'assets/images/appicon.png',
            fit: BoxFit.cover,
          ),
        ),
        Container(
          padding: const EdgeInsets.only(left: 20, right: 20),
          height: hDimen(350),
          width: hDimen(350),
          child: Image.asset(
            'assets/images/promotion_banner3.png',
            fit: BoxFit.contain,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: hDimen(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Request your',
                    style: TextStyle(
                      fontSize: hDimen(16),
                      fontFamily: "Rajdhani",
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF92A4AC),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    'FAVORITE SONGS',
                    style: TextStyle(
                      fontSize: hDimen(22),
                      fontFamily: "Rajdhani",
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    'at any nightclub, wedding or musical events',
                    style: TextStyle(
                      fontSize: hDimen(16),
                      fontFamily: "Rajdhani",
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFFBBB16),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  Widget tab4({
    String imgPath = '',
    String heading = '',
    String heading2 = '',
    String heading3 = '',
    String details = '',
  }) {
    return Column(
      children: [
        SizedBox(
          height: hDimen(40),
        ),
        SizedBox(
          height: hDimen(75),
          width: hDimen(150),
          child: Image.asset(
            'assets/images/appicon.png',
            fit: BoxFit.cover,
          ),
        ),
        Container(
          padding: const EdgeInsets.only(left: 20, right: 20),
          height: hDimen(350),
          width: hDimen(350),
          child: Image.asset(
            'assets/images/promotion_banner4.png',
            fit: BoxFit.contain,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: hDimen(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "DJ's play the request and",
                    style: TextStyle(
                      fontSize: hDimen(16),
                      fontFamily: "Rajdhani",
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF92A4AC),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    'EARN MONEY',
                    style: TextStyle(
                      fontSize: hDimen(22),
                      fontFamily: "Rajdhani",
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    'in a secure way',
                    style: TextStyle(
                      fontSize: hDimen(16),
                      fontFamily: "Rajdhani",
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFFBBB16),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  List<Widget> allTab = [];
  List<Widget> allTabBar = [];

  Widget tabBars1() {
    print("tabBars1");
    return isTab1 == true
        ? Container(
            height: hDimen(10),
            width: hDimen(10),
            decoration: BoxDecoration(
              color: const Color(0xFF1AA8E6),
              borderRadius: BorderRadius.circular(hDimen(5)),
            ),
          )
        : Container(
            height: hDimen(10),
            width: hDimen(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(hDimen(5)),
                border: Border.all(color: const Color(0xFF1AA8E6))),
          );
  }

  Widget tabBars2() {
    return isTab2 == true
        ? Container(
            height: hDimen(10),
            width: hDimen(10),
            decoration: BoxDecoration(
              color: const Color(0xFF1AA8E6),
              borderRadius: BorderRadius.circular(hDimen(5)),
            ),
          )
        : Container(
            height: hDimen(10),
            width: hDimen(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(hDimen(5)),
                border: Border.all(color: const Color(0xFF1AA8E6))),
          );
  }

  Widget tabBars3() {
    return isTab3 == true
        ? Container(
            height: hDimen(10),
            width: hDimen(10),
            decoration: BoxDecoration(
              color: const Color(0xFF1AA8E6),
              borderRadius: BorderRadius.circular(hDimen(5)),
            ),
          )
        : Container(
            height: hDimen(10),
            width: hDimen(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(hDimen(5)),
                border: Border.all(color: const Color(0xFF1AA8E6))),
          );
  }

  Widget tabBars4() {
    return isTab4 == true
        ? Container(
            height: hDimen(10),
            width: hDimen(10),
            decoration: BoxDecoration(
              color: const Color(0xFF1AA8E6),
              borderRadius: BorderRadius.circular(hDimen(5)),
            ),
          )
        : Container(
            height: hDimen(10),
            width: hDimen(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(hDimen(5)),
                border: Border.all(color: const Color(0xFF1AA8E6))),
          );
  }

  bool isTab1 = true;
  bool isTab2 = false;
  bool isTab3 = false;
  bool isTab4 = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/splash_background.png"),
              fit: BoxFit.cover)),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: TabBarView(
              physics: const BouncingScrollPhysics(),
              controller: tabController,
              children: allTab,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              bottom: hDimen(70),
            ),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: TabBar(
                indicatorWeight: 1,
                physics: const BouncingScrollPhysics(),
                isScrollable: true,
                unselectedLabelColor: const Color(0xFF1AA8E6),
                onTap: (value) {
                  print(value);
                  if (value == 0) {
                    setState(() {
                      isTab1 = true;
                      isTab2 = false;
                      isTab3 = false;
                      isTab4 = false;
                    });
                  }
                  if (value == 1) {
                    setState(() {
                      isTab1 = false;
                      isTab2 = true;
                      isTab3 = false;
                      isTab4 = false;
                    });
                  }
                  if (value == 2) {
                    setState(() {
                      isTab1 = false;
                      isTab2 = false;
                      isTab3 = true;
                      isTab4 = false;
                    });
                  }
                  if (value == 3) {
                    setState(() {
                      isTab1 = false;
                      isTab2 = false;
                      isTab3 = false;
                      isTab4 = true;
                    });
                  }
                },
                controller: tabController,
                tabs: allTabBar,
                indicatorColor: Colors.transparent,
              ),
            ),
          ),
          widget.isMore == true ? Container() : Padding(
            padding: EdgeInsets.only(
              bottom: hDimen(15),
              left: hDimen(15),
              right: hDimen(15),
            ),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const UserSelection(),
                    ),
                  );
                },
                child: const Text(
                  'SKIP',
                  style: TextStyle(
                      color: Color(0xFF1AA8E6),
                      fontSize: 16,
                      fontFamily: "Rajdhani",
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
          widget.isMore == true ? Padding(
            padding: EdgeInsets.only(
                right: hDimen(20),
                left: hDimen(20),
                top: hDimen(55)
            ),
            child: Align(
              alignment: Alignment.topLeft,
              child: GestureDetector(
                child: Image.asset(
                  'assets/images/back_btn.png',
                  width: hDimen(35),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ) : Container(),
        ],
      ),
    )
    );
  }
}
