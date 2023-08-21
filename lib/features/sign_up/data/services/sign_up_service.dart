import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../data/data_sources/remote/set_user_data.dart';
import 'package:flutter/material.dart';

class SignInServices {
  Future SignIn(String email, String password, BuildContext ctx) async {
    final String _token;
    final String _userId;

    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=[Your Key]');
    //Note Your Key Must be replaced before runing the program

    try {
      // sending email and password with the url
      final response = await http.post(
        url,
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
        var error = responseData['error']['errors'][0]["message"];
        var errorMessage = 'Authentication failed';
        if (error.toString().contains('EMAIL_EXISTS')) {
          errorMessage = 'This email address is already in use.';
        } else if (error.toString().contains('INVALID_EMAIL')) {
          errorMessage = 'This is not a valid email address';
        } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
          errorMessage = 'Could not find a user with that email.';
        } else if (error.toString().contains('INVALID_PASSWORD')) {
          errorMessage = 'Invalid password.';
        } else if (error.toString().contains('TOO_MANY_ATTEMPTS_TRY_LATER')) {
          errorMessage = 'You have tryed many times ,Try later.';
        } else if (error.toString().contains('WEAK_PASSWORD ')) {
          errorMessage = 'Password should be at least 6 characters.';
        }
        if (errorMessage != null) {
          return [0, errorMessage];
        }
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      //encodeing the data to set in local data base

      final _userData = {
        'token': _token.toString(),
        'userId': _userId.toString(),
      };

      if (_userId != null) {
        SetUserData.setUserData(_userData);

        return [1, _userId]; //1 means not null
      } else {
        return [0, "Please try later"]; //1 means not null
      }
    } catch (error) {
      //if error found then will send to UserNotFound with error to show in SnackBar
      var errorMessage;
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password.';
      } else if (error.toString().contains('TOO_MANY_ATTEMPTS_TRY_LATER')) {
        errorMessage = 'You have tryed many times ,Try later.';
      }
    }
  }
}
