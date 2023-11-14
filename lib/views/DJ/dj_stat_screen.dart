import 'package:flutter/material.dart';
import 'package:music/utils/app_colors.dart';
import 'package:music/views/DJ/dj_transaction.dart';
import 'package:music/views/notifications_list.dart';
import 'package:provider/provider.dart';
import '../../repos/my_stats_repo.dart';
import '../../utils/app_dimen.dart';
import 'dj_venues.dart';

class DjStatScreen extends StatelessWidget {
  const DjStatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int notification = 6;
    return ChangeNotifierProvider<MyStatsRepo>(
      create: (context) => MyStatsRepo(),
      builder: (context, snapshot) {
        var workspaceRepo = Provider.of<MyStatsRepo>(context, listen: false);
        workspaceRepo.getStatsDetails();
        //_workspaceRepo.getNotificationList();

        return Scaffold(
          body: Consumer<MyStatsRepo>(
            builder: (context, myStatsRepo, _) {
              return ShowStats(
                notification: myStatsRepo.numberOfNotification == null
                    ? 0
                    : myStatsRepo.numberOfNotification!,
                myStats: myStatsRepo,
              );
            },
          ),
        );
      },
      // child: Scaffold(
      //   //body: NoStats(notification: notification),
      //   body: ShowStats(notification: notification),
      // ),
    );
  }
}

class ShowStats extends StatelessWidget {
  const ShowStats({
    Key? key,
    required this.notification,
    required this.myStats,
  }) : super(key: key);

  final int notification;
  final MyStatsRepo myStats;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/splash_background.png'),
            fit: BoxFit.cover),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15, right: 10),
              child: MyStatsAppBar(notification: notification),
            ),
            myStats.loadingStatus == LoadingStatus.LOADING
                ? const Expanded(
                    child: Center(
                    child: CircularProgressIndicator(),
                  ))
                : myStats.myStats?.noAccepted == 0 &&
                        myStats.myStats?.noPlacesVisited == 0 &&
                        myStats.myStats?.noRejected == 0 &&
                        myStats.myStats?.noRequested == 0
                    ? Expanded(
                        child: Column(
                          children: [
                            const Spacer(),
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                    padding: const EdgeInsets.only(),
                                    child: SizedBox(
                                      width: 200,
                                      child: AspectRatio(
                                        aspectRatio: 2.3,
                                        child: Image.asset(
                                          'assets/images/appicon1.png',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    )),
                                const Text(
                                  "There is no record found",
                                  style: TextStyle(
                                    color: Color(0xFF92A4AC),
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "Rajdhani",
                                    fontSize: 16,
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(30.0),
                                  child: Text(
                                    "You did not visit any place or request a song yet. Start visiting clubs and request songs to be played by your favorite DJ",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      fontFamily: "Rajdhani",
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              ],
                            ),
                            const Spacer(
                              flex: 2,
                            ),
                          ],
                        ),
                      )
                    : Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                StatsCard(
                                    count:
                                        myStats.myStats!.noPlacesVisited ?? 0,
                                    title: "Venues Visited",
                                    imagePath: 'assets/images/location_y.png'),
                                StatsCard(
                                    count: myStats.myStats!.noRequested ?? 0,
                                    title: "Requests",
                                    imagePath: 'assets/images/requests.png'),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                StatsCard(
                                    count: myStats.myStats!.noAccepted ?? 0,
                                    title: "Playlist",
                                    imagePath: 'assets/images/audio_y.png'),
                                StatsCard(
                                    count: myStats.myStats!.noRejected ?? 0,
                                    title: "Rejected",
                                    imagePath: 'assets/images/cross_y.png'),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // SizedBox(
                                //   height: 50,
                                // ),
                                const Padding(
                                  padding: EdgeInsets.only(top: 30),
                                  child: Text(
                                    "Earnings to date:",
                                    style: TextStyle(
                                      color: Color(0xFF566B75),
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "Rajdhani",
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 30),
                                  child: Text(
                                    "\$ ${myStats.myStats!.totalAmount}",
                                    style: const TextStyle(
                                      color: Color(0xFFFBBB16),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      fontFamily: "Rajdhani",
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const Transactions()),
                                );
                              },
                              child: const Text(
                                "VIEW TRANSACTIONS",
                                style: TextStyle(
                                  color: Color(0xFF1AA8E6),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                  fontFamily: "Rajdhani",
                                ),
                              ),
                            )
                          ],
                        ),
                      )
          ],
        ),
      ),
    );
  }
}

