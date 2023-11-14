import 'package:flutter/material.dart';
import 'package:music/utils/app_dimen.dart';
import 'package:music/utils/common.dart';

class DjDetailsScreen extends StatefulWidget {
  const DjDetailsScreen({Key? key}) : super(key: key);

  @override
  State<DjDetailsScreen> createState() => _DjDetailsScreenState();
}

class _DjDetailsScreenState extends State<DjDetailsScreen> {
  TextEditingController songName = TextEditingController(text: '');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        margin: const EdgeInsets.all(0),
        padding: EdgeInsets.only(
          top: hDimen(30),
          left: 0,
          right: 0,
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
                    child: Image.asset(
                      'assets/images/image 1.png',
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
                            padding: EdgeInsets.only(left: hDimen(15),top: 2,bottom: 2),
                            color: Colors.black.withOpacity(0.5),
                            width: double.infinity,
                            child: Text(
                              'Adam Bravo',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: hDimen(20),
                              ),
                            ),
                          ),
                          vSpacing(3),
                          Padding(
                            padding: EdgeInsets.only(left:hDimen(15)),
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
                    child: SizedBox(
                      height: hDimen(75),
                      width: hDimen(75),
                      child: Image.asset('assets/images/qr_code.png',fit: BoxFit.cover,),
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
                    '11800 Foothill Blvd, Sylmar, CA 91342',
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
                'An all rounded Mid-West DJ masterfully combining turntable skills with showmanship and crowd interaction. Be ready for the experience you\'ve never had before.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: hDimen(14),
                ),
              ),
            ),
            vSpacing(hDimen(15)),
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
                  'Amount deducted will be',
                  style: TextStyle(
                    color: const Color(0xFF92A4AC),
                    fontSize: hDimen(16),
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
            vSpacing(hDimen(10)),
            Center(
              child: Text(
                'from your saved card ending with 3424',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: hDimen(16),
                ),
              ),
            ),
            vSpacing(hDimen(25)),
            GestureDetector(
              onTap: () {

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
}
