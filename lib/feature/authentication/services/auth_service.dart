// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:otakusama/commons/contants.dart';
import 'package:otakusama/commons/http_error.dart';
import 'package:otakusama/feature/authentication/screens/login_screen.dart';
import 'package:otakusama/feature/homepage/screens/homepage_screen.dart';
import 'package:otakusama/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

final userProvider = StateProvider<User?>((ref) => null);
final authServiceProvider = Provider((ref) => AuthService(ref: ref));

class AuthService {
  final Ref _ref;

  AuthService({required Ref ref}) : _ref = ref;

  Future<void> signUpUser({
    required BuildContext context,
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      final user = {
        "email": email,
        "password": password,
        "username": username,
      };

      final res = await http.post(
        Uri.parse('$uri/auth/register/'),
        body: user,
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Account created! Login with same credentials');
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ),
          );
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<void> signInUser({
    required BuildContext context,
    required String email,
    required String password,
    required WidgetRef ref,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('$uri/auth/login/'),
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          final user = res.body;
          final userData = jsonDecode(user);

          ref.read(userProvider.notifier).update(
                (state) => User.fromJson(user),
              );

          final pref = await SharedPreferences.getInstance();
          await pref.setString('x-auth-token', userData['access_token']);

          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const HomePage()),
            (route) => false,
          );
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<void> getUserData(BuildContext context) async {
    try {
      final pref = await SharedPreferences.getInstance();
      String? token = pref.getString('x-auth-token');

      if (token == null) {
        pref.setString('x-auth-token', '');
        return;
      }

      final tokenRes = await http.get(
        Uri.parse('$uri/auth/user'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
      );

      _ref.read(userProvider.notifier).update(
            (state) => User.fromJson(tokenRes.body),
          );
    } catch (e) {
      // Silent failure - user will be redirected to login
    }
  }
}
