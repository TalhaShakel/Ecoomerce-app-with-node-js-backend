import 'dart:convert';

import 'package:amazone_clone/Screens/homeScreen/home_screen.dart';
import 'package:amazone_clone/constants/error_handling.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;

import '../../Models/User.dart';
import '../../PROVIDERS/user_provider.dart';
import '../../constants/global_variables.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/utils.dart';

class AuthService {
  void signUpUser({
    required BuildContext context,
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      EasyLoading.show();
      User user = User(
          id: '',
          name: name,
          password: password,
          email: email,
          address: '',
          type: '',
          token: '',
          cart: []);

      print("""
      name: ${user.name},
      password: ${user.password},
      email: ${user.email},
    """);
      print("Request Body: ${user.toJson()}");

      http.Response res = await http.post(
        Uri.parse('$uri/api/signup'),
        body: user.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (res.statusCode == 200) EasyLoading.showSuccess("Account created");
      EasyLoading.dismiss();

      print("Request: ${res.request}");
      print("Status Code: ${res.statusCode}");

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(
            context,
            'Account created! Login with the same credentials!',
          );
        },
        onBadRequest: () {
          print("Bad Request");
        },
        onUnauthorized: () {
          print("Unauthorized");
        },
        onForbidden: () {
          print("Forbidden");
        },
        onNotFound: () {
          print("Not Found");
        },
        onInternalServerError: () {
          print("Internal Server Error");
        },
        onUnknownError: () {
          print("Unknown Error");
        },
      );
    } catch (e) {
      EasyLoading.dismiss();
      print(e);
      showSnackBar(context, e.toString());
    }
  }

  signInUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      print(1);
      EasyLoading.show();

      User user = User(
          id: "",
          name: "",
          email: email,
          password: password,
          address: '',
          type: '',
          token: '',
          cart: []);
      http.Response res = await http.post(
        Uri.parse('$uri/api/signin'),
        body: user.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      print("Request Body: ${res.body}");
      print("Status Code: ${res.statusCode}");
      if (res.statusCode == 200) EasyLoading.showSuccess("Account signin");
      EasyLoading.dismiss();

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          Provider.of<UserProvider>(context, listen: false).setUser(res.body);
          await prefs.setString('x-auth-token', jsonDecode(res.body)['token']);
          Navigator.pushNamedAndRemoveUntil(
            context,
            HomeScreen.routeName,
            (route) => false,
          );
        },
      );
    } catch (e) {
      EasyLoading.dismiss();
      showSnackBar(context, e.toString());
    }
  }

  void getUserData(
    BuildContext context,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('x-auth-token');
    if (token == null) {
      prefs.setString('x-auth-token', '');
    }
    var tokenRes = await http.post(
      Uri.parse('$uri/tokenIsValid'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': token!
      },
    );
    var response = jsonDecode(tokenRes.body);
    if (response == true) {
      http.Response userRes = await http.get(
        Uri.parse('$uri/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token
        },
      );

      var userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.setUser(userRes.body);
    }
  }
}
