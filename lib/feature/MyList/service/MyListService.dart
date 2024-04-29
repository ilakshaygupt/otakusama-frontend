import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:otakusama/commons/http_error.dart';
import 'package:otakusama/models/manga_api_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

final favMangaProvider = StateProvider<List<MangaApiModel>>((ref) => []);
final mangaServiceProvider = Provider((ref) => MangaService(ref: ref));

class MangaService {
  final Ref _ref;

  MangaService({required Ref ref}) : _ref = ref;

  Future<void> addMangaToFav(BuildContext context, String mangaTitle,
      String mangaUrl, String mangaImage) async {
    final favMangaList = _ref.read(favMangaProvider);
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString('x-auth-token');
    if (token == null) {
      pref.setString('x-auth-token', '');
    }
    if (favMangaList.any(
        (manga) => manga.title.toLowerCase() == mangaTitle.toLowerCase())) {
      showSnackBar(context, 'Manga is already in favorites');
    }
    final response = await http.post(
      Uri.parse('https://weblakshay.tech/userdata/add_fav_manga/'),
      headers: {
        'Authorization': 'Bearer $token',
      },
      body: {
        'manga_title': mangaTitle,
        'manga_url': mangaUrl,
        'manga_image': mangaImage,
      },
    );

    MangaApiModel mangaApi = MangaApiModel(
        title: mangaTitle, imageLink: mangaImage, accessLink: mangaUrl);

    if (response.statusCode == 200) {
      _ref.read(favMangaProvider).add(mangaApi);
      print('Manga added to favorites');
    } else if (response.statusCode == 300) {
      throw Exception('Manga is already in favorites');
    } else {
      showSnackBar(context, 'Failed to add manga to favorites');
    }
  }

  Future<List<MangaApiModel>> getFavManga() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString('x-auth-token');
    if (_ref.watch(favMangaProvider).isNotEmpty) {
      return _ref.watch(favMangaProvider);
    }

    final response = await http.get(
      Uri.parse('https://weblakshay.tech/userdata/get_fav_manga/'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      List<MangaApiModel> favManga = [];
      final List<dynamic> mangaData = jsonDecode(response.body);
      for (var manga in mangaData) {
        MangaApiModel mangaModel = MangaApiModel(
            title: manga['manga_title'],
            imageLink: manga['manga_image'],
            accessLink: manga['manga_url']);
        favManga.add(mangaModel);
      }
      for (var manga in favManga) {
        _ref.read(favMangaProvider).add(manga);
      }
      return favManga;
    } else {
      throw Exception('Failed to load favorite manga');
    }
  }

  Future<void> removeFromFavManga(BuildContext context, String mangaTitle) async {
    final favMangaList = _ref.read(favMangaProvider);

    if (!favMangaList.any(
        (manga) => manga.title.toLowerCase() == mangaTitle.toLowerCase())) {
      return;
    }
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString('x-auth-token');
    if (token == null) {
      pref.setString('x-auth-token', '');
    }
    final response = await http.post(
      Uri.parse('https://weblakshay.tech/userdata/delete_fav_manga/'),
      headers: {
        'Authorization': 'Bearer $token',
      },
      body: {
        'manga_title': mangaTitle,
      },
    );

    _ref
        .read(favMangaProvider)
        .removeWhere((manga) => manga.title == mangaTitle);
  }
}
