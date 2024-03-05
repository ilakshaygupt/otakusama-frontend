// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:otakusama/feature/read_chapter/read_chapter_screen.dart';
import 'package:otakusama/models/manga_chapter_model.dart';
import 'package:http/http.dart' as http;
import 'package:otakusama/models/manga_description_model.dart';
import 'package:marquee/marquee.dart';

import '../../models/manga_model.dart';

class MangaFullPreview extends StatefulWidget {
  final String accessLink;

  const MangaFullPreview({Key? key, required this.accessLink})
      : super(key: key);

  @override
  _MangaFullPreviewState createState() => _MangaFullPreviewState();
}

class _MangaFullPreviewState extends State<MangaFullPreview> {
  List<MangaChapter> mangaList = [];
  MangaDescription? mangaDescription;
  List<MangaChapter> filteredMangaList = [];
  List<Manga> similarMangaList = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData();
    fetchSimilar();
  }

  Future<void> fetchSimilar() async {
    final response = await http
        .get(Uri.parse('https://mangaka.onrender.com/manga/top_manga/'));

    if (response.statusCode == 200) {
      setState(() {
        similarMangaList = (jsonDecode(response.body) as List)
            .map((item) => Manga.fromJson(item))
            .toList();
      });
    } else {
      throw Exception('Failed to load manga');
    }
  }

  void filterMangaChapters(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredMangaList = mangaList;
        return;
      }
      filteredMangaList = mangaList
          .where((manga) =>
              manga.mangaText.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Future<void> fetchData() async {
    try {
      final response = await http.post(
        Uri.parse('https://mangaka.onrender.com/manga/manga_list/'),
        body: jsonEncode({'url': widget.accessLink}),
        headers: {'Content-Type': 'application/json'},
      );

      if (mounted) {
        if (response.statusCode == 200) {
          setState(() {
            mangaDescription =
                MangaDescription.fromMap(jsonDecode(response.body));
            mangaList = mangaDescription!.mangaList.cast<MangaChapter>();
            filteredMangaList = mangaList;
          });
        } else {
          throw Exception('Failed to load manga: ${response.statusCode}');
        }
      }
    } catch (error) {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Failed to load manga. Please try again later.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
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
          child: mangaDescription != null
              ? Column(
                  children: [
                    Stack(
                      children: [
                        FadeInImage.assetNetwork(
                          placeholder: 'assets/downloaded_image.jpg',
                          image: mangaDescription!.imageLink,
                          fit: BoxFit.cover,
                          height: 300,
                          width: MediaQuery.of(context).size.width,
                        ),
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
                    Container(
                      margin: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          mangaDescription != null
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.66,
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                                left: 10, right: 10),
                                            width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.66 -
                                                40,
                                            height: 40,
                                            child: Marquee(
                                              fadingEdgeEndFraction: 0.1,
                                              fadingEdgeStartFraction: 0.1,
                                              text: mangaDescription!.title,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              blankSpace: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.66 -
                                                  40,
                                              scrollAxis: Axis.horizontal,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              velocity: 50.0,
                                              startPadding: 10.0,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                              Icons.bookmark_outline_rounded),
                                          color: Colors.white,
                                          style: ButtonStyle(
                                              iconSize:
                                                  MaterialStateProperty.all(
                                                      30)),
                                          onPressed: () {
                                            
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.share),
                                          color: Colors.white,
                                          onPressed: () {},
                                        ),
                                      ],
                                    ),
                                    // const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.star,
                                              color: Colors.red,
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              mangaDescription!.rating,
                                              style: const TextStyle(
                                                color: Colors.red,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.1,
                                        ),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.remove_red_eye_rounded,
                                              color: Colors.red,
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              mangaDescription!.viewCount,
                                              style: const TextStyle(
                                                color: Colors.red,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: mangaDescription!.genres
                                            .map((genre) {
                                          return Container(
                                            margin: const EdgeInsets.only(
                                                right: 10),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 5),
                                            decoration: BoxDecoration(
                                              color: Colors.grey[800],
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                              genre.name,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          showFullDescription =
                                              !showFullDescription;
                                        });
                                      },
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            mangaDescription!.description,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 13,
                                            ),
                                            maxLines: 5,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          TextButton(
                                            style: ButtonStyle(
                                              padding: MaterialStateProperty
                                                  .all<EdgeInsetsGeometry>(
                                                      EdgeInsets.zero),
                                            ),
                                            onPressed: () {
                                              showModalBottomSheet(
                                                clipBehavior:
                                                    Clip.antiAliasWithSaveLayer,
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            20),
                                                    color: const Color.fromARGB(
                                                        255, 25, 26, 31),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          mangaDescription!
                                                              .description
                                                              .substring(
                                                                  0,
                                                                  min(
                                                                      600,
                                                                      mangaDescription!
                                                                          .description
                                                                          .length)),
                                                          style:
                                                              const TextStyle(
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
                                                color: Color.fromARGB(
                                                    255, 180, 37, 47),
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                )
                              : const Center(
                                  child: CircularProgressIndicator(),
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
                                    color:
                                        const Color.fromARGB(255, 96, 97, 98),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    IconButton(
                                        icon: const Icon(Icons.search),
                                        onPressed: () {}),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.zero,
                                      ),
                                      child: TextField(
                                        style: const TextStyle(
                                            color: Colors.white),
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'Search...',
                                          hintStyle: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        onChanged: (value) {
                                          filterMangaChapters(value);
                                        },
                                      ),
                                    ),
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
                        children:
                            filteredMangaList.asMap().entries.map((entry) {
                          final int index = entry.key;
                          final mangaChapter = entry.value;

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ReadChapter(
                                    mangaChapterList:
                                        mangaDescription!.mangaList,
                                    accessLink: mangaChapter.mangaLink,
                                    chapterId: index,
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
                                mangaChapter.mangaText,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
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
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: similarMangaList.map((manga) {
                          return GestureDetector(
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
                              height: 240,
                              width: 140,
                              margin: const EdgeInsets.only(right: 10),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: FadeInImage.assetNetwork(
                                      placeholder:
                                          'assets/downloaded_image.jpg',
                                      image: manga.image,
                                      fit: BoxFit.cover,
                                      height: 240,
                                      width: 140,
                                    ).image,
                                    opacity: 0.7,
                                    fit: BoxFit.cover),
                                // color: Colors.grey[800],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, top: 180, bottom: 8.0),
                                child: Text(
                                  manga.title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        ),
      ),
    );
  }
}
