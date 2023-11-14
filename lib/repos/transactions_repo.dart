import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/transaction_model.dart';
import '../utils/common.dart';
import '../utils/store.dart';

enum LoadingStatus { IDEAL, LOADING, LOADED }

class TransactionsRepo extends ChangeNotifier {
  _transactionUrl() =>
      generateUrl('transactions?start_date=2022-08-25&end_date=2022-09-01');

  Transaction? _transaction;
  Transaction? _searchTransaction;
  List<Transactions> _transactionList = [];
  List<Transactions> _searchTransactionList = [];
  List<AdminTransactions> __adminTransactionList = [];
  List<AdminTransactions> _adimSearchTransactionList = [];

  List<Transactions>? get transactionList => _searchTransactionList;
  List<AdminTransactions>? get adminTransactionList =>
      _adimSearchTransactionList;

  var _loadingStatus = LoadingStatus.LOADING;

  Transaction? get transaction => _searchTransaction;
  get loadingStatus => _loadingStatus;
  String _dropdownValue = 'This Month';

  final List<String> _dropDownValue = <String>[
    'This Month',
    '7 Days',
    '15 Days',
    '30 Days',
    '3 Months'
  ];
  List<String> get dropDownValue => _dropDownValue;
  String get dropdownValue => _dropdownValue;

  setLoadingStatus(LoadingStatus status) {
    _loadingStatus = status;
    notifyListeners();
  }

  void setDropDownValue(String newValue) {
    _dropdownValue = newValue;
    var now = DateTime.now();

    // DateTime dateTime = DateTime.parse(now.toString());
    // var currentViewMonth = dateTime.month;

    var now_1w = now.subtract(const Duration(days: 7));
    var now_15d = now.subtract(const Duration(days: 15));
    var now_90d = now.subtract(const Duration(days: 90));
    var now_1m = DateTime(now.year, now.month - 1, now.day);
    var day = now.day;
    var thisMonth = now.subtract(Duration(days: day));
    switch (newValue) {
      case 'This Month':
        var now = DateTime.now();
        var month = now.month;
        var day = now.day;
        var year = now.year;
        print("$day $month $year");
        getTransactionList(generateUrl(
            'transactions?start_date=$year-$month-0&end_date=$year-$month-$day'));
        // searchSong("");
        // selectedDate = thisMonth;
        // searchList(thisMonth);
        //searchTransaction(thisMonth);
        break;
      case '7 Days':
        // selectedDate = now_1w;
        // searchList(now_1w);
        var now = DateTime.now();
        var currentMonth = now.month;
        var currentDay = now.day;
        var currentYear = now.year;
        DateTime dateTime = DateTime.now().add(const Duration(days: -7));

        var month = dateTime.month;
        var day = dateTime.day;
        var year = dateTime.year;

        getTransactionList(generateUrl(
            'transactions?start_date=$year-$month-$day&end_date=$currentYear-$currentMonth-$currentDay'));

        // print(nowFiveDaysAgo);

        //  searchTransaction(now_1w);

        break;
      case '15 Days':
        // selectedDate = now_15d;

        // searchList(now_15d);
        //  searchTransaction(now_15d);

        var now = DateTime.now();
        var currentMonth = now.month;
        var currentDay = now.day;
        var currentYear = now.year;
        DateTime dateTime = DateTime.now().add(const Duration(days: -15));

        var month = dateTime.month;
        var day = dateTime.day;
        var year = dateTime.year;

        getTransactionList(generateUrl(
            'transactions?start_date=$year-$month-$day&end_date=$currentYear-$currentMonth-$currentDay'));

        break;
      case '30 Days':
        // selectedDate = now_1m;

        // searchList(now_1m);
        //   searchTransaction(now_1m);

        var now = DateTime.now();
        var currentMonth = now.month;
        var currentDay = now.day;
        var currentYear = now.year;
        DateTime dateTime = DateTime.now().add(const Duration(days: -30));

        var month = dateTime.month;
        var day = dateTime.day;
        var year = dateTime.year;

        getTransactionList(generateUrl(
            'transactions?start_date=$year-$month-$day&end_date=$currentYear-$currentMonth-$currentDay'));

        print("$day $month $year");

        break;
      case '3 Months':
        var now = DateTime.now();
        var currentMonth = now.month;
        var currentDay = now.day;
        var currentYear = now.year;
        DateTime dateTime = DateTime.now().add(const Duration(days: -90));

        var month = dateTime.month;
        var day = dateTime.day;
        var year = dateTime.year;

        getTransactionList(generateUrl(
            'transactions?start_date=$year-$month-$day&end_date=$currentYear-$currentMonth-$currentDay'));

        // print("$day $month $year");

        break;
    }

    notifyListeners();
  }

  void searchTransaction(DateTime? datetimee) {
    // print(_transaction!.transactions!.length);
    // var searchTransaction = _transaction!.transactions!.where((element) {
    //   final date = element.createdAt!;
    //   DateTime dateTime = DateTime.parse(date);
    //   return datetimee!.isBefore(dateTime);
    // }).toList();
    // _searchTransaction!.transactions = searchTransaction;

    // print(_transactionList.length);

    var searchTransaction = _transactionList.where((element) {
      final date = element.createdAt!;
      DateTime dateTime = DateTime.parse(date);
      return datetimee!.isBefore(dateTime);
    }).toList();
    _searchTransactionList = searchTransaction;

    print(__adminTransactionList.length);

    var adminTransactionList = __adminTransactionList.where((element) {
      final date = element.createdAt!;
      DateTime dateTime = DateTime.parse(date);
      return datetimee!.isBefore(dateTime);
    }).toList();
    _adimSearchTransactionList = adminTransactionList;

    print(_adimSearchTransactionList.length);

    notifyListeners();
  }

  Future getTransactionList(dynamic url) => getTransactionListFromAPI(url);

  setTransaction(Transaction transaction) {
    var now = DateTime.now();
    var day = now.day;
    var thisMonth = now.subtract(Duration(days: day));

    _transactionList = transaction.transactions!;
    _searchTransactionList = transaction.transactions!;

    __adminTransactionList = transaction.adminTransactions!;
    _adimSearchTransactionList = transaction.adminTransactions!;

    _transaction = transaction;
    _searchTransaction = transaction;

    _loadingStatus = LoadingStatus.IDEAL;
    //searchTransaction(thisMonth);
    notifyListeners();
  }

  getTransactionListFromAPI(dynamic url) async {
    print(url);
    var userAccessToken = await Store.getToken();
    var response0 = await http.post(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': '$userAccessToken',
    });
    print(response0.body);
    switch (response0.statusCode) {
      case 200:
        {
          var response = Transaction.fromJson(jsonDecode(response0.body));
          setTransaction(response);
          break;
        }
      default:
        {
          _loadingStatus = LoadingStatus.IDEAL;
          notifyListeners();
        }
    }
  }
}
