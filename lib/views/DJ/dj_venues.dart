import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../repos/visited_repo.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_dimen.dart';

class DjVenues extends StatelessWidget {
  const DjVenues({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<VisitedRepo>(
        create: (context) => VisitedRepo(),
        builder: (context, snapshot) {
          var workspaceRepo = Provider.of<VisitedRepo>(context, listen: false);
          workspaceRepo.getVisitedList();

          return Consumer<VisitedRepo>(
              builder: (context, visitedDetailsRepo, _) {
            return Container(
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/splash_background.png'),
                    fit: BoxFit.cover),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 20,
                      ),
                      child: 
                      IntrinsicHeight(
                        child: Stack(
                          children: [
                            Align(
                              child: Text(
                                'Venues',
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
                                padding: const EdgeInsets.only(left: 25),
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
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 40, right: 40, top: 20),
                      child: Container(
                        decoration: BoxDecoration(
                            color: const Color(0xFF18191E),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: const Color(0xFF5D4E76))),
                        child: TextFormField(
                          onChanged: (value) {
                            visitedDetailsRepo.searchVenue(value);
                          },
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Search by name',
                              hintStyle: const TextStyle(
                                  color: Color(0xFF92A4AC), fontSize: 17),
                              filled: true,
                              suffixIcon: IconButton(
                                  icon: Image.asset(
                                    'assets/images/search.png',
                                    width: hDimen(25),
                                  ),
                                  onPressed: () {})),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 15, bottom: 15, top: 15),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Visited Place [${visitedDetailsRepo.requestList.length}]",
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
                      child: visitedDetailsRepo.loadingStatus ==
                              LoadingStatus.LOADING
                          ? const Center(child: CircularProgressIndicator())
                          : ListView.builder(
                              itemCount: visitedDetailsRepo.requestList.length,
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
                                var str = visitedDetailsRepo
                                    .requestList[index].lastVisitedOn!;
                                DateTime dateTime = DateTime.parse(str).toLocal();
                                var currentViewMonth = dateTime.month;
                                var currentYear = dateTime.year;
                                var day = dateTime.day;
                                var monthName = months[currentViewMonth - 1];

                                return 
                                
                                Padding(
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
                                                  visitedDetailsRepo
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
                                                    color: Color(0xFF92A4AC),
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 13,
                                                    fontFamily: "Rajdhani",
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
                                                Text(
                                                  visitedDetailsRepo
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
                                                  "Requested:",
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
                                                  "${visitedDetailsRepo.requestList[index].totalRequests!} songs",
                                                  style: const TextStyle(
                                                    fontFamily: "Rajdhani",
                                                    color: Color(0xFFFBBB16),
                                                    fontSize: 13,
                                                  ),
                                                ),
                                                const Spacer(),
                                                Text(
                                                  "${visitedDetailsRepo.requestList[index].numPlayed!} Played",
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
                                                    width: 15,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Text(
                                                  "${visitedDetailsRepo.requestList[index].numRejected!} songs",
                                                  style: const TextStyle(
                                                    fontFamily: "Rajdhani",
                                                    color: Color.fromARGB(
                                                        255, 208, 12, 42),
                                                    fontSize: 13,
                                                  ),
                                                ),
                                                const Spacer(),
                                                const Text(
                                                  "Earned :",
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
                                                  '\$ ${visitedDetailsRepo.requestList[index].totalEarnings!}.00',
                                                  style: const TextStyle(
                                                    fontFamily: "Rajdhani",
                                                    color: Color(0xFFFBBB16),
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
