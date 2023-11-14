import 'package:http/http.dart' as http;
import 'package:music/utils/store.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HttpService extends http.BaseClient {
  var sharedPref;
  HttpService() {
    SharedPreferences.getInstance().then((value) => sharedPref = value);
  }
  String _inMemoryToken = '';
  String get userAccessToken {
    // use in memory token if available
    if (_inMemoryToken.isNotEmpty) return _inMemoryToken;

    // otherwise load it from local storage
    _inMemoryToken = "";
    //_loadTokenFromSharedPreference();

    return _inMemoryToken;
  }

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    request.headers.putIfAbsent('Accept', () => 'application/json');
    var userAccessToken = await Store.getToken();
    if (userAccessToken != null && userAccessToken.isNotEmpty) {
      String formattedToken = userAccessToken.contains('Bearer')
          ? userAccessToken
          : 'Bearer $userAccessToken';
      request.headers.putIfAbsent('Authorization', () => formattedToken);
      print(request.headers);
    }

    return request.send();
  }

  String _loadTokenFromSharedPreference() {
    String? accessToken = '';
    accessToken = sharedPref.getString('access_token');
    return accessToken ?? '';
  }

  // Don't forget to reset the cache when logging out the user
  void reset() {
    _inMemoryToken = '';
  }
}
