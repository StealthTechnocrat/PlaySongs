import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../repos/visited_repo.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_dimen.dart';

class PlaceVisited extends StatelessWidget {
  const PlaceVisited({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<VisitedRepo>(
        create: (context) => VisitedRepo(),
        builder: (context, snapshot) {
          var workspaceRepo = Provider.of<VisitedRepo>(context, listen: false);
          workspaceRepo.getVisitedList();
          return Consumer<VisitedRepo>(builder: (context, placeVisitedRepo, _) {
            return Container(
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/splash_background.png'),
                    fit: BoxFit.cover),
              ),
              child: placeVisitedRepo.loadingStatus == LoadingStatus.LOADING
                  ? SafeArea(
                      child: Column(
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
                                        'Place visited',
                                        style: TextStyle(
                                          fontFamily: "Rajdhani",
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: hDimen(24),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: 0,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 25),
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
                                  ],
                                ),
                              )),
                          const Expanded(
                              child: Center(
                            child: CircularProgressIndicator(),
                          )),
                        ],
                      ),
                    )
                  : SafeArea(
                      child: Column(
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
                                        'Place visited',
                                        style: TextStyle(
                                          fontFamily: "Rajdhani",
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: hDimen(24),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: 0,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 25),
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
                                  ],
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 15, bottom: 15, top: 15),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Visited Place [${placeVisitedRepo.requestList.length}]",
                                style: TextStyle(
                                  fontFamily: "Rajdhani",
                                  color: const Color(0xFF92A4AC),
                                  fontWeight: FontWeight.w600,
                                  fontSize: hDimen(18),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: placeVisitedRepo.requestList.length,
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
                                var str = placeVisitedRepo
                                    .requestList[index].lastVisitedOn!;
                                DateTime dateTime = DateTime.parse(str).toLocal();
                                var currentViewMonth = dateTime.month;
                                var currentYear = dateTime.year;
                                var day = dateTime.day;
                                var monthName = months[currentViewMonth - 1];

                                return Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 5, left: 8, right: 8),
                                  child: SizedBox(
                                    height: 120,
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        side: const BorderSide(
                                          color: AppColor.cardColorBgBorders,
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
                                              top: 12,
                                              left: 15,
                                              right: 15,
                                            ),
                                            child: Row(
                                              children: [
                                                Text(
                                                  placeVisitedRepo
                                                      .requestList[index]
                                                      .clubName!,
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                                const Spacer(),
                                                Text(
                                                  '$day $monthName, $currentYear',
                                                  style: const TextStyle(
                                                    fontFamily: "Rajdhani",
                                                    color: Color(0xFF92A4AC),
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 13,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 12),
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                    width: 20,
                                                    height: 20,
                                                    child: Image.asset(
                                                        "assets/images/location_y.png")),
                                                const SizedBox(
                                                  width: 3,
                                                ),
                                                Text(
                                                  placeVisitedRepo
                                                      .requestList[index]
                                                      .address!,
                                                  style: const TextStyle(
                                                    fontFamily: "Rajdhani",
                                                    color: Color(0xFF92A4AC),
                                                    fontSize: 13,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          const Spacer(),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15,
                                                right: 15,
                                                bottom: 15),
                                            child: Row(
                                              children: [
                                                const Text(
                                                  "Requested :",
                                                  style: TextStyle(
                                                    fontFamily: "Rajdhani",
                                                    color: Colors.white,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  "${placeVisitedRepo.requestList[index].totalRequests!} songs",
                                                  // '30 songs',
                                                  style: const TextStyle(
                                                    fontFamily: "Rajdhani",
                                                    color: Color(0xFFFBBB16),
                                                    fontSize: 13,
                                                  ),
                                                ),
                                                const Spacer(),
                                                Text(
                                                  "${placeVisitedRepo.requestList[index].numPlayed!} Played",
                                                  style: const TextStyle(
                                                    fontFamily: "Rajdhani",
                                                    color: Color(0xFF1AA8E6),
                                                    fontSize: 13,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                  child: VerticalDivider(
                                                    thickness: 1,
                                                    width: 20,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Text(
                                                  "${placeVisitedRepo.requestList[index].numRejected!} songs",
                                                  style: const TextStyle(
                                                    fontFamily: "Rajdhani",
                                                    color: Color.fromARGB(
                                                        255, 208, 12, 42),
                                                    fontSize: 13,
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
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
            );
          });
        });
  }
}
