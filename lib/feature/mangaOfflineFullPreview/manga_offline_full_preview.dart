// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otakusama/feature/mangaOfflineFullPreview/screens/ReadChapterOffline.dart';

class MangaOfflineFullPreview extends ConsumerStatefulWidget {
  final String mangaPath;

  const MangaOfflineFullPreview({Key? key, required this.mangaPath})
      : super(key: key);

  @override
  ConsumerState<MangaOfflineFullPreview> createState() =>
      _MangaOfflineFullPreviewState();
}

class _MangaOfflineFullPreviewState
    extends ConsumerState<MangaOfflineFullPreview> {
  List<dynamic> mangaList = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getOfflineChapter();
  }

  void getOfflineChapter() async {
    final Directory directory = Directory(widget.mangaPath);
    final List<FileSystemEntity> files = directory.listSync();
    for (final FileSystemEntity file in files) {
      if (file is Directory) {
        final String chapterName = file.path.split('/').last;
        final String chapterPath = file.path;
        print(chapterPath);

        mangaList.add({
          chapterName: chapterPath,
        });
      }
    }
    setState(() {});
  }

  bool showFullDescription = false;

  String truncateDescription(String description) {
    List<String> words = description.split(' ');
    String truncated = words.take(30).join(' ');

    return truncated;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color.fromARGB(255, 25, 26, 31),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: const Color.fromARGB(0, 0, 0, 0),
      ),
      body: SingleChildScrollView(
        child: Center(
            child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 300,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Color.fromARGB(151, 25, 26, 31),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: mangaList.asMap().entries.map((entry) {
                  print(entry);
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReadChapterOffline(
                            chapterPath: entry.value.values.first as String,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      child: Text(
                        'Chapter ${entry.key}',
                        style:
                            const TextStyle(fontSize: 10, color: Colors.white),
                      ),
                      height: 100,
                      width: 140,
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "MORE LIKE THIS",
              style: TextStyle(
                color: Colors.red,
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        )),
      ),
    );
  }
}
