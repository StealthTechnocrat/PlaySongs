import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../repos/notifications_list_repo.dart';
import '../utils/app_colors.dart';
import '../utils/app_dimen.dart';

class NotificationsList extends StatelessWidget {
  const NotificationsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NotificationListRepo>(
        create: (context) => NotificationListRepo(),
        builder: (context, snapshot) {
          var workspaceRepo =
              Provider.of<NotificationListRepo>(context, listen: false);
          workspaceRepo.getNotificationList();
         workspaceRepo.readNotificationListFromAPI();
          return Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/splash_background.png'),
                  fit: BoxFit.cover),
            ),
            child: Consumer<NotificationListRepo>(
                builder: (context, notificationRepo, _) {
              return SafeArea(
                child: notificationRepo.loadingStatus == LoadingStatus.LOADING
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 20,
                            ),
                            child: IntrinsicHeight(
                              child: Stack(
                                children: [
                                  Align(
                                    child: Text(
                                      'Notifications',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: hDimen(24),
                                        fontFamily: "Rajdhani",
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 0,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: GestureDetector(
                                        child: Image.asset(
                                          'assets/images/back_btn.png',
                                          width: hDimen(25),
                                        ),
                                        onTap: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          right: 15, left: 10, top: 5),
                                      child: SizedBox(
                                        // width: hDimen(40),
                                        height: hDimen(33),
                                        child: Stack(
                                          children: [
                                            SizedBox(
                                              height: hDimen(33),
                                              child: InkWell(
                                                onTap: () {
                                                  // Navigator.push(
                                                  //   context,
                                                  //   MaterialPageRoute(
                                                  //       builder: (context) =>
                                                  //           const NotificationsList()),
                                                  // );
                                                },
                                                child: InkWell(
                                                  onTap: () {
                                                    // notificationRepo.deleteAllNotificationList();

                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          title: const Text(
                                                              'Delete Notification'),
                                                          content: const Text(
                                                              "Are You Sure Want To Delete All Notification?"),
                                                          actions: [
                                                            TextButton(
                                                              child: const Text("No"),
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                            ),
                                                            TextButton(
                                                              child:
                                                                  const Text("Yes"),
                                                              onPressed: () {
                                                                notificationRepo
                                                                    .deleteAllNotificationList();
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                            ),
                                                            // FlatButton(
                                                            //   child: Text(
                                                            //       "CANCEL"),
                                                            //   onPressed: () {
                                                            //     Navigator.of(
                                                            //             context)
                                                            //         .pop();
                                                            //   },
                                                            // ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  },
                                                  child: Text(
                                                    'Delete All',
                                                    style: TextStyle(
                                                      fontFamily: "Rajdhani",
                                                      color: const Color(
                                                          0xFF1AA8E6),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: hDimen(13),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 12, top: 12, bottom: 12),
                            child: Text(
                              "${notificationRepo.notificationList.length} Notifications",
                              style: const TextStyle(
                                color: Color(0xFF92A4AC),
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                fontFamily: "Rajdhani",
                              ),
                            ),
                          ),
                          Expanded(
                              child: ListView.builder(
                                  itemCount:
                                      notificationRepo.notificationList.length,
                                  itemBuilder: (context, index) {
                                    List months = [
                                      'Jan',
                                      'Feb',
                                      'Mar',
                                      'Apr',
                                      'May',
                                      'Jun',
                                      'Jul',
                                      'Aug',
                                      'Sep',
                                      'Oct',
                                      'Nov',
                                      'Dec'
                                    ];
                                    var str = notificationRepo
                                        .notificationList[index].createdAt!;
                                    DateTime dateTime = DateTime.parse(str).toLocal();
                                    var currentViewMonth = dateTime.month;
                                    var currentYear = dateTime.year;
                                    var day = dateTime.day;
                                    var monthName =
                                        months[currentViewMonth - 1];

                                    final format = DateFormat.jm();
                                    var time = format.format(dateTime);

                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 5, left: 8, right: 8),
                                      child: SizedBox(
                                        // height: 120,
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            side: const BorderSide(
                                              color:
                                                  AppColor.cardColorBgBorders,
                                              width: 1,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          color: AppColor.cardColorBg,
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 9,
                                                  left: 15,
                                                  right: 10,
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 5),
                                                        child: Text(
                                                          notificationRepo
                                                              .notificationList[
                                                                  index]
                                                              .text!,
                                                          style:
                                                              const TextStyle(
                                                            color: Color(
                                                                0xFFFFFFFF),
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 13,
                                                            fontFamily:
                                                                "Rajdhani",
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        notificationRepo
                                                            .deleteNotificationList(
                                                                notificationRepo
                                                                    .notificationList[
                                                                        index]
                                                                    .id!);
                                                      },
                                                      child: SizedBox(
                                                        width: 30,
                                                        child: Image.asset(
                                                          "assets/images/close.png",
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 5,
                                                    left: 15,
                                                    right: 10,
                                                    bottom: 15),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      '$day $monthName, $currentYear',
                                                      style: const TextStyle(
                                                        color:
                                                            Color(0xFF92A4AC),
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 13,
                                                        fontFamily: "Rajdhani",
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 9,
                                                      child: VerticalDivider(
                                                        thickness: 1,
                                                        width: 15,
                                                        color:
                                                            Color(0xFF92A4AC),
                                                      ),
                                                    ),
                                                    Text(
                                                      time,
                                                      style: const TextStyle(
                                                        color:
                                                            Color(0xFF92A4AC),
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 13,
                                                        fontFamily: "Rajdhani",
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }))
                        ],
                      ),
              );
            }),
          );
        });
  }
}
