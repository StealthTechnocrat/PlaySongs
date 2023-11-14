import 'package:flutter/material.dart';
import 'package:music/utils/app_dimen.dart';
import 'package:music/utils/common.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  Widget notificationItem({
    String date = '21 Apr, 2022',
    String time = '9:30 PM',
    String desc = '',
    Function? onDelete,
  }) {
    return Container(
      height: hDimen(90),
      padding: EdgeInsets.only(
        left: hDimen(10),
        right: hDimen(15),
        top: hDimen(15),
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2126),
        border: Border.all(
          color: const Color(0xFF2A2A36),
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(hDimen(8)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'your requested song has been accepted by Adam Bravo.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: hDimen(15),
                  ),
                ),
                vSpacing(hDimen(5)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      date,
                      style: TextStyle(
                        color: const Color(0xFF92A4AC),
                        fontSize: hDimen(13),
                      ),
                    ),
                    hSpacing(5),
                    SizedBox(
                      height: hDimen(10),
                      child: const VerticalDivider(
                        color: Color(0xFF92A4AC),
                        width: 2,
                      ),
                    ),
                    hSpacing(5),
                    Text(
                      time,
                      style: TextStyle(
                        color: const Color(0xFF92A4AC),
                        fontSize: hDimen(13),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          hSpacing(hDimen(20)),
          GestureDetector(
            onTap: onDelete!(),
            child: Image.asset(
              'assets/images/cross.png',
              width: hDimen(30),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/splash_background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(hDimen(65)),
              child: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                centerTitle: true,
                actions: [
                  Center(
                    child: Text(
                      'Delete All',
                      style: TextStyle(
                        color: const Color(0xFF1AA8E6),
                        fontSize: hDimen(15),
                      ),
                    ),
                  ),
                  hSpacing(hDimen(20)),
                ],
                leading: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: hDimen(15),
                      ),
                      child: Image.asset(
                        'assets/images/back_btn.png',
                        width: hDimen(25),
                      ),
                    )),
                title: Text(
                  'Notifications',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: hDimen(17),
                  ),
                ),
              ),
            ),
            body: Padding(
              padding: EdgeInsets.only(
                left: hDimen(15),
                right: hDimen(15),
                top: hDimen(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '10 Notifications',
                    style: TextStyle(
                      color: const Color(0xFF92A4AC),
                      fontSize: hDimen(16),
                    ),
                  ),
                  vSpacing(hDimen(20)),
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) => Padding(
                        padding: EdgeInsets.only(bottom: hDimen(10)),
                        child: notificationItem(
                          onDelete: (){},
                          // time: DateTime.now()
                        ),
                      ),
                      itemCount: 10,
                      physics: const BouncingScrollPhysics(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
