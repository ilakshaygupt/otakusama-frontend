// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marquee/marquee.dart';
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
  var mangaDescription;
  var imagePath = '/storage/emulated/0/Download/OtakuSama/';
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getOfflineChapter();
  }

  void getOfflineChapter() async {
    final Directory directory = Directory(widget.mangaPath);

    final File mangaDataFile = File('${widget.mangaPath}/manga_data.json');
    final String mangaData = await mangaDataFile.readAsString();
    final daaa = json.decode(mangaData);
    final List<FileSystemEntity> files = directory.listSync();
    for (final FileSystemEntity file in files) {
      if (file is Directory) {
        final String chapterIndex = file.path.split('/').last;
        final String chapterName = file.path.split('/').reversed.toList()[1];

        final String chapterPath = file.path;
        mangaList.add({
          chapterIndex: chapterPath,
          chapterName: chapterPath,
        });
      }
    }
    String mangaName = daaa['title'];
    mangaName = mangaName.replaceAll(' ', '_').replaceAll(':', '_');

    imagePath = '$imagePath$mangaName/cover.jpg';
    // mangaList.sort((a, b) => int.parse(a.keys.first as String)
    //     .compareTo(int.parse(b.keys.first as String)));

    setState(() {
      mangaDescription = daaa;
    });
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
        title: Text(
          mangaDescription != null ? mangaDescription['title'] : '',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
            child: Column(
          children: <Widget>[
            Stack(
              children: [
                Container(
                  height: 300,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(File(imagePath)),
                      fit: BoxFit.cover,
                    ),
                    gradient: const LinearGradient(
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
            const SizedBox(
              height: 20,
            ),
            Container(
              margin: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.66,
                            child: Container(
                              margin:
                                  const EdgeInsets.only(left: 10, right: 10),
                              width:
                                  MediaQuery.of(context).size.width * 0.66 - 40,
                              height: 40,
                              child: Marquee(
                                fadingEdgeEndFraction: 0.1,
                                fadingEdgeStartFraction: 0.1,
                                text: mangaDescription['title'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                blankSpace:
                                    MediaQuery.of(context).size.width * 0.66 -
                                        40,
                                scrollAxis: Axis.horizontal,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                velocity: 50.0,
                                startPadding: 10.0,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          IconButton(
                            icon: const Icon(Icons.share),
                            color: Colors.white,
                            onPressed: () {},
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.red,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.1,
                          ),
                          const Row(
                            children: [
                              Icon(
                                Icons.remove_red_eye_rounded,
                                color: Colors.red,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            showFullDescription = !showFullDescription;
                          });
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              mangaDescription['description'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                              maxLines: 5,
                              overflow: TextOverflow.ellipsis,
                            ),
                            TextButton(
                              style: ButtonStyle(
                                padding: WidgetStateProperty.all<
                                    EdgeInsetsGeometry>(EdgeInsets.zero),
                              ),
                              onPressed: () {
                                showModalBottomSheet(
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Container(
                                      padding: const EdgeInsets.all(20),
                                      color:
                                          const Color.fromARGB(255, 25, 26, 31),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            mangaDescription['description'],
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              child: const Text(
                                '...View more',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 180, 37, 47),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Chapters',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color.fromARGB(255, 96, 97, 98),
                          ),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                                icon: const Icon(Icons.search),
                                onPressed: () {}),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: mangaList.asMap().entries.map((entry) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReadChapterOffline(
                            chapterName: entry.value.keys.first as String,
                            chapterPath: entry.value.values.first as String,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      height: 100,
                      width: 140,
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        entry.value.keys.first
                            .toString()
                            .replaceAll('_', ' ')
                            .replaceAll(':', ' '),
                        style:
                            const TextStyle(fontSize: 10, color: Colors.white),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
