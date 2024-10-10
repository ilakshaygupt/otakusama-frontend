import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:otakusama/commons/contants.dart';

class ReadChapterService {
  Future<List<String>> fetchChapterImages(String accessLink) async {
    final response = await http.post(
      Uri.parse('$uri/manga/manga_detail/'),
      body: jsonEncode({'url': accessLink}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body) as Map<String, dynamic>;
      final data = responseData['data'] as List<dynamic>;
      return data.cast<String>().toList();
    } else {
      throw Exception('Failed to load manga: ${response.statusCode}');
    }
  }
}
