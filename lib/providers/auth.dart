import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shopapp/models/Exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expireDate;
  String _userID;
  Timer _authTime;
  String useremail;
  String userpassword;

  bool get isAuth {
    return token != null;
  }

  String get getuserId {
    return _userID;
  }

  String get token {
    if (_expireDate != null &&
        _expireDate != DateTime.now() &&
        _token != null) {
      return _token;
    } else {
      return null;
    }
  }

  Future<void> signUp(String email, String password) async {
    useremail = email;
    userpassword = password;
    print(useremail);
    print(userpassword);
    const url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyBx6ptivKDbJV8bfJbIeOSUX_UIuYARSCk';
    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true
          }));
      final responsedata = json.decode(response.body);
      if (responsedata['error'] != null) {
        throw (HttpException(responsedata['error']['message']));
      }
      _token = responsedata['idToken'];
      _userID = responsedata['localId'];
      _expireDate = DateTime.now()
          .add(Duration(seconds: int.parse(responsedata['expiresIn'])));
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userID,
        'expiryDate': _expireDate.toIso8601String(),
        'email': useremail,
        'password': userpassword
      });
      prefs.setString('userData', userData);
      // prefs.setString('userId', _userID);
      // prefs.setString('token', _token);
      // prefs.setString('time', _expireDate.toIso8601String());
    } catch (e) {
      throw e;
    }
  }

  Future<bool> autoLogin() async {
    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extracteduserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(extracteduserData['expiryDate']);
    // if (expiryDate.isBefore(DateTime.now())) {
    //   return false;
    // }

    _userID = extracteduserData['userId'];

    _token = extracteduserData['token'];
    _expireDate = expiryDate;
    useremail = extracteduserData['email'];
    userpassword = extracteduserData['password'];
    if (_authTime != null) {
      _authTime.cancel();
    }
    final timeToExpiry = _expireDate.difference(DateTime.now()).inSeconds;
    //if (timeToExpiry == 0) {
    _authTime = Timer(Duration(seconds: timeToExpiry), () {
      signIn(useremail, userpassword);
      print('idd $_userID');
      print(useremail);
    });

    //}

    notifyListeners();
    // automaticallyLogout();
    return true;
  }

  Future<void> signIn(String email, String password) async {
    useremail = email;
    userpassword = password;
    print(_userID);
    print(useremail);
    print(useremail);
    print(userpassword);

    const url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyBx6ptivKDbJV8bfJbIeOSUX_UIuYARSCk';
    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true
          }));
      final responsedata = json.decode(response.body);
      if (responsedata['error'] != null) {
        throw (HttpException(responsedata['error']['message']));
      }
      _token = responsedata['idToken'];
      _userID = responsedata['localId'];
      _expireDate = DateTime.now()
          .add(Duration(seconds: int.parse(responsedata['expiresIn'])));
      // automaticallyLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userID,
        'expiryDate': _expireDate.toIso8601String(),
        'email': useremail,
        'password': userpassword
      });
      prefs.setString('userData', userData);
      // prefs.setString('id', _userID);
      // prefs.setString('token', _token);
      // prefs.setString('time', _expireDate.toIso8601String());
    } catch (e) {
      throw e;
    }
  }

  Future<void> logout() async {
    _token = null;
    _userID = null;
    _expireDate = null;
    // if (_authTime != null) {
    //   _authTime.cancel();
    //   _authTime = null;
    // }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  // void automaticallyLogout() {
  //   if (_authTime != null) {
  //     _authTime.cancel();
  //   }
  //   final timeToExpiry = _expireDate.difference(DateTime.now()).inSeconds;
  //   _authTime = Timer(Duration(seconds: timeToExpiry), logout);
  // }
}
