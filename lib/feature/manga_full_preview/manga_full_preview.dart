import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marquee/marquee.dart';
import 'package:otakusama/feature/MyList/service/MyListService.dart';
import 'package:otakusama/feature/downloadManager/downloadManager.dart';
import 'package:otakusama/feature/manga_full_preview/services/manga_preview_service.dart';
import 'package:otakusama/feature/manga_full_preview/widgets/all_chapters_section.dart';
import 'package:otakusama/feature/read_chapter/read_chapter_screen.dart';
import 'package:otakusama/models/manga_chapter_model.dart';
import 'package:otakusama/models/manga_description_model.dart';

import '../../models/manga_model.dart';

class MangaFullPreview extends ConsumerStatefulWidget {
  final String accessLink;

  const MangaFullPreview({Key? key, required this.accessLink})
      : super(key: key);

  @override
  ConsumerState<MangaFullPreview> createState() => _MangaFullPreviewState();
}

class _MangaFullPreviewState extends ConsumerState<MangaFullPreview> {
  late bool isFavourite;
  final MangaPreviewService _mangaService = MangaPreviewService();
  bool _isLoading = true;

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
    try {
      final results = await _mangaService.fetchSimilarManga();
      if (mounted) {
        setState(() {
          similarMangaList = results;
        });
      }
    } catch (e) {
      // Handle error
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
    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _mangaService.fetchMangaDetails(widget.accessLink);

      if (mounted) {
        setState(() {
          mangaDescription = result;
          mangaList = mangaDescription!.mangaList.cast<MangaChapter>();
          filteredMangaList = mangaList;
          _isLoading = false;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        // Show error dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content:
                const Text('Failed to load manga. Please try again later.'),
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
  }

  bool showFullDescription = false;

  String truncateDescription(String description) {
    List<String> words = description.split(' ');
    String truncated = words.take(30).join(' ');

    return truncated;
  }

  @override
  Widget build(BuildContext context) {
    isFavourite = ref
        .watch(favMangaProvider)
        .any((manga) => manga.accessLink == widget.accessLink);
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color.fromARGB(255, 25, 26, 31),
      appBar: AppBar(
        title: Text(
          mangaDescription == null ? '' : mangaDescription!.title,
          style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        shadowColor: const Color.fromARGB(0, 0, 0, 0),
        leading: IconButton(
          icon: const Icon(Icons.download_rounded),
          onPressed: () async {
            await MangaStorageManager()
                .saveManga(context, mangaDescription!.title, {
              'title': mangaDescription!.title,
              'imageLink': mangaDescription!.imageLink,
              'mangaList': mangaDescription!.mangaList
            });
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Center(
            child: _isLoading
                ? const CircularProgressIndicator()
                : mangaDescription != null
                    ? Column(
                        children: [
                          Stack(
                            children: [
                              FadeInImage.assetNetwork(
                                placeholder: 'assets/OfflineAsset.jpg',
                                image: mangaDescription!.imageLink,
                                fit: BoxFit.cover,
                                height: 600,
                                width: MediaQuery.of(context).size.width,
                              ),
                              Container(
                                height: 600,
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                                    fadingEdgeStartFraction:
                                                        0.1,
                                                    text:
                                                        mangaDescription!.title,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    blankSpace:
                                                        MediaQuery.of(context)
                                                                    .size
                                                                    .width *
                                                                0.66 -
                                                            40,
                                                    scrollAxis: Axis.horizontal,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    velocity: 50.0,
                                                    startPadding: 10.0,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons
                                                    .bookmark_outline_rounded),
                                                color: isFavourite
                                                    ? Colors.red
                                                    : Colors.white,
                                                style: ButtonStyle(
                                                    iconSize:
                                                        WidgetStateProperty.all(
                                                            30)),
                                                onPressed: () async {
                                                  if (isFavourite) {
                                                    await ref
                                                        .read(
                                                            mangaServiceProvider)
                                                        .removeFromFavManga(
                                                            context,
                                                            mangaDescription!
                                                                .title);
                                                    setState(() {
                                                      isFavourite =
                                                          !isFavourite;
                                                    });
                                                  } else {
                                                    await ref
                                                        .read(
                                                            mangaServiceProvider)
                                                        .addMangaToFav(
                                                          context,
                                                          mangaDescription!
                                                              .title,
                                                          widget.accessLink,
                                                          mangaDescription!
                                                              .imageLink,
                                                        );
                                                    setState(() {
                                                      isFavourite =
                                                          !isFavourite;
                                                    });
                                                  }
                                                },
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
                                                    Icons
                                                        .remove_red_eye_rounded,
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
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 10,
                                                      vertical: 5),
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[800],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
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
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                TextButton(
                                                  style: ButtonStyle(
                                                    padding: WidgetStateProperty
                                                        .all<EdgeInsetsGeometry>(
                                                            EdgeInsets.zero),
                                                  ),
                                                  onPressed: () {
                                                    showModalBottomSheet(
                                                      clipBehavior: Clip
                                                          .antiAliasWithSaveLayer,
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(20),
                                                          color: const Color
                                                              .fromARGB(
                                                              255, 25, 26, 31),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                mangaDescription!
                                                                    .description
                                                                    .substring(
                                                                        0,
                                                                        min(600,
                                                                            mangaDescription!.description.length)),
                                                                style:
                                                                    const TextStyle(
                                                                  color: Colors
                                                                      .white,
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
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                AllChaptersSection(
                                    filterMangaChapters: filterMangaChapters),
                              ],
                            ),
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: filteredMangaList
                                  .asMap()
                                  .entries
                                  .map((entry) {
                                final int index = entry.key;
                                final mangaChapter = entry.value;
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ReadChapter(
                                          mangaDescription: mangaDescription!,
                                          chapterName: mangaChapter.mangaText,
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
                                                'assets/OfflineAsset.jpg',
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
      ),
    );
  }
}
