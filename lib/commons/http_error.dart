import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    ),
  );
}

void httpErrorHandle({
  required http.Response response,
  required BuildContext context,
  required VoidCallback onSuccess,
}) {
  print(jsonDecode(response.body));
  switch (response.statusCode) {
    case 200:
      onSuccess();
      break;
    case 400:
      if (jsonDecode(response.body)['error'] != null) {
        print(jsonDecode(response.body)['error']);
        showSnackBar(context, jsonDecode(response.body)['error']);
      }
      else{print(jsonDecode(response.body)['message']);
        showSnackBar(context, jsonDecode(response.body)['message']);
      }
      break;
    case 500:
      showSnackBar(context, jsonDecode(response.body)['error']);
      break;
    default:
      showSnackBar(context, response.body);
  }
}
