import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../repos/transactions_repo.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_dimen.dart';
import '../../utils/common.dart';

class Transactions extends StatelessWidget {
  const Transactions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // String dropdownValue = 'This month';

    MediaQueryData queryData = MediaQuery.of(context);
    return Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/splash_background.png'),
              fit: BoxFit.cover),
        ),
        child: ChangeNotifierProvider<TransactionsRepo>(
            create: (context) => TransactionsRepo(),
            builder: (context, snapshot) {
              var now = DateTime.now();
              var month = now.month;
              var day = now.day;
              var year = now.year;

              var transactionRepo =
                  Provider.of<TransactionsRepo>(context, listen: false);
              transactionRepo.getTransactionList(generateUrl(
                  'transactions?start_date=$year-$month-0&end_date=$year-$month-$day'));
              
              return SafeArea(child: Consumer<TransactionsRepo>(
                  builder: (context, myTransaction, _) {
                return myTransaction.loadingStatus == LoadingStatus.LOADING
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
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
                                      'Transactions',
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
                                      padding: const EdgeInsets.only(left: 14),
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
                            padding: const EdgeInsets.only(
                                bottom: 14, left: 14, right: 14, top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Total Amount",
                                      style: TextStyle(
                                        fontFamily: "Rajdhani",
                                        color: Color(0xFF92A4AC),
                                        fontWeight: FontWeight.w500,
                                        // fontSize: hDimen(18),
                                      ),
                                    ),
                                    Text(
                                      // "\$ 10.00",
                                      "\$ ${myTransaction.transaction!.totalAmount!}",
                                      style: TextStyle(
                                        fontFamily: "Rajdhani",
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: hDimen(19),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  height: 45,
                                  width: 150,
                                  decoration: BoxDecoration(
                                      color: const Color(0xFF18191E),
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(
                                          color: const Color(0xFF5D4E76))),
                                  child: DropdownButtonHideUnderline(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10),
                                      child: DropdownButton<String>(
                                        value: myTransaction.dropdownValue,
                                        dropdownColor: const Color(0xFF18191E),
                                        icon: Image.asset(
                                          'assets/images/arrow_down.png',
                                          width: hDimen(25),
                                        ),
                                        iconSize: 24,
                                        elevation: 16,
                                        style: const TextStyle(
                                            color: Colors.white),
                                        onChanged: (String? newValue) {
                                          myTransaction
                                              .setDropDownValue(newValue!);
                                          // setState(() {
                                          //   dropdownValue = newValue!;
                                          // });
                                        },
                                        items: myTransaction.dropDownValue
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 14, left: 14, right: 14),
                            child: Row(
                              children: [
                                SizedBox(
                                    //  padding: const EdgeInsets.all(4.0),
                                    width: queryData.size.width / 5.6,
                                    // color: Colors.amber,
                                    child: const Text(
                                      "Date",
                                      style: TextStyle(
                                        fontFamily: "Rajdhani",
                                        color: Color(0xFF92A4AC),
                                        fontWeight: FontWeight.w600,
                                        // fontSize: hDimen(18),
                                      ),
                                      // style: TextStyle(fontSize: 18),
                                    )),
                                SizedBox(
                                    // padding: const EdgeInsets.all(4.0),
                                    width: queryData.size.width / 4,
                                    // color: Colors.white,
                                    child: const Text(
                                      "Dj",
                                      style: TextStyle(
                                        fontFamily: "Rajdhani",
                                        color: Color(0xFF92A4AC),
                                        fontWeight: FontWeight.w600,
                                        // fontSize: hDimen(18),
                                      ),
                                      //   style: TextStyle(fontSize: 18),
                                    )),
                                SizedBox(
                                    //  color: Colors.green,
                                    //  padding: const EdgeInsets.all(4.0),
                                    width: queryData.size.width / 7.8,
                                    child: const Text(
                                      "Type",
                                      style: TextStyle(
                                        fontFamily: "Rajdhani",
                                        color: Color(0xFF92A4AC),
                                        fontWeight: FontWeight.w600,
                                        // fontSize: hDimen(18),
                                      ),
                                      // style: TextStyle(fontSize: 18),
                                    )),
                                SizedBox(
                                  // color: Colors.red,
                                  //padding: const EdgeInsets.all(4.0),
                                  width: queryData.size.width / 3.9,
                                  child: const Text(
                                    "Amount[\$]",
                                    style: TextStyle(
                                      color: Color(0xFF92A4AC),
                                      fontWeight: FontWeight.w600,
                                      // fontSize: hDimen(18),
                                    ),
                                  ),
                                  //  style: TextStyle(fontSize: 18),
                                ),
                                SizedBox(
                                    // color: Colors.pink,
                                    // padding: const EdgeInsets.all(4.0),
                                    width: queryData.size.width / 9,
                                    child: const Text(
                                      "ID",
                                      style: TextStyle(
                                        fontFamily: "Rajdhani",
                                        color: Color(0xFF92A4AC),
                                        fontWeight: FontWeight.w600,
                                        // fontSize: hDimen(18),
                                      ),
                                      // style: TextStyle(fontSize: 18),
                                    )),
                              ],
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: myTransaction.transactionList!.length,
                              // itemCount: myTransaction
                              //     .transaction!.transactions!.length,
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

                                var str = myTransaction
                                    .transactionList![index].createdAt;
                                DateTime dateTime = DateTime.parse(str!);

                                var currentViewMonth = dateTime.month;
                                var currentYear = dateTime.year;

                                var day = dateTime.day;
                                //  var monthName = months[currentViewMonth - 1];

                                var height = MediaQuery.of(context).size.height;
                                var width = MediaQuery.of(context).size.width;
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 14, left: 15, right: 14),
                                  child: InkWell(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            contentPadding: EdgeInsets.zero,
                                            //         insetPadding: EdgeInsets.zero,
                                            //         titlePadding: EdgeInsets.zero,
                                            //         buttonPadding: EdgeInsets.zero,
                                            backgroundColor: Colors.transparent,
                                            // title: Text("title"),
                                            content: SizedBox(
                                              height: 440,
                                              width: width - 50,
                                              child: Card(
                                                shape: RoundedRectangleBorder(
                                                  side: const BorderSide(
                                                    color: AppColor
                                                        .cardColorBgBorders,
                                                    width: 1,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                ),
                                                color: AppColor.cardColorBg,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 20,
                                                          left: 20,
                                                          top: 28),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            "Transaction Details",
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  "Rajdhani",
                                                              color: const Color(
                                                                  0xFF92A4AC),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize:
                                                                  hDimen(18),
                                                            ),
                                                          ),
                                                          // Spacer(),
                                                          InkWell(
                                                            onTap: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child:
                                                            Image.asset(
                                                              'assets/images/cross.png',
                                                              width:
                                                              hDimen(25),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
                                                      Text("Transaction ID",
                                                          style: TextStyle(
                                                            fontFamily:
                                                                "Rajdhani",
                                                            color: const Color(
                                                                0xFF92A4AC),
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize:
                                                                hDimen(16),
                                                          )),
                                                      const SizedBox(
                                                        height: 8,
                                                      ),
                                                      Text(
                                                        "# ${myTransaction.transactionList![index].id}",
                                                        style: const TextStyle(
                                                          fontFamily:
                                                              "Rajdhani",
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          // fontSize: hDimen(18),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 15,
                                                      ),
                                                      const Text(
                                                        "Venue",
                                                        style: TextStyle(
                                                          fontFamily:
                                                              "Rajdhani",
                                                          color:
                                                              Color(0xFF92A4AC),
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          // fontSize: hDimen(18),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                        "${myTransaction.transactionList![index].venue}",
                                                        style: TextStyle(
                                                          fontFamily:
                                                              "Rajdhani",
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: hDimen(16),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 8,
                                                      ),
                                                      // const Text(
                                                      //   "11800 Foothill Blvd, Sylmar, CA 91342",
                                                      //   style: TextStyle(
                                                      //     fontFamily:
                                                      //         "Rajdhani",
                                                      //     color: Colors.white,
                                                      //     fontWeight:
                                                      //         FontWeight.w500,
                                                      //     // fontSize: hDimen(18),
                                                      //   ),
                                                      // ),
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          const Text(
                                                            "Date",
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  "Rajdhani",
                                                              color: Color(
                                                                  0xFF92A4AC),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                          Text(
                                                            '$currentViewMonth/$day/$currentYear',
                                                            style:
                                                                const TextStyle(
                                                              fontFamily:
                                                                  "Rajdhani",
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          const Text("DJ",
                                                              style: TextStyle(
                                                                color: Color(
                                                                    0xFF92A4AC),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontFamily:
                                                                    "Rajdhani",
                                                              )),
                                                          Text(
                                                            myTransaction
                                                                .transactionList![
                                                                    index]
                                                                .name!,
                                                            style:
                                                                const TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontFamily:
                                                                  "Rajdhani",
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          const Text(
                                                            "Amount",
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  "Rajdhani",
                                                              color: Color(
                                                                  0xFF92A4AC),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                          Text(
                                                            myTransaction.transactionList![index].usedCredit == 1 ?'Credit' : "\$ ${myTransaction.transactionList![index].totalAmount}",
                                                            style:
                                                                const TextStyle(
                                                              fontFamily:
                                                                  "Rajdhani",
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          const Text(
                                                            "Type",
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  "Rajdhani",
                                                              color: Color(
                                                                  0xFF92A4AC),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                          Text(
                                                            myTransaction
                                                                .transactionList![
                                                                    index]
                                                                .paymentType!,
                                                            style:
                                                                const TextStyle(
                                                              fontFamily:
                                                                  "Rajdhani",
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                        "${myTransaction.transactionList![index].song}",
                                                        style: const TextStyle(
                                                          fontFamily:
                                                              "Rajdhani",
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      // Row(
                                                      //   mainAxisAlignment:
                                                      //       MainAxisAlignment
                                                      //           .spaceBetween,
                                                      //   children: const [
                                                      //     Text(
                                                      //       "Card ending with",
                                                      //       style: TextStyle(
                                                      //         fontFamily:
                                                      //             "Rajdhani",
                                                      //         color: Color(
                                                      //             0xFF92A4AC),
                                                      //         fontWeight:
                                                      //             FontWeight
                                                      //                 .w500,
                                                      //         // fontSize: hDimen(18),
                                                      //       ),
                                                      //     ),
                                                      //     // Spacer(),
                                                      //     Text(
                                                      //       "3424",
                                                      //       style: TextStyle(
                                                      //         fontFamily:
                                                      //             "Rajdhani",
                                                      //         color:
                                                      //             Colors.white,
                                                      //         fontWeight:
                                                      //             FontWeight
                                                      //                 .w500,
                                                      //       ),
                                                      //     )
                                                      //   ],
                                                      // ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      );

                                      // showDialog(
                                      //   context: context,
                                      //   builder: (BuildContext context) {
                                      //     var height = MediaQuery.of(context).size.height;
                                      //     var width = MediaQuery.of(context).size.width;
                                      //     return Expanded(
                                      //       child: AlertDialog(
                                      //         contentPadding: EdgeInsets.zero,
                                      //         insetPadding: EdgeInsets.zero,
                                      //         titlePadding: EdgeInsets.zero,
                                      //         buttonPadding: EdgeInsets.zero,
                                      //         backgroundColor: Colors.transparent,
                                      //         content:

                                      //         // actions: [
                                      //         //   Text("data"),
                                      //         //   FlatButton(
                                      //         //     textColor: Colors.black,
                                      //         //     onPressed: () {},
                                      //         //     child: Text('CANCEL'),
                                      //         //   ),
                                      //         //   FlatButton(
                                      //         //     textColor: Colors.black,
                                      //         //     onPressed: () {},
                                      //         //     child: Text('ACCEPT'),
                                      //         //   ),
                                      //         // ],
                                      //       ),
                                      //     );
                                      //   },
                                      // );
                                    },
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: queryData.size.width / 5.6,
                                          child: Text(
                                            '$currentViewMonth/$day/$currentYear',
                                            style: const TextStyle(
                                              fontFamily: "Rajdhani",
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                            width: queryData.size.width / 4,
                                            child: Text(
                                              myTransaction
                                                  .transactionList![index]
                                                  .name!,
                                              style: const TextStyle(
                                                fontFamily: "Rajdhani",
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            )),
                                        SizedBox(
                                            width: queryData.size.width / 7.8,
                                            child: Text(
                                              myTransaction
                                                  .transactionList![index]
                                                  .paymentType == 'tips' ? 'tip': "request",
                                              style: const TextStyle(
                                                fontFamily: "Rajdhani",
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            )),
                                        SizedBox(
                                            width: queryData.size.width / 3.9,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 25),
                                              child: Text(
                                                  myTransaction
                                                      .transactionList![index]
                                                      .usedCredit == 1 ? 'Credit': myTransaction
                                                    .transactionList![index]
                                                    .totalAmount!
                                                    .toString(),
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  fontFamily: "Rajdhani",
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            )),
                                        SizedBox(
                                            width: queryData.size.width / 9,
                                            child: Text(
                                              myTransaction
                                                  .transactionList![index].id
                                                  .toString(),
                                              style: const TextStyle(
                                                fontFamily: "Rajdhani",
                                                color: Color(0xFF1AA8E6),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
              }));
            }));
  }
}

// class MyAlertDialog extends StatelessWidget {
//   final String title;
//   final String content;
//   final List<Widget> actions;

//   MyAlertDialog({
//     required this.title,
//     required this.content,
//     this.actions = const [],
//   });

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text(
//         title,
//       ),
//       actions: this.actions,
//       content: Text(
//         content,
//       ),
//     );
//   }
// }
