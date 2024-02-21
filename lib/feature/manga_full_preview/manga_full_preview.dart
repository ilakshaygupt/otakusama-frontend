import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:otakusama/feature/read_chapter/read_chapter_screen.dart';
import 'package:otakusama/models/manga_chapter_model.dart';
import 'package:http/http.dart' as http;

class MangaFullPreview extends StatefulWidget {
  final String accessLink;

  const MangaFullPreview({Key? key, required this.accessLink})
      : super(key: key);

  @override
  _MangaFullPreviewState createState() => _MangaFullPreviewState();
}

class _MangaFullPreviewState extends State<MangaFullPreview> {
  List<MangaChapter> mangaList = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.post(
        Uri.parse('https://mangaka.onrender.com/manga/manga_list/'),
        body: jsonEncode({'url': widget.accessLink}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        setState(() {
          mangaList = (jsonDecode(response.body) as List)
              .map((item) => MangaChapter.fromJson(item))
              .toList();
        });
      } else {
        throw Exception('Failed to load manga: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching manga: $error');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to load manga. Please try again later.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Manga List'),
      ),
      body: mangaList.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: mangaList.length,
              itemBuilder: (context, index) {
                final manga = mangaList[index];
                return Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 86, 21, 17),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ListTile(
                    title: Text(
                      manga.chapter,
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ReadChapter(accessLink: manga.chapterLink),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
