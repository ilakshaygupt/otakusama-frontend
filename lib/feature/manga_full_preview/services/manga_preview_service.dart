import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:otakusama/commons/contants.dart';
import 'package:otakusama/models/manga_description_model.dart';
import 'package:otakusama/models/manga_model.dart';

class MangaPreviewService {
  Future<List<Manga>> fetchSimilarManga() async {
    final response = await http.get(Uri.parse('$uri/manga/top_manga/'));

    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List)
          .map((item) => Manga.fromJson(item))
          .toList();
    } else {
      throw Exception('Failed to load similar manga');
    }
  }

  Future<MangaDescription> fetchMangaDetails(String accessLink) async {
    final response = await http.post(
      Uri.parse('$uri/manga/manga_list/'),
      body: jsonEncode({'url': accessLink}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return MangaDescription.fromMap(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load manga: ${response.statusCode}');
    }
  }
}
