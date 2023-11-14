import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../repos/requested_song_repo.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_dimen.dart';

class RequestedDjSongs extends StatelessWidget {
  const RequestedDjSongs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RequestedSongsRepo>(
        create: (context) => RequestedSongsRepo(),
        builder: (context, snapshot) {
          final arguments = (ModalRoute.of(context)?.settings.arguments ??
              <String, dynamic>{}) as Map;

          var requestedRepo =
              Provider.of<RequestedSongsRepo>(context, listen: false);
          requestedRepo.getRequestList();
          requestedRepo.djLogin = true;
          var searchValue = "";

          return Container(
            // height: double.infinity,
            // width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/splash_background.png'),
                  fit: BoxFit.cover),
            ),
            child: SafeArea(
              child: DefaultTabController(
                initialIndex: arguments['initialIndex'],
                length: 3,
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
                                  'Requested Songs',
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
                        )),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 40, right: 40, top: 20),
                      child: Column(
                        children: [
                          Consumer<RequestedSongsRepo>(
                              builder: (context, requestedRepo, _) {
                            return Container(
                              height: 45,
                              decoration: BoxDecoration(
                                  color: const Color(0xFF18191E),
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                      color: const Color(0xFF5D4E76))),
                              child: TextFormField(
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Search by song',
                                    hintStyle: const TextStyle(
                                        color: Color(0xFF92A4AC), fontSize: 17),
                                    filled: true,
                                    suffixIcon: IconButton(
                                        icon: Image.asset(
                                          'assets/images/search.png',
                                          width: hDimen(25),
                                        ),
                                        onPressed: () {})),
                                onChanged: (query) {
                                  requestedRepo.searchSong(query);
                                  searchValue = query;
                                },
                              ),
                            );
                          }),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Row(
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: Consumer<RequestedSongsRepo>(builder:
                                        (context, requestedSongsRepo, _) {
                                      return Container(
                                        height: 45,
                                        decoration: BoxDecoration(
                                            color: const Color(0xFF18191E),
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            border: Border.all(
                                                color:
                                                    const Color(0xFF5D4E76))),
                                        child: DropdownButtonHideUnderline(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15, right: 15),
                                            child: DropdownButton<String>(
                                              isExpanded: true,
                                              value: requestedSongsRepo
                                                  .dropdownValue,
                                              dropdownColor:
                                                  const Color(0xFF18191E),
                                              icon: Image.asset(
                                                'assets/images/arrow_down.png',
                                                width: hDimen(25),
                                              ),
                                              iconSize: 24,
                                              elevation: 16,
                                              style: const TextStyle(
                                                  color: Colors.white),
                                              onChanged: (String? newValue) {
                                                requestedSongsRepo
                                                    .setDropDownValue(
                                                        newValue!);
                                                // setState(() {
                                                //   dropdownValue = newValue!;
                                                // });
                                              },
                                              items: requestedSongsRepo.vanuList
                                                  .map<
                                                          DropdownMenuItem<
                                                              String>>(
                                                      (String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value,
                                                      overflow: TextOverflow
                                                          .ellipsis),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ),
                                      );
                                    })),
                                Expanded(
                                    flex: 1,
                                    child: Consumer<RequestedSongsRepo>(builder:
                                        (context, requestedSongsRepo, _) {
                                      return Container(
                                        height: 45,
                                        decoration: BoxDecoration(
                                            color: const Color(0xFF18191E),
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            border: Border.all(
                                                color:
                                                    const Color(0xFF5D4E76))),
                                        child: DropdownButtonHideUnderline(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15, right: 15),
                                            child: DropdownButton<String>(
                                              value: requestedSongsRepo
                                                  .dropdownValue1,
                                              dropdownColor:
                                                  const Color(0xFF18191E),
                                              icon: Image.asset(
                                                'assets/images/arrow_down.png',
                                                width: hDimen(25),
                                              ),
                                              iconSize: 24,
                                              elevation: 16,
                                              style: const TextStyle(
                                                  color: Colors.white),
                                              onChanged: (String? newValue) {
                                                requestedSongsRepo
                                                    .setDropDownValue1(
                                                        newValue!);
                                              },
                                              items: requestedSongsRepo
                                                  .dropDownValue1
                                                  .map<
                                                          DropdownMenuItem<
                                                              String>>(
                                                      (String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ),
                                      );
                                    })),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Consumer<RequestedSongsRepo>(
                        builder: (context, requestedRepo, _) {
                      return TabBar(
                        labelColor: const Color(0xFF1AA8E6),
                        automaticIndicatorColorAdjustment: false,
                        unselectedLabelColor: const Color(0xFF92A4AC),
                        indicatorColor: const Color(0xFF1AA8E6),
                        tabs: [
                          Tab(
                              text:
                                  'All Songs [${requestedRepo.requestList.length}]'),
                          Tab(
                              text:
                                  'Played [${requestedRepo.acceptedList.length}]'),
                          Tab(
                              text:
                                  'Rejected [${requestedRepo.rejectedList.length}]'),
                        ],
                      );
                    }),
                    Expanded(
                      child: TabBarView(
                        children: [
                          AllSongs(
                            query: searchValue,
                          ),
                          PlayedSongs(
                            query: searchValue,
                          ),
                          RejectedSong(
                            query: searchValue,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  // void searchSong(String query) {
  //   print(query);
  // }
}

class RejectedSong extends StatelessWidget {
  const RejectedSong({Key? key, required this.query}) : super(key: key);
  final String query;

  @override
  Widget build(BuildContext context) {
    print(query);

    return Consumer<RequestedSongsRepo>(
      builder: (context, requestedRepo, _) {
        // requestedRepo.searchSong(query);
        print(query);
        // requestedRepo.loadingStatus == LoadingStatus.LOADING
        //     ? Container(
        //         child: Expanded(
        //             child: Container(
        //           color: Colors.white,
        //           child: Center(
        //             child: CircularProgressIndicator(),
        //           ),
        //         )),
        //       )
        //     :

        if (requestedRepo.loadingStatus == LoadingStatus.LOADING) {
          return const Expanded(
              child: Center(
            child: CircularProgressIndicator(),
          ));
        } else {
          return ListView.builder(
            itemCount: requestedRepo.rejectedList.length,
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
              var str = requestedRepo.rejectedList[index].requestedOn!;
              print(str);
              DateTime dateTime = DateTime.parse(str).toLocal();
              var currentViewMonth = dateTime.month - 1;
              var currentYear = dateTime.year;
              var day = dateTime.day;
              var monthName = months[currentViewMonth];
              print(
                '$day $monthName, $currentYear',
              );

              return Padding(
                padding: const EdgeInsets.only(bottom: 5, left: 8, right: 8),
                child: SizedBox(
                  height: 130,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        color: AppColor.cardColorBgBorders,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    color: AppColor.cardColorBg,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 8,
                            left: 15,
                            right: 15,
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.all(1), // Border width
                                decoration: const BoxDecoration(
                                    color: Color(0xFFC4C4C4),
                                    shape: BoxShape.circle),
                                child: ClipOval(
                                  child: SizedBox.fromSize(
                                    size: const Size.fromRadius(
                                        18), // Image radius
                                    child: Image.network(
                                        requestedRepo.rejectedList[index]
                                                .avatar!.isEmpty
                                            ? ""
                                            : requestedRepo
                                                .rejectedList[index].avatar!,
                                        fit: BoxFit.cover),
                                    // requestedRepo
                                    //     .requestList[index].avatar ??
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    requestedRepo.rejectedList[index].userName!,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  const SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    requestedRepo.rejectedList[index].clubName!,
                                    style: const TextStyle(
                                        color: Color(0xFF5587D2),
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Column(
                                children: [
                                  Text(
                                    //"21 Apr, 2022",
                                    '$day $monthName, $currentYear',
                                    style: const TextStyle(
                                      fontFamily: "Rajdhani",
                                      color: Color(0xFF92A4AC),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    "",
                                    style: TextStyle(
                                      color: Color(0xFF92A4AC),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 9,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: Image.asset("assets/images/audio_y.png"),
                              ),
                              const SizedBox(
                                width: 6,
                              ),
                              Text(
                                requestedRepo.rejectedList[index].song!,
                                style: const TextStyle(
                                  fontFamily: "Rajdhani",
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, bottom: 12),
                          child: Row(
                            children: [
                              const Text(
                                "Status :",
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
                                requestedRepo.rejectedList[index].status!,
                                style: TextStyle(
                                  color: requestedRepo
                                              .rejectedList[index].status ==
                                          "rejected"
                                      ? const Color(0xFFFF1E1E)
                                      : const Color(0xFF1AA8E6),
                                  fontSize: 13,
                                  fontFamily: "Rajdhani",
                                ),
                              ),
                              const Spacer(),
                              const Text(
                                "Request Fees :",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Text(
                                "\$ ${requestedRepo.rejectedList[index].priceOfThisSong}.00",
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
          );
        }
      },
    );
  }
}

class PlayedSongs extends StatelessWidget {
  const PlayedSongs({Key? key, required this.query}) : super(key: key);
  final String query;

  @override
  Widget build(BuildContext context) {
    print(query);

    return Consumer<RequestedSongsRepo>(
      builder: (context, requestedRepo, _) {
        print(query);
        if (requestedRepo.loadingStatus == LoadingStatus.LOADING) {
          return const Expanded(
              child: Center(
            child: CircularProgressIndicator(),
          ));
        } else {
          return ListView.builder(
            itemCount: requestedRepo.acceptedList.length,
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
              var str = requestedRepo.acceptedList[index].requestedOn!;
              DateTime dateTime = DateTime.parse(str).toLocal();
              var currentViewMonth = dateTime.month - 1;
              var currentYear = dateTime.year;
              var day = dateTime.day;
              var monthName = months[currentViewMonth];
              return Padding(
                padding: const EdgeInsets.only(bottom: 5, left: 8, right: 8),
                child: SizedBox(
                  height: 130,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        color: AppColor.cardColorBgBorders,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    color: AppColor.cardColorBg,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 8,
                            left: 15,
                            right: 15,
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.all(1), // Border width
                                decoration: const BoxDecoration(
                                    color: Color(0xFFC4C4C4),
                                    shape: BoxShape.circle),
                                child: ClipOval(
                                  child: SizedBox.fromSize(
                                    size: const Size.fromRadius(
                                        18), // Image radius
                                    child: Image.network(
                                        requestedRepo.acceptedList[index]
                                                .avatar!.isEmpty
                                            ? "https://cdn.pixabay.com/photo/2014/04/12/14/59/portrait-322470_960_720.jpg"
                                            : requestedRepo
                                                .acceptedList[index].avatar!,
                                        fit: BoxFit.cover),
                                    // requestedRepo
                                    //     .requestList[index].avatar ??
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    requestedRepo.acceptedList[index].userName!,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  const SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    requestedRepo.acceptedList[index].clubName!,
                                    style: const TextStyle(
                                        color: Color(0xFF5587D2),
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Column(
                                children: [
                                  Text(
                                    //"21 Apr, 2022",
                                    '$day $monthName, $currentYear',
                                    style: const TextStyle(
                                      fontFamily: "Rajdhani",
                                      color: Color(0xFF92A4AC),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    "",
                                    style: TextStyle(
                                      fontFamily: "Rajdhani",
                                      color: Color(0xFF92A4AC),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 9,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: Row(
                            children: [
                              SizedBox(
                                  width: 20,
                                  height: 20,
                                  child:
                                      Image.asset("assets/images/audio_y.png")),
                              const SizedBox(
                                width: 6,
                              ),
                              Text(
                                requestedRepo.acceptedList[index].song!,
                                style: const TextStyle(
                                  fontFamily: "Rajdhani",
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, bottom: 12),
                          child: Row(
                            children: [
                              const Text(
                                "Status :",
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
                                requestedRepo.acceptedList[index].status!,
                                style: TextStyle(
                                  color: requestedRepo
                                              .acceptedList[index].status ==
                                          "rejected"
                                      ? const Color(0xFFFF1E1E)
                                      : const Color(0xFF1AA8E6),
                                  fontSize: 13,
                                  fontFamily: "Rajdhani",
                                ),
                              ),
                              const Spacer(),
                              const Text(
                                "Request Fees :",
                                style: TextStyle(
                                  fontFamily: "Rajdhani",
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Text(
                                "\$ ${requestedRepo.acceptedList[index].priceOfThisSong}.00",
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
          );
        }
      },
    );
  }
}

class AllSongs extends StatelessWidget {
  const AllSongs({Key? key, required this.query}) : super(key: key);

  final String query;

  @override
  Widget build(BuildContext context) {
    print(query);

    return Consumer<RequestedSongsRepo>(
      builder: (context, requestedRepo, _) {
        // requestedRepo.searchSong(query);
        print(query);
        // requestedRepo.loadingStatus == LoadingStatus.LOADING
        //     ? Container(
        //         child: Expanded(
        //             child: Container(
        //           color: Colors.white,
        //           child: Center(
        //             child: CircularProgressIndicator(),
        //           ),
        //         )),
        //       )
        //     :

        if (requestedRepo.loadingStatus == LoadingStatus.LOADING) {
          return const Expanded(
              child: Center(
            child: CircularProgressIndicator(),
          ));
        } else {
          return ListView.builder(
            itemCount: requestedRepo.requestList.length,
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
              var str = requestedRepo.requestList[index].requestedOn!;
              DateTime dateTime = DateTime.parse(str).toLocal();
              var currentViewMonth = dateTime.month - 1;
              var currentYear = dateTime.year;
              var day = dateTime.day;
              var monthName = months[currentViewMonth];
              return Padding(
                padding: const EdgeInsets.only(bottom: 5, left: 8, right: 8),
                child: SizedBox(
                  height: 130,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        color: AppColor.cardColorBgBorders,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    color: AppColor.cardColorBg,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 8,
                            left: 15,
                            right: 15,
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.all(1), // Border width
                                decoration: const BoxDecoration(
                                    color: Color(0xFFC4C4C4),
                                    shape: BoxShape.circle),
                                child: ClipOval(
                                  child: SizedBox.fromSize(
                                    size: const Size.fromRadius(
                                        18), // Image radius
                                    child: Image.network(
                                        requestedRepo.requestList[index].avatar!
                                                .isEmpty
                                            ? ""
                                            : requestedRepo
                                                .requestList[index].avatar!,
                                        fit: BoxFit.cover),
                                    // requestedRepo
                                    //     .requestList[index].avatar ??
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    requestedRepo.requestList[index].userName!,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  const SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    requestedRepo.requestList[index].clubName!,
                                    style: const TextStyle(
                                        color: Color(0xFF5587D2),
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Column(
                                children: [
                                  Text(
                                    //"21 Apr, 2022",
                                    '$day $monthName, $currentYear',
                                    style: const TextStyle(
                                      fontFamily: "Rajdhani",
                                      color: Color(0xFF92A4AC),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    "",
                                    style: TextStyle(
                                      fontFamily: "Rajdhani",
                                      color: Color(0xFF92A4AC),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 9,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: Row(
                            children: [
                              SizedBox(
                                  width: 20,
                                  height: 20,
                                  child:
                                      Image.asset("assets/images/audio_y.png")),
                              const SizedBox(
                                width: 6,
                              ),
                              Text(
                                requestedRepo.requestList[index].song!,
                                style: const TextStyle(
                                  fontFamily: "Rajdhani",
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, bottom: 12),
                          child: Row(
                            children: [
                              const Text(
                                "Status :",
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
                                requestedRepo.requestList[index].status!,
                                style: TextStyle(
                                  color:
                                      requestedRepo.requestList[index].status ==
                                              "rejected"
                                          ? const Color(0xFFFF1E1E)
                                          : const Color(0xFF1AA8E6),
                                  fontSize: 13,
                                  fontFamily: "Rajdhani",
                                ),
                              ),
                              const Spacer(),
                              const Text(
                                "Request Fees :",
                                style: TextStyle(
                                  fontFamily: "Rajdhani",
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Text(
                                "\$ ${requestedRepo.requestList[index].priceOfThisSong}.00",
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
          );
        }
      },
    );
  }
}
