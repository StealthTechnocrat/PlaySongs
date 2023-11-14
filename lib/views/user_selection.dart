import 'package:flutter/material.dart';
import 'package:music/views/DJ/signin.dart';
import 'package:music/views/MusicLover/signin_music.dart';

import '../utils/app_dimen.dart';

class UserSelection extends StatefulWidget{
  const UserSelection({Key? key}) : super(key: key);

  @override
  _UserSelectionState createState() => _UserSelectionState();
}

class _UserSelectionState extends State<UserSelection>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/splash_background.png'),
                fit: BoxFit.cover
            )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: hDimen(50),),
            const Text('WELCOME TO',style: TextStyle(color: Colors.white,fontSize: 22,fontWeight: FontWeight.w500,fontFamily: "Rajdhani"),),
            SizedBox(
              height: hDimen(75),
              width: hDimen(150),
              child: Image.asset(
                'assets/images/appicon.png',
                fit: BoxFit.cover,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 60.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Hey, I am ",style: TextStyle(fontSize: 30,color: Color(0xFF5587D2),fontWeight: FontWeight.w500,fontFamily: "Rajdhani"),),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30,left: 60,right: 40),
              child: GestureDetector(
                onTap: (){
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SignIn(),
                    ),
                  );
                },
                child: SizedBox(
                  width: double.infinity,
                  height: hDimen(150),
                  child: Stack(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Container(
                              width: hDimen(150),
                              height: hDimen(150),
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(10))
                              ),
                              child: const ClipRRect(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                child: Image(
                                  image: AssetImage("assets/images/dj.png"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: hDimen(10),),
                          Expanded(
                            flex: 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("A professional mixing music with showmanship and crowd interaction",style: TextStyle(fontSize: 12,color: Color(0xFF92A4AC),fontWeight: FontWeight.w300,fontFamily: "Rajdhani"),),
                                SizedBox(height: hDimen(20),),
                                Container(
                                  width: hDimen(70),
                                  height: hDimen(30),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1AA8E6),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: const Center(
                                    child: Text("GET IN",style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold,color: Colors.black),),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: hDimen(10)),
                            child: const Text("DJ",style: TextStyle(fontSize: 44,color: Colors.white,fontWeight: FontWeight.bold,fontFamily: "Rajdhani-Bold"),textAlign: TextAlign.start,),
                          )
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30,left: 60,right: 40),
              child: GestureDetector(
                onTap: (){
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SignInMusic(),
                    ),
                  );
                },
                child: SizedBox(
                  width: double.infinity,
                  height: hDimen(150),
                  child: Stack(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Container(
                              width: hDimen(150),
                              height: hDimen(150),
                              decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(10))
                              ),
                              child: const ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                child: Image(
                                  image: AssetImage("assets/images/dj1.png"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: hDimen(10),),
                          Expanded(
                            flex: 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Music fans do you want to request a song to your favorite DJ at any event DJ PLAY MY SONG",style: TextStyle(fontSize: 12,color: Color(0xFF92A4AC),fontWeight: FontWeight.w300,fontFamily: "Rajdhani"),),
                                SizedBox(height: hDimen(20),),
                                Container(
                                  width: hDimen(70),
                                  height: hDimen(30),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1AA8E6),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: const Center(
                                    child: Text("GET IN",style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold,color: Colors.black),),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: hDimen(10)),
                            child: const Text("MUSIC\nLOVER",style: TextStyle(fontSize: 44,color: Colors.white,fontWeight: FontWeight.bold,fontFamily: "Rajdhani-Bold",height: 0.9),textAlign: TextAlign.start,),
                          )
                      )
                    ],
                  ),
                ),
              ),
            )

          ],
        ),
      ),
    );
  }

}