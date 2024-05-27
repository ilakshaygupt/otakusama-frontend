import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otakusama/commons/connectivity.dart';
import 'package:otakusama/commons/contants.dart';
import 'package:otakusama/commons/http_error.dart';
import 'package:otakusama/models/manga_model.dart';
import 'package:http/http.dart' as http;

final homePageProvider = Provider((ref) => HomepageService(ref: ref));

class HomepageService {
  final Ref _ref;
  HomepageService({required Ref ref}) : _ref = ref;
  Future<List<Manga>> getTopAiring(
    BuildContext context,
  ) async {
    List<Manga> topAiring = [];
    final bool _isConnected = await ConnectivityService().isConnected();
    if (!_isConnected) {
      showSnackBar(context, "No Internet Connection");
      return [];
    }
    try {
      http.Response res = await http.get(Uri.parse("$uri/manga/top_manga/"));
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          final Map<String, dynamic> body = jsonDecode(res.body);
          for (var manga in body['data']) {
            topAiring.add(Manga.fromJson(manga));
          }
        },
      );
    } catch (e) {
      showSnackBar(context, "Something went wrong");
    }

    return topAiring;
  }
}
