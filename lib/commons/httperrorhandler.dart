import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:otakusama/commons/snackbar.dart';

void httpErrorHandle({
  required http.Response response,
  required BuildContext context,
  required VoidCallback onSuccess,
}) {
  final Map<String, dynamic> body = jsonDecode(response.body);
  if (body['success']) {
    onSuccess();
  } else {
    showSnackBar(context, body['message']);
  }
}