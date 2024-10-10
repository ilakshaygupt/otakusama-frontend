import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:otakusama/commons/contants.dart';
import 'package:otakusama/models/manga_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeViewModel extends ChangeNotifier {
  List<Manga> topAiring = [];
  List<Manga> topLatest = [];
  bool isLoading = true;

  HomeViewModel() {
    fetchTopAiring();
    fetchLatestUpdated();
  }

  Future<void> fetchTopAiring() async {
    final SharedPreferences prefs =
        await SharedPreferences.getInstance(); // Initialize SharedPreferences

    final String? token = prefs.getString('x-auth-token'); // Retrieve the token

    final response = await http.get(
      Uri.parse('$uri/manga/top_manga/'),
      headers: {
        'Authorization': 'Bearer $token', // Include the token in the headers
        'Content-Type': 'application/json', // optional but recommended
      },
    );
    print("TOKEN $token");
    print(response.body);

    if (response.statusCode == 200) {
      topAiring = (jsonDecode(response.body) as List)
          .map((item) => Manga.fromJson(item))
          .toList();
      isLoading = false;
      notifyListeners();
    } else {
      throw Exception('Failed to load manga');
    }
  }

  Future<void> fetchLatestUpdated() async {
    final response = await http.get(Uri.parse('$uri/manga/latest_updated/'));

    

    if (response.statusCode == 200) {
      topLatest = (jsonDecode(response.body) as List)
          .map((item) => Manga.fromJson(item))
          .toList();
          print(topLatest);
      isLoading = false;
      notifyListeners();
    } else {
      throw Exception('Failed to load manga');
    }
  }
}
