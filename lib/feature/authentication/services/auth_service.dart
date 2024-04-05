// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:otakusama/commons/http_error.dart';
import 'package:otakusama/feature/homepage/screens/homepage_screen.dart';
import 'package:otakusama/main.dart';
import 'package:otakusama/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  void signUpUser({
    required BuildContext context,
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      var user = {"email": email, "password": password, "username": username};

      http.Response res = await http.post(
        Uri.parse('https://weblakshay.tech/admin/register/'),
        body: user,
      );
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(
              context, 'Account created ! Login with same credentials');
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void signInUser(
      {required BuildContext context,
      required String email,
      required String password,
      required WidgetRef ref}) async {
    try {
      http.Response res = await http.post(
        Uri.parse('https://weblakshay.tech/admin/login'),
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      // ignore: use_build_context_synchronously
      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () async {
            final user = res.body;
            ref.read(userProvider.notifier).update(
                  (state) => User.fromJson(user),
                );
            SharedPreferences pref = await SharedPreferences.getInstance();
            await pref.setString('x-auth-token', jsonDecode(res.body)['token']);
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => HomePage()));
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void getUserData(BuildContext context, WidgetRef ref) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? token = pref.getString('x-auth-token');
      if (token == null) {
        pref.setString('x-auth-token', '');
      }

      var tokenRes = await http.post(
          Uri.parse('https://weblakshay.tech/tokenIsValid/'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token!
          });
      var response = jsonDecode(tokenRes.body);
      if (response == true) {
        http.Response userRes = await http.get(
            Uri.parse('https://weblakshay.tech/user/'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'x-auth-token': token
            });
        ref.read(userProvider.notifier).update(
              (state) => User.fromJson(userRes.body),
            );
      }
    } catch (e) {
      // showSnackBar(context, e.toString());
    }
  }
}
