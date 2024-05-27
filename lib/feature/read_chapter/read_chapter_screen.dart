// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:otakusama/commons/contants.dart';
import 'package:otakusama/feature/downloadManager/downloadManager.dart';
import 'package:otakusama/models/manga_chapter_model.dart';
import 'package:otakusama/models/manga_description_model.dart';
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:cached_network_image/cached_network_image.dart';

// ignore: must_be_immutable
class ReadChapter extends StatefulWidget {
  final MangaDescription mangaDescription;
  final String chapterName;
  final String accessLink;
  final int chapterId;
  List<MangaChapter> mangaChapterList = [];

  ReadChapter(
      {Key? key,
      required this.mangaDescription,
      required this.chapterName,
      required this.accessLink,
      required this.chapterId,
      required this.mangaChapterList})
      : super(key: key);

  @override
  _ReadChapterState createState() => _ReadChapterState();
}

class _ReadChapterState extends State<ReadChapter> {
  List<String> mangaImages = [];
  bool isCarousalView = false;
  CarouselController buttonCarouselController = CarouselController();

  @override
  void initState() {
    super.initState();

    fetchData();
    // preFetchImages();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.post(
        Uri.parse('$uri/manga/manga_detail/'),
        body: jsonEncode({'url': widget.accessLink}),
        headers: {'Content-Type': 'application/json'},
      );
      if (mounted) {
        if (response.statusCode == 200) {
          final responseData =
              jsonDecode(response.body) as Map<String, dynamic>;
          final data = responseData['data'] as List<dynamic>;

          setState(() {
            mangaImages = data.cast<String>().toList();
          });
        } else {
          throw Exception('Failed to load manga: ${response.statusCode}');
        }
      }
    } catch (error) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Manga Read'),
        actions: [
          GestureDetector(
            onTap: () {
              setState(() {
                isCarousalView = !isCarousalView;
              });
            },
            child: const Icon(Icons.view_carousel),
          ),
          GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Download'),
                      content:
                          const Text('Do you want to download this chapter?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('No'),
                        ),
                        TextButton(
                          onPressed: () async {
                            if (await MangaStorageManager().doesDirectoryExists(
                                context,
                                '/storage/emulated/0/Download/OtakuSama/${widget.mangaDescription.title.replaceAll(' ', '_').replaceAll(':', '_')}/${widget.chapterName.replaceAll(' ', '_').replaceAll(':', '_')}',
                                'Chapter already donwloaded')) {
                              Navigator.of(context).pop();
                              return;
                            }
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return const AlertDialog(
                                  title: Text('Downloading'),
                                  content: LinearProgressIndicator(),
                                );
                              },
                            );
                            await MangaStorageManager().saveChapter(
                                context,
                                widget.mangaDescription,
                                widget.chapterName,
                                mangaImages);
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          },
                          child: const Text('Yes'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Icon(
                Icons.download_rounded,
              )),
          const SizedBox(width: 10),
        ],
      ),
      body: mangaImages.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Text(widget.chapterId.toString()),
                  isCarousalView
                      ? CarouselSlider(
                          disableGesture: false,
                          carouselController: buttonCarouselController,
                          options: CarouselOptions(
                              viewportFraction: 0.9,
                              aspectRatio: 2.0,
                              initialPage: 2,
                              enlargeCenterPage: true,
                              height: 700),
                          items: mangaImages.map((
                            i,
                          ) {
                            return Builder(
                              builder: (BuildContext context) {
                                return GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Dialog(
                                          child: PhotoView(
                                            imageProvider: NetworkImage(i),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Text('Page : ${mangaImages.indexOf(i)}',
                                            style: const TextStyle(
                                                fontSize: 30,
                                                color: Colors.white)),
                                        CachedNetworkImage(
                                          imageUrl: i,
                                          fit: BoxFit.contain,
                                          httpHeaders: const {
                                            'User-Agent':
                                                'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:123.0) Gecko/20100101 Firefox/123.0',
                                            'Accept':
                                                'image/avif,image/webp,*/*',
                                            'Accept-Language': 'en-US,en;q=0.5',
                                            'Accept-Encoding':
                                                'gzip, deflate, br',
                                            'Referer':
                                                'https://chapmanganato.to/',
                                          },
                                          progressIndicatorBuilder: (context,
                                                  url, downloadProgress) =>
                                              CircularProgressIndicator(
                                                  value: downloadProgress
                                                      .progress),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        )
                      : ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: mangaImages.length,
                          itemBuilder: (context, index) {
                            final imageUrl = mangaImages[index];
                            return Column(
                              children: [
                                Text(
                                  'Page : $index',
                                  style: const TextStyle(
                                      fontSize: 30, color: Colors.white),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Dialog(
                                          child: PhotoView(
                                            imageProvider:
                                                NetworkImage(imageUrl),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        CachedNetworkImage(
                                          imageUrl: imageUrl,
                                          fit: BoxFit.contain,
                                          httpHeaders: const {
                                            'User-Agent':
                                                'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:123.0) Gecko/20100101 Firefox/123.0',
                                            'Accept':
                                                'image/avif,image/webp,*/*',
                                            'Accept-Language': 'en-US,en;q=0.5',
                                            'Accept-Encoding':
                                                'gzip, deflate, br',
                                            'Referer':
                                                'https://chapmanganato.to/',
                                          },
                                          progressIndicatorBuilder: (context,
                                                  url, downloadProgress) =>
                                              CircularProgressIndicator(
                                                  value: downloadProgress
                                                      .progress),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: widget.chapterId == 0
                        ? GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ReadChapter(
                                    mangaDescription: widget.mangaDescription,
                                    chapterName: widget.chapterName,
                                    accessLink: widget
                                        .mangaChapterList[widget.chapterId + 1]
                                        .mangaLink,
                                    chapterId: widget.chapterId + 1,
                                    mangaChapterList: widget.mangaChapterList,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              height: 40,
                              width: MediaQuery.of(context).size.width * 0.35,
                              decoration: const BoxDecoration(
                                  color: Color(0xFF27ae60),
                                  borderRadius: BorderRadius.all(
                                      Radius.elliptical(10, 10))),
                              child: const Center(
                                child: Text(
                                  'Previous Chapter',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          )
                        : widget.chapterId == widget.mangaChapterList.length - 1
                            ? GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ReadChapter(
                                        mangaDescription:
                                            widget.mangaDescription,
                                        chapterName: widget.chapterName,
                                        accessLink: widget
                                            .mangaChapterList[
                                                widget.chapterId - 1]
                                            .mangaLink,
                                        chapterId: widget.chapterId - 1,
                                        mangaChapterList:
                                            widget.mangaChapterList,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  height: 40,
                                  width:
                                      MediaQuery.of(context).size.width * 0.35,
                                  decoration: const BoxDecoration(
                                      color: Color(0xFF27ae60),
                                      borderRadius: BorderRadius.all(
                                          Radius.elliptical(10, 10))),
                                  child: const Center(
                                    child: Text(
                                      'Next Chapter',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ReadChapter(
                                            mangaDescription:
                                                widget.mangaDescription,
                                            chapterName: widget.chapterName,
                                            accessLink: widget
                                                .mangaChapterList[
                                                    widget.chapterId - 1]
                                                .mangaLink,
                                            chapterId: widget.chapterId - 1,
                                            mangaChapterList:
                                                widget.mangaChapterList,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      height: 40,
                                      width: MediaQuery.of(context).size.width *
                                          0.35,
                                      decoration: const BoxDecoration(
                                          color: Color(0xFF27ae60),
                                          borderRadius: BorderRadius.all(
                                              Radius.elliptical(10, 10))),
                                      child: const Center(
                                        child: Text(
                                          'Next Chapter',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ReadChapter(
                                            mangaDescription:
                                                widget.mangaDescription,
                                            chapterName: widget.chapterName,
                                            accessLink: widget
                                                .mangaChapterList[
                                                    widget.chapterId + 1]
                                                .mangaLink,
                                            chapterId: widget.chapterId + 1,
                                            mangaChapterList:
                                                widget.mangaChapterList,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      height: 40,
                                      width: MediaQuery.of(context).size.width *
                                          0.35,
                                      decoration: const BoxDecoration(
                                          color: Color(0xFF27ae60),
                                          borderRadius: BorderRadius.all(
                                              Radius.elliptical(10, 10))),
                                      child: const Center(
                                        child: Text(
                                          'Previous Chapter',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                  ),
                ],
              ),
            ),
    );
  }
}
