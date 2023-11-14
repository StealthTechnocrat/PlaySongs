import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:music/models/visited_venue.dart';

import '../utils/common.dart';
import '../utils/store.dart';

enum LoadingStatus { IDEAL, LOADING, LOADED }

class VisitedRepo extends ChangeNotifier {
    _visitedUrl() => generateUrl('venues');


  List<VisitedVenues> _requestList = [];
  List<VisitedVenues> _searchList = [];

  var _loadingStatus = LoadingStatus.LOADING;

  get loadingStatus => _loadingStatus;

  setLoadingStatus(LoadingStatus status) {
    _loadingStatus = status;
    notifyListeners();
  }

  List<VisitedVenues> get requestList => _searchList;

  Future getVisitedList() => getVisitedLisFromAPI();

  setVisitedList(List<VisitedVenues> requestList) {
    _requestList = requestList;
    _searchList = requestList;
    _loadingStatus = LoadingStatus.IDEAL;
    notifyListeners();
  }

  void searchVenue(String query) {
    final venu = _requestList.where((element) {
      final name = element.clubName!.toLowerCase();
      final input = query.toLowerCase();
      return name.startsWith(input);
    }).toList();
    _searchList = venu;

    notifyListeners();
  }

  getVisitedLisFromAPI() async {
    var userAccessToken = await Store.getToken();
    print(userAccessToken);

    var response0 = await http.get(_visitedUrl(), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': '$userAccessToken',
    });

    switch (response0.statusCode) {
      case 200:
        {
          var response = VisitedVenue.fromJson(jsonDecode(response0.body));

          setVisitedList(response.visitedVenues!);
          print(response.toJson());

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
