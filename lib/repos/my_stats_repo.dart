import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:music/models/my_stats.dart';
import 'package:music/utils/common.dart';
import '../models/notification.dart';
import '../utils/store.dart';

enum LoadingStatus { IDEAL, LOADING, LOADED }

class MyStatsRepo extends ChangeNotifier {
  statsUrl() => generateUrl('statistics');
  _notificationListUrl() => generateUrl('notifications');


  MyStats? _myStats;
  int? _numberOfNotification;


  var _loadingStatus = LoadingStatus.LOADING;

  get loadingStatus => _loadingStatus;

  setLoadingStatus(LoadingStatus status) {
    _loadingStatus = status;
    notifyListeners();
  }

  MyStats? get myStats => _myStats;
  int? get numberOfNotification => _numberOfNotification;


  Future getStatsDetails() => getStatsDetailsFromAPI();
  Future getNotificationList() => getNotificationListFromAPI();


  setStats(MyStats myStats) {
    _myStats = myStats;
    _loadingStatus = LoadingStatus.IDEAL;
    notifyListeners();
  }

  getStatsDetailsFromAPI() async {
    var userAccessToken = await Store.getToken();
    print(userAccessToken+"xxxxxxxxxx");
    var response0 = await http.get(statsUrl(), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',


      'Authorization': '$userAccessToken',
    });

    switch (response0.statusCode) {
      case 200:
        {
          var response = MyStats.fromJson(jsonDecode(response0.body));
          print(response);
          setStats(response);
          break;
        }

      default:
        {
          _loadingStatus = LoadingStatus.IDEAL;
          notifyListeners();
        }
    }
  }
  getNotificationListFromAPI() async {
    var userAccessToken = await Store.getToken();
    print(userAccessToken);

    var response0 = await http.get(_notificationListUrl(), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': '$userAccessToken',
    });

    switch (response0.statusCode) {
      case 200:
        {
          var response = NotificationModel.fromJson(jsonDecode(response0.body)).notifications?.length;
          _numberOfNotification =  response;
          notifyListeners();
         // setNotificationList(response.notifications!);
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
