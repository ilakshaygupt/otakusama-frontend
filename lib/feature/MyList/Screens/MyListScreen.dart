import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otakusama/feature/MyList/service/MyListService.dart';
import 'package:otakusama/feature/manga_full_preview/manga_full_preview.dart';
import 'package:http/http.dart' as http;
import 'package:otakusama/models/manga_api_model.dart';
import 'package:otakusama/models/manga_model.dart';

class MyListScreen extends ConsumerStatefulWidget {
  const MyListScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MyListScreen> createState() => _MyListScreenState();
}

class _MyListScreenState extends ConsumerState<MyListScreen> {
  List<dynamic> favManga = [];
  @override
  void initState() {
    super.initState();
    fetchFavManga();
  }

  Future<void> fetchFavManga() async {
    try {
      final mangaData = await ref.read(mangaServiceProvider).getFavManga();
      if (mounted) {
        // Check if the widget is still mounted
        setState(() {
          favManga = mangaData;

        });
      }
    } catch (e) {
      // Handle error
      print('Error fetching favorite manga: $e');
    }
  }

  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('My List'),
      ),
      body: Center(
        child: favManga.isEmpty
            ? const Text('No manga in your list')
            : ListView.builder(
                itemCount: favManga.length,
                itemBuilder: (context, index) {
                  final manga = favManga[index];

                  return Row(
                    children: [
                      GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MangaFullPreview(
                                  accessLink: manga.accessLink,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            height: 230,
                            width: 150,
                            child: Image.network(manga.imageLink),
                          )),
                      Container(
                        padding: const EdgeInsets.all(10),
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Text(
                          manga.title,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      )
                    ],
                  );
                },
              ),
      ),
    );
  }
}