class StatsCard extends StatelessWidget {
  const StatsCard({
    Key? key,
    required this.count,
    required this.title,
    required this.imagePath,
  }) : super(key: key);
  final int count;
  final String title;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          if (title == "Venues Visited") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DjVenues()),
            );
          }
          if (title == "Requests") {
            Navigator.pushNamed(
                context, arguments: {'initialIndex': 0}, '/RequestedDjSongs');
          }
          if (title == "Playlist") {
            Navigator.pushNamed(
                context, arguments: {'initialIndex': 1}, '/RequestedDjSongs');
          }
          if (title == "Rejected") {
            Navigator.pushNamed(
                context, arguments: {'initialIndex': 2}, '/RequestedDjSongs');
          }
        },
        child: SizedBox(
          height: 160,
          width: 165,
          child: Card(
            shape: RoundedRectangleBorder(
              side: const BorderSide(
                color: AppColor.cardColorBgBorders,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            color: AppColor.cardColorBg,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Stack(
                children: [
                  Center(
                    child: Text(
                      count.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 50,
                        fontFamily: "Rajdhani",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: SizedBox(
                              width: 20,
                              height: 20,
                              child: Image.asset(imagePath)),
                        ),
                        Text(
                          title,
                          style: const TextStyle(
                            color: Color(0xffbac92a4ac),
                            fontWeight: FontWeight.w600,
                            fontFamily: "Rajdhani",
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// class NoStats extends StatelessWidget {
//   const NoStats({
//     Key? key,
//     required this.notification,
//   }) : super(key: key);

//   final int notification;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//         image: DecorationImage(
//             image: AssetImage('assets/images/splash_background.png'),
//             fit: BoxFit.cover),
//       ),
//       child: SafeArea(
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(top: 15, right: 10),
//               child: MyStatsAppBar(notification: notification),
//             ),
//             Expanded(
//               child: Column(
//                 children: [
//                   const Spacer(),
//                   Column(
//                     mainAxisSize: MainAxisSize.max,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Padding(
//                           padding: const EdgeInsets.only(),
//                           child: SizedBox(
//                             width: 200,
//                             child: AspectRatio(
//                               aspectRatio: 2.3,
//                               child: Image.asset(
//                                 'assets/images/appicon1.png',
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           )),
//                       Text(
//                         "There is no record found",
//                         style: GoogleFonts.rajdhani(
//                           textStyle: const TextStyle(
//                             color: Color(0xFF92A4AC),
//                             fontWeight: FontWeight.w600,
//                             fontSize: 16,
//                           ),
//                         ),
//                       ),
//                       Padding(
//                         padding: EdgeInsets.all(30.0),
//                         child: Text(
//                           "You did not visit any place or request a song yet. Start visiting clubs and request songs to be played by your favorite DJ",
//                           style: GoogleFonts.rajdhani(
//                             textStyle: const TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.w500,
//                               fontSize: 16,
//                             ),
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                       )
//                     ],
//                   ),
//                   const Spacer(
//                     flex: 2,
//                   ),
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

class MyStatsAppBar extends StatelessWidget {
  const MyStatsAppBar({
    Key? key,
    required this.notification,
  }) : super(key: key);

  final int notification;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Stack(
        children: [
          Align(
              child: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              'My Stats',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: hDimen(24),
                fontFamily: "Rajdhani",
              ),
            ),
          )),
          // Positioned(
          //     right: 0,
          //     child: Padding(
          //       padding: const EdgeInsets.only(right: 5, left: 10),
          //       child:
          //        InkWell(
          //         onTap: () {
          //           Navigator.push(
          //             context,
          //             MaterialPageRoute(
          //                 builder: (context) => const NotificationsList()),
          //           );
          //         },
          //         child: SizedBox(
          //             width: hDimen(40),
          //             height: hDimen(33),
          //             child: Stack(
          //               children: [
          //                 SizedBox(
          //                   height: hDimen(33),
          //                   child: InkWell(
          //                     child: Image.asset(
          //                       'assets/images/notification.png',
          //                       fit: BoxFit.cover,
          //                     ),
          //                   ),
          //                 ),
          //                 Padding(
          //                   padding: EdgeInsets.only(top: hDimen(5), left: 2),
          //                   child: Align(
          //                     alignment: Alignment.topRight,
          //                     child: Container(
          //                       height: hDimen(25),
          //                       width: hDimen(25),
          //                       decoration: const BoxDecoration(
          //                         color: Color(0xFFFBBB16),
          //                         shape: BoxShape.circle,
          //                       ),
          //                       child: Center(
          //                         child: Text(
          //                           notification.toString(),
          //                           style: TextStyle(
          //                               color: Colors.black,
          //                               fontWeight: FontWeight.bold,
          //                               fontSize: hDimen(16)),
          //                         ),
          //                       ),
          //                     ),
          //                   ),
          //                 )
          //               ],
          //             )),
          //       ),
          //     )),
        ],
      ),
    );
  }
}
