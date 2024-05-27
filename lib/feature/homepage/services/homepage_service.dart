import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:otakusama/commons/contants.dart';
import 'package:otakusama/models/manga_model.dart';

class HomeViewModel extends ChangeNotifier {
  List<Manga> topAiring = [];
  List<Manga> topLatest = [];
  bool isLoading = true;

  HomeViewModel() {
    fetchTopAiring();
    fetchLatestUpdated();
  }

  Future<void> fetchTopAiring() async {
    final response = await http.get(Uri.parse('$uri/manga/top_manga/'));

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
      isLoading = false;
      notifyListeners();
    } else {
      throw Exception('Failed to load manga');
    }
  }
}
