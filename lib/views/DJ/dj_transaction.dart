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
    String dropdownValue = 'This month';

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
                              left: 14,
                              right: 14,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(top: 30),
                                  child: Text(
                                    "Total Earning :",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18,
                                      fontFamily: "Rajdhani",
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 30),
                                  child: Text(
                                    "\$ ${myTransaction.transaction!.totalEarning!}",
                                    // "\$ 428.00",
                                    style: const TextStyle(
                                      fontFamily: "Rajdhani",
                                      color: Color(0xFFFBBB16),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18,
                                    ),
                                  ),
                                )
                              ],
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
                                      "\$ ${myTransaction.transaction!.totalAmount!}",
                                      // "\$ 100.00",
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
                                    width: queryData.size.width / 6.3,
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
                                    width: queryData.size.width / 5.6,
                                    // color: Colors.white,
                                    child: const Text(
                                      "User",
                                      style: TextStyle(
                                        color: Color(0xFF92A4AC),
                                        fontWeight: FontWeight.w600,
                                        // fontSize: hDimen(18),
                                        fontFamily: "Rajdhani",
                                      ),
                                      //   style: TextStyle(fontSize: 18),
                                    )),
                                SizedBox(
                                    // padding: const EdgeInsets.all(4.0),
                                    width: queryData.size.width / 5.8,
                                    // color: Colors.white,
                                    child: const Text(
                                      "Venue",
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
                                    width: queryData.size.width / 9.1,
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
                                    width: queryData.size.width / 4.8,
                                    child: const Text(
                                      "Amount[\$]",
                                      style: TextStyle(
                                        color: Color(0xFF92A4AC),
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "Rajdhani",
                                        // fontSize: hDimen(18),
                                      ),
                                      //  style: TextStyle(fontSize: 18),
                                    )),
                                SizedBox(
                                    // color: Colors.pink,
                                    // padding: const EdgeInsets.all(4.0),
                                    width: queryData.size.width / 10,
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
                              itemBuilder: (context, index) {
                                var height = MediaQuery.of(context).size.height;
                                var width = MediaQuery.of(context).size.width;

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
                                              backgroundColor:
                                                  Colors.transparent,
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
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize:
                                                                  hDimen(16),
                                                            )),
                                                        const SizedBox(
                                                          height: 8,
                                                        ),
                                                        Text(
                                                          "# ${myTransaction.transactionList![index].id}",
                                                          //  "# 4590",
                                                          style:
                                                              const TextStyle(
                                                            fontFamily:
                                                                "Rajdhani",
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w500,
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
                                                            color: Color(
                                                                0xFF92A4AC),
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
                                                            fontSize:
                                                                hDimen(16),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 8,
                                                        ),
                                                        // const Text(
                                                        //   "11800 Foothill Blvd, Sylmar, CA 91342",
                                                        //   style: TextStyle(
                                                        //     color: Colors.white,
                                                        //     fontWeight:
                                                        //         FontWeight.w500,
                                                        //     // fontSize: hDimen(18),
                                                        //     fontFamily:
                                                        //         "Rajdhani",
                                                        //   ),
                                                        // ),
                                                        const SizedBox(
                                                          height: 20,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children:  [
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
                                                                // fontSize: hDimen(18),
                                                              ),
                                                            ),
                                                            // Spacer(),
                                                            Text(
                                                              '$currentViewMonth/$day/$currentYear',
                                                              style: const TextStyle(
                                                                fontFamily:
                                                                    "Rajdhani",
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                // fontSize: hDimen(18),
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
                                                            const Text("Music Lover",
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      "Rajdhani",
                                                                  color: Color(
                                                                      0xFF92A4AC),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                )),
                                                            // Spacer(),
                                                            Text(
                                                              myTransaction
                                                                  .transactionList![
                                                                      index]
                                                                  .name!,
                                                              style:
                                                                  const TextStyle(
                                                                fontFamily:
                                                                    "Rajdhani",
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                // fontSize: hDimen(18),
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
                                                                // fontSize: hDimen(18),
                                                              ),
                                                            ),
                                                            // Spacer(),
                                                            Text(
                                                              myTransaction
                                                                  .transactionList![index]
                                                                  .usedCredit == 1 ? 'Credit': myTransaction
                                                                  .transactionList![index]
                                                                  .totalAmount!
                                                                  .toString(),
                                                              //  "\$ 1.00",
                                                              style:
                                                                  const TextStyle(
                                                                fontFamily:
                                                                    "Rajdhani",
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                // fontSize: hDimen(18),
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
                                                            const Text("Type",
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      "Rajdhani",
                                                                  color: Color(
                                                                      0xFF92A4AC),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  // fontSize: hDimen(18),
                                                                )),
                                                            // Spacer(),
                                                            Text(
                                                              myTransaction
                                                                  .transactionList![
                                                                      index]
                                                                  .paymentType!,
                                                              style:
                                                                  const TextStyle(
                                                                fontFamily:
                                                                    "Rajdhani",
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                         Text(
                                                          "${myTransaction.transactionList![index].song}",
                                                          style: const TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            // fontSize: hDimen(18),
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
                                                        //         "Card ending with",
                                                        //         style:
                                                        //             TextStyle(
                                                        //           color: Color(
                                                        //               0xFF92A4AC),
                                                        //           fontFamily:
                                                        //               "Rajdhani",
                                                        //           fontWeight:
                                                        //               FontWeight
                                                        //                   .w500,
                                                        //         )),
                                                        //     Text(
                                                        //       "3424",
                                                        //       style: TextStyle(
                                                        //         fontFamily:
                                                        //             "Rajdhani",
                                                        //         color: Colors
                                                        //             .white,
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
                                          });
                                    },
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: queryData.size.width / 6.3,
                                          child: Text(
                                            '$currentViewMonth/$day/$currentYear', //"04/21/22",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                              // fontSize: hDimen(13),
                                            ),

                                            // style: TextStyle(fontSize: 18),
                                          ),
                                        ),
                                        SizedBox(
                                          //padding: const EdgeInsets.all(4.0),
                                          width: queryData.size.width / 5.6,
                                          // color: Colors.greenAccent,
                                          child: Padding(
                                            padding: const EdgeInsets.only(right: 5),
                                            child: Text(
                                              myTransaction
                                                  .transactionList![index]
                                                  .name!,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontFamily: "Rajdhani",
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,

                                                // fontSize: hDimen(18),
                                              ),
                                            ),
                                            // style: TextStyle(fontSize: 18),
                                          ),
                                        ),
                                        SizedBox(
                                            //color: Colors.green,
                                            // padding: const EdgeInsets.all(4.0),
                                            width: queryData.size.width / 5.8,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.only(right: 5),
                                              child: Text(
                                                "${myTransaction.transactionList![index].venue}",
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontFamily: "Rajdhani",
                                                  color: Colors.white,
                                                  //fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                  // fontSize: hDimen(13),

                                                  // fontSize: hDimen(18),
                                                ),
                                                //  style: TextStyle(fontSize: 18),
                                              ),
                                            )),
                                        SizedBox(
                                            //color: Colors.green,
                                            // padding: const EdgeInsets.all(4.0),
                                            width: queryData.size.width / 9.3,
                                            child: Text(
                                              myTransaction
                                                  .transactionList![index]
                                                  .paymentType == 'tips' ? 'tip': "song",
                                              style: const TextStyle(
                                                fontFamily: "Rajdhani",
                                                color: Colors.white,
                                                //fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                                // fontSize: hDimen(13),

                                                // fontSize: hDimen(18),
                                              ),

                                              //  style: TextStyle(fontSize: 18),
                                            )),
                                        SizedBox(
                                          //color: Colors.red,
                                          // padding: const EdgeInsets.all(4.0),
                                          width: queryData.size.width / 4.8,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(right: 8),
                                            child: Text(
                                              myTransaction
                                                  .transactionList![index]
                                                  .usedCredit == 1 ? 'Credit': myTransaction
                                                  .transactionList![index]
                                                  .totalAmount!
                                                  .toString(),
                                              textAlign: TextAlign.end,
                                              style: const TextStyle(
                                                fontFamily: "Rajdhani",
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: queryData.size.width / 10,
                                          child: Text(
                                            myTransaction
                                                .transactionList![index].id!
                                                .toString(),
                                            style: const TextStyle(
                                              fontFamily: "Rajdhani",
                                              color: Color(0xFF1AA8E6),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 15, bottom: 25, top: 15),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Paid by Djplaymysong",
                                style: TextStyle(
                                  fontFamily: "Rajdhani",
                                  color: const Color(0xFF92A4AC),
                                  fontWeight: FontWeight.w600,
                                  fontSize: hDimen(18),
                                ),
                              ),
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
                                  ),
                                ),
                                SizedBox(
                                  // padding: const EdgeInsets.all(4.0),
                                  width: queryData.size.width / 5,
                                  // color: Colors.white,
                                  child: const Text(
                                    "Account",
                                    style: TextStyle(
                                      fontFamily: "Rajdhani",
                                      color: Color(0xFF92A4AC),
                                      fontWeight: FontWeight.w600,
                                      // fontSize: hDimen(18),
                                    ),
                                    //   style: TextStyle(fontSize: 18),
                                  ),
                                ),
                                SizedBox(
                                    //  color: Colors.green,
                                    //  padding: const EdgeInsets.all(4.0),
                                    width: queryData.size.width / 5.6,
                                    child: const Text(
                                      "Bank",
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
                                        fontFamily: "Rajdhani",
                                        color: Color(0xFF92A4AC),
                                        fontWeight: FontWeight.w600,
                                        // fontSize: hDimen(18),
                                      ),
                                      //  style: TextStyle(fontSize: 18),
                                    )),
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
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount:
                                  myTransaction.adminTransactionList!.length,
                              itemBuilder: (context, index) {
                                var height = MediaQuery.of(context).size.height;
                                var width = MediaQuery.of(context).size.width;

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
                                    .adminTransactionList![index].createdAt;
                                DateTime dateTime = DateTime.parse(str!);

                                var currentViewMonth = dateTime.month;
                                var currentYear = dateTime.year;
                                var day = dateTime.day;

                                return Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 14, left: 15, right: 14),
                                  child: InkWell(
                                    onTap: () {
                                      // showDialog(
                                      //     context: context,
                                      //     builder: (BuildContext context) {
                                      //       return AlertDialog(
                                      //         contentPadding: EdgeInsets.zero,
                                      //         backgroundColor:
                                      //             Colors.transparent,
                                      //         content: SizedBox(
                                      //           height: 440,
                                      //           width: width - 50,
                                      //           child: Card(
                                      //             shape: RoundedRectangleBorder(
                                      //               side: BorderSide(
                                      //                 color: AppColor
                                      //                     .cardColorBgBorders,
                                      //                 width: 1,
                                      //               ),
                                      //               borderRadius:
                                      //                   BorderRadius.circular(
                                      //                       20.0),
                                      //             ),
                                      //             color: AppColor.cardColorBg,
                                      //             child: Padding(
                                      //               padding:
                                      //                   const EdgeInsets.only(
                                      //                       right: 20,
                                      //                       left: 20,
                                      //                       top: 28),
                                      //               child: Column(
                                      //                 crossAxisAlignment:
                                      //                     CrossAxisAlignment
                                      //                         .start,
                                      //                 children: [
                                      //                   Row(
                                      //                     mainAxisAlignment:
                                      //                         MainAxisAlignment
                                      //                             .spaceBetween,
                                      //                     children: [
                                      //                       Text(
                                      //                         "Transaction Details",
                                      //                         style: TextStyle(
                                      //                           fontFamily:
                                      //                               "Rajdhani",
                                      //                           color: const Color(
                                      //                               0xFF92A4AC),
                                      //                           fontWeight:
                                      //                               FontWeight
                                      //                                   .w600,
                                      //                           fontSize:
                                      //                               hDimen(18),
                                      //                         ),
                                      //                       ),
                                      //                       InkWell(
                                      //                         onTap: () {
                                      //                           Navigator.pop(
                                      //                               context);
                                      //                         },
                                      //                         child:
                                      //                             Image.asset(
                                      //                           'assets/images/cross.png',
                                      //                           width:
                                      //                               hDimen(25),
                                      //                         ),
                                      //                       )
                                      //                     ],
                                      //                   ),
                                      //                   const SizedBox(
                                      //                     height: 20,
                                      //                   ),
                                      //                   Text("Transaction ID",
                                      //                       style: TextStyle(
                                      //                         color: const Color(
                                      //                             0xFF92A4AC),
                                      //                         fontWeight:
                                      //                             FontWeight
                                      //                                 .w500,
                                      //                         fontSize:
                                      //                             hDimen(16),
                                      //                         fontFamily:
                                      //                             "Rajdhani",
                                      //                       )),
                                      //                   const SizedBox(
                                      //                     height: 8,
                                      //                   ),
                                      //                   Text(
                                      //                     myTransaction
                                      //                         .adminTransactionList![
                                      //                             index]
                                      //                         .transactionId!,
                                      //                     //"# 4590",
                                      //                     style:
                                      //                         const TextStyle(
                                      //                       fontFamily:
                                      //                           "Rajdhani",
                                      //                       color: Colors.white,
                                      //                       fontWeight:
                                      //                           FontWeight.w500,
                                      //                     ),
                                      //                   ),
                                      //                   const SizedBox(
                                      //                     height: 15,
                                      //                   ),
                                      //                   const Text(
                                      //                     "Venue",
                                      //                     style: TextStyle(
                                      //                       fontFamily:
                                      //                           "Rajdhani",
                                      //                       color: Color(
                                      //                           0xFF92A4AC),
                                      //                       fontWeight:
                                      //                           FontWeight.w500,
                                      //                     ),
                                      //                   ),
                                      //                   const SizedBox(
                                      //                     height: 10,
                                      //                   ),
                                      //                   Text(
                                      //                     "${myTransaction.transactionList![index].venue}",
                                      //                     style: TextStyle(
                                      //                       fontFamily:
                                      //                           "Rajdhani",
                                      //                       color: Colors.white,
                                      //                       fontWeight:
                                      //                           FontWeight.w500,
                                      //                       fontSize:
                                      //                           hDimen(16),
                                      //                     ),
                                      //                   ),
                                      //                   const SizedBox(
                                      //                     height: 8,
                                      //                   ),
                                      //                   // const Text(
                                      //                   //   "11800 Foothill Blvd, Sylmar, CA 91342",
                                      //                   //   style: TextStyle(
                                      //                   //     fontFamily:
                                      //                   //         "Rajdhani",
                                      //                   //     color: Colors.white,
                                      //                   //     fontWeight:
                                      //                   //         FontWeight.w500,
                                      //                   //   ),
                                      //                   // ),
                                      //                   const SizedBox(
                                      //                     height: 20,
                                      //                   ),
                                      //                   Row(
                                      //                     mainAxisAlignment:
                                      //                         MainAxisAlignment
                                      //                             .spaceBetween,
                                      //                     children: const [
                                      //                       Text(
                                      //                         "Date",
                                      //                         style: TextStyle(
                                      //                           color: Color(
                                      //                               0xFF92A4AC),
                                      //                           fontFamily:
                                      //                               "Rajdhani",
                                      //                           fontWeight:
                                      //                               FontWeight
                                      //                                   .w500,
                                      //                         ),
                                      //                       ),
                                      //                       Text(
                                      //                         "04/21/2022",
                                      //                         style: TextStyle(
                                      //                           fontFamily:
                                      //                               "Rajdhani",
                                      //                           color: Colors
                                      //                               .white,
                                      //                           fontWeight:
                                      //                               FontWeight
                                      //                                   .w500,
                                      //                         ),
                                      //                       )
                                      //                     ],
                                      //                   ),
                                      //                   const SizedBox(
                                      //                     height: 10,
                                      //                   ),
                                      //                   Row(
                                      //                     mainAxisAlignment:
                                      //                         MainAxisAlignment
                                      //                             .spaceBetween,
                                      //                     children: const [
                                      //                       Text("DJ",
                                      //                           style:
                                      //                               TextStyle(
                                      //                             fontFamily:
                                      //                                 "Rajdhani",
                                      //                             color: Color(
                                      //                                 0xFF92A4AC),
                                      //                             fontWeight:
                                      //                                 FontWeight
                                      //                                     .w500,
                                      //                           )),
                                      //                       Text(
                                      //                         "Adam Bravo",
                                      //                         style: TextStyle(
                                      //                           fontFamily:
                                      //                               "Rajdhani",
                                      //                           color: Colors
                                      //                               .white,
                                      //                           fontWeight:
                                      //                               FontWeight
                                      //                                   .w500,
                                      //                         ),
                                      //                       )
                                      //                     ],
                                      //                   ),
                                      //                   const SizedBox(
                                      //                     height: 10,
                                      //                   ),
                                      //                   Row(
                                      //                     mainAxisAlignment:
                                      //                         MainAxisAlignment
                                      //                             .spaceBetween,
                                      //                     children: [
                                      //                       const Text(
                                      //                         "Amount",
                                      //                         style: TextStyle(
                                      //                           color: Color(
                                      //                               0xFF92A4AC),
                                      //                           fontWeight:
                                      //                               FontWeight
                                      //                                   .w500,
                                      //                           fontFamily:
                                      //                               "Rajdhani",
                                      //                         ),
                                      //                       ),
                                      //                       Text(
                                      //                         "\$ ${myTransaction.adminTransactionList![index].amount!}",
                                      //                         // "\$ 1.00",
                                      //                         style:
                                      //                             const TextStyle(
                                      //                           fontFamily:
                                      //                               "Rajdhani",
                                      //                           color: Colors
                                      //                               .white,
                                      //                           fontWeight:
                                      //                               FontWeight
                                      //                                   .w500,
                                      //                         ),
                                      //                       )
                                      //                     ],
                                      //                   ),
                                      //                   const SizedBox(
                                      //                     height: 10,
                                      //                   ),
                                      //                   Row(
                                      //                     mainAxisAlignment:
                                      //                         MainAxisAlignment
                                      //                             .spaceBetween,
                                      //                     children: const [
                                      //                       Text("Type",
                                      //                           style:
                                      //                               TextStyle(
                                      //                             color: Color(
                                      //                                 0xFF92A4AC),
                                      //                             fontWeight:
                                      //                                 FontWeight
                                      //                                     .w500,
                                      //                           )),
                                      //                       Text(
                                      //                         "Song",
                                      //                         style: TextStyle(
                                      //                           color: Colors
                                      //                               .white,
                                      //                           fontFamily:
                                      //                               "Rajdhani",
                                      //                           fontWeight:
                                      //                               FontWeight
                                      //                                   .w500,
                                      //                           // fontSize: hDimen(18),
                                      //                         ),
                                      //                       )
                                      //                     ],
                                      //                   ),
                                      //                   const SizedBox(
                                      //                     height: 10,
                                      //                   ),
                                      //                   const Text(
                                      //                     "All I wanna do is have some fun",
                                      //                     style: TextStyle(
                                      //                       fontFamily:
                                      //                           "Rajdhani",
                                      //                       color: Colors.white,
                                      //                       fontWeight:
                                      //                           FontWeight.w500,
                                      //                       // fontSize: hDimen(18),
                                      //                     ),
                                      //                   ),
                                      //                   const SizedBox(
                                      //                     height: 10,
                                      //                   ),
                                      //                   // Row(
                                      //                   //   mainAxisAlignment:
                                      //                   //       MainAxisAlignment
                                      //                   //           .spaceBetween,
                                      //                   //   children: const [
                                      //                   //     Text(
                                      //                   //         "Card ending with",
                                      //                   //         style:
                                      //                   //             TextStyle(
                                      //                   //           fontFamily:
                                      //                   //               "Rajdhani",
                                      //                   //           color: Color(
                                      //                   //               0xFF92A4AC),
                                      //                   //           fontWeight:
                                      //                   //               FontWeight
                                      //                   //                   .w500,
                                      //                   //           // fontSize: hDimen(18),
                                      //                   //         )),
                                      //                   //     // Spacer(),
                                      //                   //     Text(
                                      //                   //       "3424",
                                      //                   //       style: TextStyle(
                                      //                   //         color: Colors
                                      //                   //             .white,
                                      //                   //         fontFamily:
                                      //                   //             "Rajdhani",
                                      //                   //         fontWeight:
                                      //                   //             FontWeight
                                      //                   //                 .w500,
                                      //                   //         // fontSize: hDimen(18),
                                      //                   //       ),
                                      //                   //     )
                                      //                   //   ],
                                      //                   // ),
                                      //                 ],
                                      //               ),
                                      //             ),
                                      //           ),
                                      //         ),
                                      //       );
                                      //     });
                                    },
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          // padding: const EdgeInsets.all(4.0),
                                          width: queryData.size.width / 5.6,
                                          // color: Colors.amber,
                                          child: Text(
                                            '$currentViewMonth/$day/$currentYear',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: "Rajdhani",
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                            width: queryData.size.width / 5,
                                            child: Text(
                                              myTransaction
                                                  .adminTransactionList![index]
                                                  .accountNo!,
                                              style: const TextStyle(
                                                fontFamily: "Rajdhani",
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            )),
                                        SizedBox(
                                            width: queryData.size.width / 5.6,
                                            child: Text(
                                              myTransaction
                                                  .adminTransactionList![index]
                                                  .bankName!,
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
                                                "${myTransaction.adminTransactionList![index].amount}",
                                                textAlign: TextAlign.end,
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
                                                .adminTransactionList![index]
                                                .transactionId ?? '',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontFamily: "Rajdhani",
                                              color: Color(0xFF1AA8E6),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
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
