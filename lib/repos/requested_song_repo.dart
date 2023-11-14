import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:music/models/requested_song.dart';
import '../utils/store.dart';
import 'package:music/utils/common.dart';

enum LoadingStatus { IDEAL, LOADING, LOADED }

class RequestedSongsRepo extends ChangeNotifier {
  _requestedSongUrl() => generateUrl('requested-songs');

  String _dropdownValue = 'All Venues';
  String _dropdownValue1 = 'This Month';
  String? searchQuery;
  DateTime? selectedDate;
  bool? djLogin;

  List<RequestList> _requestList = [];
  List<RequestList> _allSearchSong = [];

  final List<RequestList> _rejectedSong = [];
  List<RequestList> _rejectedSearchSong = [];

  final List<RequestList> __acceptedSong = [];
  List<RequestList> _acceptedSearchSong = [];
  final List<String> _venu = [];
  final List<String> _dropDownValue1 = <String>[
    'This Month',
    '7 Days',
    '15 Days',
    '30 Days',
    '3 Months'
  ];

  List<String> _venuName = [];

  var _loadingStatus = LoadingStatus.LOADING;

  get loadingStatus => _loadingStatus;

  setLoadingStatus(LoadingStatus status) {
    _loadingStatus = status;
    notifyListeners();
  }

  List<RequestList> get requestList => _allSearchSong;

  List<RequestList> get rejectedList => _rejectedSearchSong;

  List<RequestList> get acceptedList => _acceptedSearchSong;

  List<String> get vanuList => _venuName;

  List<String> get dropDownValue1 => _dropDownValue1;

  String get dropdownValue => _dropdownValue;

  String get dropdownValue1 => _dropdownValue1;

  Future getRequestList() => getRequestLisFromAPI();

  setSongList(List<RequestList> requestList) {
    _requestList = requestList;

    _allSearchSong = requestList;

    for (var i = 0; i < _requestList.length; i++) {
      if (_requestList[i].status == "rejected") {
        _rejectedSong.add(_requestList[i]);
      }
      _rejectedSearchSong = _rejectedSong;

      if (_requestList[i].status == "accepted" || _requestList[i].status == "played") {
        __acceptedSong.add(_requestList[i]);
      }
      _venu.add('All Venues');
      for (var i = 0; i < _requestList.length; i++) {
        _venu.add(_requestList[i].clubName!);
      }
      _acceptedSearchSong = __acceptedSong;

      _venuName = _venu.toSet().toList();
    }
    if (djLogin!) {
     
      var now = DateTime.now();
      var day = now.day;
      var thisMonth = now.subtract(Duration(days: day));
      searchSong("");
      selectedDate = thisMonth;
      searchList(thisMonth);
    }

    // var now = DateTime.now();
    // var day = now.day;
    // var thisMonth = now.subtract(Duration(days: day));
    // searchSong("");
    // selectedDate = thisMonth;
    // searchList(thisMonth);

    _loadingStatus = LoadingStatus.IDEAL;
    notifyListeners();
  }

  void setDropDownValue(String newValue) {
    _dropdownValue = newValue;
    if (selectedDate != null) {
      searchList(selectedDate);
    } else {
      searchList(null);
    }

    notifyListeners();
  }

  void setDropDownValue1(String newValue) {
    _dropdownValue1 = newValue;

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
        searchSong("");
        selectedDate = thisMonth;
        searchList(thisMonth);

        break;
      case '7 Days':
        selectedDate = now_1w;
        searchList(now_1w);
        break;
      case '15 Days':
        selectedDate = now_15d;

        searchList(now_15d);

        break;
      case '30 Days':
        selectedDate = now_1m;

        searchList(now_1m);

        break;
      case '3 Months':
        selectedDate = now_90d;

        searchList(now_90d);

        break;
    }

