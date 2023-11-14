import 'package:flutter/material.dart';
import 'package:music/utils/app_dimen.dart';
import 'package:music/utils/common.dart';

class PlacesVisited extends StatefulWidget {
  const PlacesVisited({Key? key}) : super(key: key);

  @override
  State<PlacesVisited> createState() => _PlacesVisitedState();
}

class _PlacesVisitedState extends State<PlacesVisited> {
  Widget VisitedItem({
    String songNo = '',
    String location = '',
    String date = '',
    String playedNo = '',
    String rejectedNo = '',
  }) {
    return Container(
      padding: EdgeInsets.only(left: hDimen(5),right: hDimen(5),top: hDimen(10),),
      height: hDimen(200),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2126),
        borderRadius: BorderRadius.circular(hDimen(15)),
        border: Border.all(color: const Color(0xFF2A2A36),width: 1.5,),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        padding: EdgeInsets.only(
          top: hDimen(20),
          right: hDimen(20),
          left: hDimen(15),
        ),
        height: double.infinity,
        width: double.infinity,
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
                SizedBox(
                    width: hDimen(40),
                    height: hDimen(33),
                    child: Image.asset(
                      'assets/images/back_btn.png',
                      fit: BoxFit.cover,
                    )),
                const Spacer(),
                Text(
                  'Places Visited',
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
            vSpacing(hDimen(20)),
            Text(
              'Places Visited',
              style: TextStyle(
                color: const Color(0xFF92A4AC),
                fontSize: hDimen(16),
              ),
            ),
            // Expanded(
            //   child: ListView.builder(itemBuilder: (context, index) =>),),
          ],
        ),
      ),
    );
  }
}
