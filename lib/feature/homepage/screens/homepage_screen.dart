// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:otakusama/feature/manga_short_preview/manga_short_preview_screen.dart';
import 'package:otakusama/models/manga_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Manga> mangaList = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http
        .get(Uri.parse('https://mangaka.onrender.com/manga/top_manga/'));

    if (response.statusCode == 200) {
      setState(() {
        mangaList = (jsonDecode(response.body) as List)
            .map((item) => Manga.fromJson(item))
            .toList();
      });
    } else {
      throw Exception('Failed to load manga');
    }
  }

  Future<void> searchManga(String searchText) async {
    if (searchText.isEmpty) {
      fetchData();
      return;
    }
    final response = await http.post(
      Uri.parse('https://mangaka.onrender.com/manga/search/'),
      body: jsonEncode({'text': searchText}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      setState(() {
        mangaList = (jsonDecode(response.body) as List)
            .map((item) => Manga.fromJson(item))
            .toList();
      });
    } else {
      throw Exception('Failed to search manga');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('OtakuSama'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              style: const TextStyle(color: Colors.white),
              controller: searchController,
              onSubmitted: (value) {
                searchManga(value);
              },
              decoration: const InputDecoration(
                labelText: 'Search Manga',
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: mangaList.isEmpty
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: mangaList.length,
                    itemBuilder: (context, index) {
                      final manga = mangaList[index];
                      return MangaShortPreview(manga: manga);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
