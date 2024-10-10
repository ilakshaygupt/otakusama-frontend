import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:otakusama/commons/contants.dart';
import 'package:otakusama/models/manga_model.dart';

class SearchService {
  Future<List<Manga>> fetchTopManga() async {
    final response = await http.get(Uri.parse('$uri/manga/top_manga/'));

    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List)
          .map((item) => Manga.fromJson(item))
          .toList();
    } else {
      throw Exception('Failed to load manga');
    }
  }

  Future<List<Manga>> searchManga(String searchText) async {
    if (searchText.isEmpty) {
      return fetchTopManga();
    }

    final response = await http.post(
      Uri.parse('$uri/manga/search/'),
      body: jsonEncode({'text': searchText}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List)
          .map((item) => Manga.fromJson(item))
          .toList();
    } else {
      throw Exception('Failed to search manga');
    }
  }
}
