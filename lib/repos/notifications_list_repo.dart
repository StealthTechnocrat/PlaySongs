import 'package:flutter/material.dart';

import '../models/notification.dart';
import '../utils/common.dart';
import '../utils/store.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

enum LoadingStatus { IDEAL, LOADING, LOADED }

class NotificationListRepo extends ChangeNotifier {
  _notificationListUrl() => generateUrl('notifications');
  _deleteNotificationListUrl(int notificationId) =>
      generateUrl('del-notification?notification_id=$notificationId');
  _deleteAllNotificationListUrl() => generateUrl('del-notification?type=all');
  _readnotificationListUrl() => generateUrl('read-all-notification');

  List<Notifications> _notificationList = [];

  var _loadingStatus = LoadingStatus.LOADING;

  get loadingStatus => _loadingStatus;

  setLoadingStatus(LoadingStatus status) {
    _loadingStatus = status;
    notifyListeners();
  }

  List<Notifications> get notificationList => _notificationList;

  Future getNotificationList() => getNotificationListFromAPI();
  Future deleteNotificationList(int notificationId) =>
      deleteNotificationFromAPI(notificationId);
  Future deleteAllNotificationList() => deleteAllNotificationFromAPI();

  setNotificationList(List<Notifications> notificationList) {
    _notificationList = notificationList;
    _loadingStatus = LoadingStatus.IDEAL;
    notifyListeners();
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
          print('Notification List ${response0.body.toString()}');
          var response = NotificationModel.fromJson(jsonDecode(response0.body));

          setNotificationList(response.notifications!);
          break;
        }

      default:
        {
          _loadingStatus = LoadingStatus.IDEAL;
          notifyListeners();
        }
    }
  }

  readNotificationListFromAPI() async {
    var userAccessToken = await Store.getToken();
    print(userAccessToken);

    var response0 = await http.get(_readnotificationListUrl(), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': '$userAccessToken',
    });

    switch (response0.statusCode) {
      case 200:
        {
          var response = NotificationModel.fromJson(jsonDecode(response0.body));
          print('Read Notification List ${response0.body.toString()}');
          //setNotificationList(response.notifications!);
          break;
        }

      default:
        {
          //_loadingStatus = LoadingStatus.IDEAL;
          //notifyListeners();
        }
    }
  }

  deleteNotificationFromAPI(int notificationId) async {
    var userAccessToken = await Store.getToken();
    print(userAccessToken);

    var response0 =
        await http.post(_deleteNotificationListUrl(notificationId), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': '$userAccessToken',
    });

    switch (response0.statusCode) {
      case 200:
        {
          var response = NotificationModel.fromJson(jsonDecode(response0.body));
          print(response.toJson());
          setNotificationList(response.notifications!);
          break;
        }

      default:
        {
          _loadingStatus = LoadingStatus.IDEAL;
          notifyListeners();
        }
    }
  }

  deleteAllNotificationFromAPI() async {
    var userAccessToken = await Store.getToken();

    var response0 = await http.post(_deleteAllNotificationListUrl(), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': '$userAccessToken',
    });

    switch (response0.statusCode) {
      case 200:
        {
          var response = NotificationModel.fromJson(jsonDecode(response0.body));
          print(response.toJson());
          setNotificationList(response.notifications!);
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
