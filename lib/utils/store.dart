// ignore_for_file: unused_element

import 'dart:convert';

import 'package:music/models/bank_account_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';

class Store {
  static Future getToken() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString('access_token');
    } catch (_) {
      print('Exception occured in getToken');
    }
    return '';
  }

  static Future setToken(token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', "Bearer " + token);
    return true;
  }

  static Future getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      var userObj = prefs.getString('user');
      if (userObj != null) {
        return json.decode(userObj) as Map<String,dynamic>;
      }
    } on Exception catch (_) {
      print('Exception occured in getUser');
    }
    return null;
  }

  static Future setUser(userObj) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var user = User.fromJson(userObj);
    await prefs.setString('user', json.encode(user));
    return true;
  }

  static Future setUser2(userObj) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', json.encode(userObj));
    return true;
  }

  static Future clearStorage() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('user');
    prefs.remove('access_token');
    return true;
  }

  static Future getBank() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      var bankObj = prefs.getString('bank_details');
      if (bankObj != null) {
        return json.decode(bankObj) as Map<String,dynamic>;
      }
    } on Exception catch (_) {
      print('Exception occured in getUser');
    }
    return null;
  }

  static Future setBank(bankObj) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var bank = BankAccountModel.fromJson(bankObj);
    await prefs.setString('bank_details', json.encode(bank));
    return true;
  }
}
