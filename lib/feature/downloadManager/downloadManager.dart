// ignore: file_names
// ignore: file_names
// ignore_for_file: unused_import, file_names, duplicate_ignore

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:otakusama/commons/http_error.dart';
import 'package:otakusama/models/manga_description_model.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MangaStorageManager {
  Future<void> saveManga(BuildContext context, String mangaName,
      Map<String, dynamic> mangaData) async {
    mangaName = mangaName.replaceAll(' ', '_').replaceAll(':', '_');

    final path = '/storage/emulated/0/Download/OtakuSama/$mangaName/';
    if (!await Directory(path).exists()) {
      await Directory(path).create(recursive: true);
    } else {
      // ignore: use_build_context_synchronously
      showSnackBar(context, 'Manga already downloaded.');
    }

    final mangaDataJson = json.encode(mangaData);
    final mangaDataFile = File('$path/manga_data.json');
    await mangaDataFile.writeAsString(mangaDataJson);
  }

  Future<void> saveChapter(
    BuildContext context,
    MangaDescription mangaDescription,
    String chapterTitle,
    List<String> imageUrls,
  ) async {
    chapterTitle = chapterTitle.replaceAll(' ', '_').replaceAll(':', '_');
    final mangaName =
        mangaDescription.title.replaceAll(' ', '_').replaceAll(':', '_');
    final path = '/storage/emulated/0/Download/OtakuSama/$mangaName';

    final chapterPath = '$path/$chapterTitle';
    if (!await Directory(chapterPath).exists()) {
      await Directory(chapterPath).create(recursive: true);
    }
    final response = await http.get(Uri.parse(mangaDescription.imageLink));
    final imageFile = File('$path/cover.jpg');
    imageFile.writeAsBytesSync(response.bodyBytes);

    final mangaData = {
      'title': mangaDescription.title,
      'description': mangaDescription.description,
      'author': mangaDescription.authors,
      'status': mangaDescription.status,
      'genres': mangaDescription.genres,
      'rating': mangaDescription.rating,
      'updatedTime': mangaDescription.updatedTime,
    };
    final mangaDataFile = File('$path/manga_data.json');
    if (await mangaDataFile.exists()) {
    } else {
      final mangaDataJson = json.encode(mangaData);
      final mangaDataFile = File('$path/manga_data.json');
      await mangaDataFile.writeAsString(mangaDataJson);
    }

    for (int i = 0; i < imageUrls.length; i++) {
      final response = await http.get(Uri.parse(imageUrls[i]), headers: const {
        'User-Agent':
            'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:123.0) Gecko/20100101 Firefox/123.0',
        'Accept': 'image/avif,image/webp,*/*',
        'Accept-Language': 'en-US,en;q=0.5',
        'Accept-Encoding': 'gzip, deflate, br',
        'Referer': 'https://chapmanganato.to/',
      });

      File file = File('$chapterPath/image_$i.jpg');

      await file.writeAsBytes(response.bodyBytes);
      print('Image $i saved');
    }
  }

  Future<bool> doesDirectoryExists(
      BuildContext context, String path, String message) async {
    if (await Directory(path).exists()) {
      showSnackBar(context, message);
      return true;
    }
    return false;
  }
}
