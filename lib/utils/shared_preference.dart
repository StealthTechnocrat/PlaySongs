import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreference {
  static const int default_int_value = -999;
  static const double default_double_value = -999.00;

  static Future<bool> saveListPreference(String key, List<String> value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.setStringList(key, value);
    } catch (e) {
      debugPrint('$e?');
      return Future.value(false);
    }
  }

  static Future<bool> saveStringPreference(String key, String value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.setString(key, value);
    } catch (e) {
      debugPrint('$e?');
      return Future.value(false);
    }
  }

  static Future<bool> saveIntPreference(String key, int value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.setInt(key, value);
    } catch (e) {
      debugPrint('$e?');
      return Future.value(false);
    }
  }

  static Future<bool> saveBoolPreference(String key, bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.setBool(key, value);
    } catch (e) {
      debugPrint('$e?');
      return Future.value(false);
    }
  }

  static Future<bool?> saveDoublePreference(String? key, double? value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.setDouble(key!, value!);
    } catch (e) {
      debugPrint('$e?');
      return Future.value(false);
    }
  }


  static Future<List<String>?> getListPreference(String? key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getStringList(key!) ??  /*prefs.getStringList(key) :*/ [];
    } catch (e) {
      debugPrint('$e?');
      return Future.value();
    }
  }

  static Future<String?> getStringPreference(String? key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(key!) != null ? prefs.getString(key) : "";
    } catch (e) {
      debugPrint('$e?');
      return Future.value("");
    }
  }

  static Future<int?> getIntPreference(String? key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(key!) != null ? prefs.getInt(key) : default_int_value;
    } catch (e) {
      debugPrint('$e');
      return Future.value(default_int_value);
    }
  }

  static Future<bool?> getBoolPreference(String? key)  async{
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(key!) != null ? prefs.getBool(key) : false;
    } catch (e) {
      debugPrint('$e');
      return Future.value(false);
    }
  }

  static Future<double?> getDoublePreference(String? key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getDouble(key!) != null
          ? prefs.getDouble(key)
          : default_double_value;
    } catch (e) {
      debugPrint('$e');
      return Future.value(default_double_value);
    }
  }

  static Future<bool> removePreference(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.remove(key);
    } catch (e) {
      debugPrint('$e');
      return Future.value(false);
    }
  }
}
