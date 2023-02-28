import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../model/http_exception.dart';

class Auth with ChangeNotifier {
  late String _token;
  // this is a token used for keep looged it
  // this token may expire in a given amount of time

  DateTime? _expiryDate;

  String? _userId;

  // method used to sign the user up

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyCSREklATWiUAsh8skQ6DwIjVzd223-m_E';

    // 'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyCSREklATWiUAsh8skQ6DwIjVzd223-m_E'

    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        print(responseData);
        throw HttpExpection(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          // seconds: 0,
          seconds: int.parse(responseData['expiresIn']),
        ),
      );
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  bool get isAuth {
    // return false;
    // print('token: ' + _token);
    // print()
    print('isAuth: ' + token != null);
    return token != '';
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return '';
  }

  Future<void> logIn(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'signUp');
    // const url =
    //     'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyCSREklATWiUAsh8skQ6DwIjVzd223-m_E';

    // final response = await http.post(
    //   Uri.parse(url),
    //   body: json.encode(
    //     {
    //       'email': email as String,
    //       'password': password,
    //       'returnSecureToken': true,
    //     },
    //   ),
    // );
    // print(json.decode(response.body));
  }
}
