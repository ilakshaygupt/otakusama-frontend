// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:otakusama/commons/http_error.dart';
import 'package:otakusama/feature/homepage/screens/homepage_screen.dart';
import 'package:otakusama/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FavMangaProvider = StateProvider<List<String>?>((ref) => null);
// final authServiceProvider = Provider((ref) => AuthService(ref: ref));

class MangaService {
  final Ref _ref;
  MangaService({required Ref ref}) : _ref = ref;

  Future<void> addMangaToFav(BuildContext context, String mangaId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString('x-auth-token');
    if (token == null) {
      pref.setString('x-auth-token', '');
    }
    final response = await http.post(
      Uri.parse('https://otakusama.com/api/v1/manga/favorite'),
      headers: {
        'Authorization': 'Bearer $token',
      },
      body: {
        'manga_id': mangaId,
      },
    );
    httpErrorHandle(
      response: response,
      context: context,
      onSuccess: () {
        final favManga = _ref.read(FavMangaProvider);
        favManga?.add(mangaId);
      },
    );
  }
}
