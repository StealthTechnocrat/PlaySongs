import 'package:flutter/material.dart';
import 'package:music/utils/app_dimen.dart';
import 'package:music/utils/common.dart';

class StatScreen extends StatefulWidget {
  const StatScreen({Key? key}) : super(key: key);

  @override
  State<StatScreen> createState() => _StatScreenState();
}

class _StatScreenState extends State<StatScreen> {
  Widget noRecord() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
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
            SizedBox(
                width: hDimen(40),
                height: hDimen(33),
                child: Image.asset(
                  'assets/images/scan.png',
                  fit: BoxFit.cover,
                )),
            hSpacing(hDimen(10)),
            SizedBox(
                width: hDimen(40),
                height: hDimen(33),
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
                              '5',
                              style: TextStyle(
                                  color: Colors.black, fontSize: hDimen(16)),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                )),
          ],
        ),
        const Spacer(),
        SizedBox(
          height: hDimen(150),
          width: hDimen(150),
          child: Image.asset(
            'assets/images/appicon.png',
            fit: BoxFit.fitHeight,
          ),
        ),
        vSpacing(hDimen(10)),
        Text(
          'There is no record found.',
          style: TextStyle(
            color: const Color(0xFF92A4AC),
            fontSize: hDimen(18),
          ),
        ),
        vSpacing(hDimen(10)),
        Padding(
          padding: EdgeInsets.only(
            left: hDimen(20),
            right: hDimen(20),
          ),
          child: Text(
            'You did not visit any place or request a song yet. Start visiting clubs and request songs to be played by your favorite DJ',
            style: TextStyle(
              color: Colors.white,
              fontSize: hDimen(15),
            ),
          ),
        ),
        const Spacer(
          flex: 2,
        ),
      ],
    );
  }

  recordItem({
    String value = '',
    String imgPath = '',
    String label = '',
  }) {
    return Container(
      height: hDimen(130),
      width: hDimen(130),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A36),
        border: Border.all(
          color: const Color(0xFF2A2A36),
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(hDimen(15)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: hDimen(32),
              fontWeight: FontWeight.w500,
              fontFamily: "Rajdhani"
            ),
          ),
          vSpacing(hDimen(20)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                imgPath,
                width: hDimen(25),
              ),
              hSpacing(hDimen(5)),
              Text(
                label,
                style: TextStyle(
                  color: const Color(0xFF92A4AC),
                  fontSize: hDimen(18),
                  fontWeight: FontWeight.w500,
                  fontFamily: "Rajdhani"
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget Record() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(
              flex: 2,
            ),
            Text(
              'My Stats',
              style: TextStyle(
                color: Colors.white,
                fontSize: hDimen(24),
              ),
            ),
            const Spacer(),
            SizedBox(
                width: hDimen(40),
                height: hDimen(33),
                child: Image.asset(
                  'assets/images/scan.png',
                  fit: BoxFit.cover,
                )),
            hSpacing(hDimen(10)),
            SizedBox(
                width: hDimen(40),
                height: hDimen(33),
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
                              '5',
                              style: TextStyle(
                                  color: Colors.black, fontSize: hDimen(16)),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                )),
          ],
        ),
        vSpacing(hDimen(60)),
        Expanded(
          flex: 2,
          child: GridView.count(
            crossAxisCount: 2,
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            crossAxisSpacing: hDimen(10),
            mainAxisSpacing: hDimen(10),
            children: [
              recordItem(
                imgPath: 'assets/images/location_y.png',
                value: '5',
                label: 'Places Visited',
              ),
              recordItem(
                imgPath: 'assets/images/requests.png',
                value: '24',
                label: 'Requests',
              ),
              recordItem(
                imgPath: 'assets/images/audio_y.png',
                value: '20',
                label: 'Songs Played',
              ),
              recordItem(
                imgPath: 'assets/images/cross_y.png',
                value: '4',
                label: 'Rejected',
              ),
            ],
          ),
        ),
        vSpacing(hDimen(20)),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Spend till date: ',
                    style: TextStyle(
                      color: const Color(0xFF92A4AC),
                      fontSize: hDimen(15),
                    ),
                  ),
                  Text(
                    '\$ 30.00',
                    style: TextStyle(
                      color: const Color(0xFFFBBB16),
                      fontSize: hDimen(16),
                    ),
                  )
                ],
              ),
              vSpacing(hDimen(5)),
              Text(
                'View Transactions',
                style: TextStyle(
                  color: const Color(0xFF1AA8E6),
                  fontSize: hDimen(20),
                ),
              ),
            ],
          ),
        ),

      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(
          top: hDimen(50),
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
        child: Record(),
      ),
    );
  }
}