    notifyListeners();
  }

  void searchMusicLoverSong(String query) {
    // musicLoverLong(query, dropdownValue);
  }

  void searchSong(String query) {
    if (query == '') {
      searchQuery = null;
    } else {
      searchQuery = query;
    }

    if (selectedDate != null) {
      searchList(selectedDate);
    } else {
      searchList(null);
    }

    // final rejectedSong = _rejectedSong.where((song) {
    //   final songTitle = song.song!.toLowerCase();
    //   final input = query.toLowerCase();
    //   return songTitle.contains(input);
    // }).toList();

    notifyListeners();
  }

  void searchList(DateTime? datetimee) {
    if (searchQuery != null &&
        dropdownValue != 'All Venues' &&
        datetimee == null) {
      final searchSong = _requestList.where((song) {
        final songTitle = song.song!.toLowerCase();
        final clubName = song.clubName!;
        final input = searchQuery!.toLowerCase();
        return songTitle.startsWith(input) && clubName.contains(dropdownValue);
      }).toList();
      _allSearchSong = searchSong;

      final acceptedSong = __acceptedSong.where((song) {
        final songTitle = song.song!.toLowerCase();
        final input = searchQuery!.toLowerCase();
        final clubName = song.clubName!;
        return songTitle.startsWith(input) && clubName.contains(dropdownValue);
      }).toList();

      _acceptedSearchSong = acceptedSong;

      final rejectedSong = _rejectedSong.where((song) {
        final songTitle = song.song!.toLowerCase();
        final input = searchQuery!.toLowerCase();
        final clubName = song.clubName!;
        return songTitle.startsWith(input) && clubName.contains(dropdownValue);
      }).toList();
      _rejectedSearchSong = rejectedSong;

      notifyListeners();
    } else if (searchQuery != null &&
        dropdownValue == 'All Venues' &&
        datetimee == null) {
      final searchSong = _requestList.where((song) {
        final songTitle = song.song!.toLowerCase();
        final input = searchQuery!.toLowerCase();
        return songTitle.startsWith(input);
      }).toList();
      _allSearchSong = searchSong;

      final acceptedSong = __acceptedSong.where((song) {
        final songTitle = song.song!.toLowerCase();
        final input = searchQuery!.toLowerCase();
        return songTitle.startsWith(input);
      }).toList();

      _acceptedSearchSong = acceptedSong;

      final rejectedSong = _rejectedSong.where((song) {
        final songTitle = song.song!.toLowerCase();
        final input = searchQuery!.toLowerCase();
        return songTitle.startsWith(input);
      }).toList();
      _rejectedSearchSong = rejectedSong;
      notifyListeners();
    } else if (searchQuery == null &&
        dropdownValue != 'All Venues' &&
        datetimee == null) {
      final searchSong = _requestList.where((song) {
        final clubName = song.clubName!;
        return clubName.contains(dropdownValue);
      }).toList();
      _allSearchSong = searchSong;

      final acceptedSong = __acceptedSong.where((song) {
        final clubName = song.clubName!;
        return clubName.contains(dropdownValue);
      }).toList();
      _acceptedSearchSong = acceptedSong;

      final rejectedSong = _rejectedSong.where((song) {
        final clubName = song.clubName!;
        return clubName.contains(dropdownValue);
      }).toList();
      _rejectedSearchSong = rejectedSong;

      notifyListeners();
    } else if (searchQuery == null &&
        dropdownValue == 'All Venues' &&
        datetimee != null) {
      var allSong = _requestList.where((element) {
        final date = element.requestedOn!;
        DateTime dateTime = DateTime.parse(date);
        return datetimee.isBefore(dateTime);
      }).toList();
      _allSearchSong = allSong;

      final acceptedSong = __acceptedSong.where((element) {
        final date = element.requestedOn!;
        DateTime dateTime = DateTime.parse(date);
        return datetimee.isBefore(dateTime);
      }).toList();

      _acceptedSearchSong = acceptedSong;

      final rejectedSong = _rejectedSong.where((element) {
        final date = element.requestedOn!;
        DateTime dateTime = DateTime.parse(date);
        return datetimee.isBefore(dateTime);
      }).toList();
      _rejectedSearchSong = rejectedSong;

      notifyListeners();
    } else if (searchQuery == null &&
        dropdownValue != 'All Venues' &&
        datetimee != null) {
      var allSong = _requestList.where((element) {
        final clubName = element.clubName!;
        final date = element.requestedOn!;
        DateTime dateTime = DateTime.parse(date);
        return datetimee.isBefore(dateTime) && clubName.contains(dropdownValue);
      }).toList();
      _allSearchSong = allSong;
      final acceptedSong = __acceptedSong.where((element) {
        final clubName = element.clubName!;
        final date = element.requestedOn!;
        DateTime dateTime = DateTime.parse(date);
        return datetimee.isBefore(dateTime) && clubName.contains(dropdownValue);
      }).toList();
      _acceptedSearchSong = acceptedSong;
      final rejectedSong = _rejectedSong.where((element) {
        final clubName = element.clubName!;
        final date = element.requestedOn!;
        DateTime dateTime = DateTime.parse(date);
        return datetimee.isBefore(dateTime) && clubName.contains(dropdownValue);
      }).toList();
      _rejectedSearchSong = rejectedSong;

      notifyListeners();
    } else if (searchQuery != null &&
        dropdownValue == 'All Venues' &&
        datetimee != null) {
      final searchSong = _requestList.where((song) {
        final songTitle = song.song!.toLowerCase();
        final input = searchQuery!.toLowerCase();
        final date = song.requestedOn!;
        DateTime dateTime = DateTime.parse(date);
        return songTitle.startsWith(input) && datetimee.isBefore(dateTime);
      }).toList();
      _allSearchSong = searchSong;

      final acceptedSong = __acceptedSong.where((song) {
        final songTitle = song.song!.toLowerCase();
        final input = searchQuery!.toLowerCase();
        final date = song.requestedOn!;
        DateTime dateTime = DateTime.parse(date);
        return songTitle.startsWith(input) && datetimee.isBefore(dateTime);
      }).toList();

      _acceptedSearchSong = acceptedSong;

      final rejectedSong = _rejectedSong.where((song) {
        final songTitle = song.song!.toLowerCase();
        final input = searchQuery!.toLowerCase();
        final date = song.requestedOn!;
        DateTime dateTime = DateTime.parse(date);

        return songTitle.startsWith(input) && datetimee.isBefore(dateTime);
      }).toList();
      _rejectedSearchSong = rejectedSong;

      notifyListeners();
    } else if (searchQuery != null &&
        dropdownValue != 'All Venues' &&
        datetimee != null) {
      final searchSong = _requestList.where((song) {
        final songTitle = song.song!.toLowerCase();
        final input = searchQuery!.toLowerCase();
        final clubName = song.clubName!;
        final date = song.requestedOn!;
        DateTime dateTime = DateTime.parse(date);
        return songTitle.startsWith(input) &&
            datetimee.isBefore(dateTime) &&
            clubName.contains(dropdownValue);
      }).toList();
      _allSearchSong = searchSong;

      final acceptedSong = __acceptedSong.where((song) {
        final songTitle = song.song!.toLowerCase();
        final input = searchQuery!.toLowerCase();
        final date = song.requestedOn!;
        final clubName = song.clubName!;

        DateTime dateTime = DateTime.parse(date);
        return songTitle.startsWith(input) &&
            datetimee.isBefore(dateTime) &&
            clubName.contains(dropdownValue);
      }).toList();

      _acceptedSearchSong = acceptedSong;

      final rejectedSong = _rejectedSong.where((song) {
        final songTitle = song.song!.toLowerCase();
        final input = searchQuery!.toLowerCase();
        final date = song.requestedOn!;
        DateTime dateTime = DateTime.parse(date);
        final clubName = song.clubName!;

        return songTitle.startsWith(input) &&
            datetimee.isBefore(dateTime) &&
            clubName.contains(dropdownValue);
      }).toList();
      _rejectedSearchSong = rejectedSong;

      notifyListeners();
    }

    // else if (searchQuery != null && datetimee != null) {
    //   var lastSevenDaysSong = _requestList.where((element) {
    //     final date = element.requestedOn!;
    //     DateTime dateTime = DateTime.parse(date);
    //     final songTitle = element.song!.toLowerCase();
    //     return datetimee.isBefore(dateTime) &&
    //         songTitle.startsWith(searchQuery!);
    //   }).toList();
    //   _allSearchSong = lastSevenDaysSong;

    //   final acceptedSong = __acceptedSong.where((element) {
    //     final songTitle = element.song!.toLowerCase();
    //     final date = element.requestedOn!;
    //     DateTime dateTime = DateTime.parse(date);
    //     return datetimee.isBefore(dateTime) &&
    //         songTitle.startsWith(searchQuery!);
    //   }).toList();

    //   _acceptedSearchSong = acceptedSong;

    //   final rejectedSong = _rejectedSong.where((element) {
    //     final songTitle = element.song!.toLowerCase();
    //     final date = element.requestedOn!;
    //     DateTime dateTime = DateTime.parse(date);
    //     return datetimee.isBefore(dateTime) &&
    //         songTitle.startsWith(searchQuery!);
    //   }).toList();
    //   _rejectedSearchSong = rejectedSong;

    //   notifyListeners();
    // }
    // else if (searchQuery == null && datetimee != null) {
    //   final searchSong = _requestList.where((element) {
    //     final date = element.requestedOn!;
    //     DateTime dateTime = DateTime.parse(date);
    //     return datetimee.isBefore(dateTime);
    //   }).toList();
    //   _allSearchSong = searchSong;
    //   final acceptedSong = __acceptedSong.where((element) {
    //     final date = element.requestedOn!;
    //     DateTime dateTime = DateTime.parse(date);
    //     return datetimee.isBefore(dateTime);
    //   }).toList();
    //   _acceptedSearchSong = acceptedSong;
    //   final rejectedSong = _rejectedSong.where((element) {
    //     final date = element.requestedOn!;
    //     DateTime dateTime = DateTime.parse(date);
    //     return datetimee.isBefore(dateTime);
    //   }).toList();
    //   _rejectedSearchSong = rejectedSong;

    //   notifyListeners();
    // }
  }

  getRequestLisFromAPI() async {
    var userAccessToken = await Store.getToken();
    print(userAccessToken);

    var response0 = await http.get(_requestedSongUrl(), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': '$userAccessToken',
    });

    switch (response0.statusCode) {
      case 200:
        {
          var response = RequestedSong.fromJson(jsonDecode(response0.body));

          setSongList(response.requestList!);

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
