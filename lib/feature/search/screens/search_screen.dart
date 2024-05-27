import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:otakusama/commons/contants.dart';
import 'package:otakusama/feature/manga_full_preview/manga_full_preview.dart';
import 'dart:convert';
import 'package:otakusama/models/manga_model.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Manga> mangaList = [];
  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('$uri/manga/top_manga/'));

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
      Uri.parse('$uri/manga/search/'),
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
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0x0ff91a1f),
      appBar: AppBar(
        title: TextField(
          decoration: const InputDecoration(
            hintText: 'Search Manga',
          ),
          onChanged: (value) {
            searchManga(value);
          },
        ),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.7,
        ),
        itemCount: mangaList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MangaFullPreview(
                      accessLink: mangaList[index].accessLink,
                    ),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.only(left: 8, right: 8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                        image: NetworkImage(mangaList[index].image),
                        fit: BoxFit.cover)),
              ),
            ),
          );
        },
      ),
    );
  }
}
