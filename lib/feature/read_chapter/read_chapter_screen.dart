// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:otakusama/commons/contants.dart';
import 'package:otakusama/feature/downloadManager/downloadManager.dart';
import 'package:otakusama/models/manga_chapter_model.dart';
import 'package:otakusama/models/manga_description_model.dart';
import 'package:photo_view/photo_view.dart';

// ignore: must_be_immutable
class ReadChapter extends StatefulWidget {
  final MangaDescription mangaDescription;
  final String chapterName;
  final String accessLink;
  final int chapterId;
  List<MangaChapter> mangaChapterList = [];

  ReadChapter({
    Key? key,
    required this.mangaDescription,
    required this.chapterName,
    required this.accessLink,
    required this.chapterId,
    required this.mangaChapterList,
  }) : super(key: key);

  @override
  _ReadChapterState createState() => _ReadChapterState();
}

class _ReadChapterState extends State<ReadChapter> {
  List<String> mangaImages = [];
  bool isCarouselView = false;

  @override
  void initState() {
    super.initState();
    fetchData();
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
        title: Text(widget.mangaDescription.title),
        actions: [
          GestureDetector(
            onTap: () {
              setState(() {
                isCarouselView = !isCarouselView;
              });
            },
            child: const Icon(Icons.view_carousel),
          ),
          GestureDetector(
              onTap: () {
                // Download dialog
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
                                'Chapter already downloaded')) {
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
              child: const Icon(Icons.download_rounded)),
          const SizedBox(width: 10),
        ],
      ),
      body: mangaImages.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : isCarouselView
              ? InteractiveViewer(
                  panEnabled: true,
                  panAxis: PanAxis.free,
                  child: PageView.builder(
                    itemCount: mangaImages.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onLongPress: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return PhotoView(
                                imageProvider: NetworkImage(
                                  mangaImages[index],
                                  headers: const {
                                    'User-Agent':
                                        'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:123.0) Gecko/20100101 Firefox/123.0',
                                    'Accept': 'image/avif,image/webp,*/*',
                                    'Accept-Language': 'en-US,en;q=0.5',
                                    'Accept-Encoding': 'gzip, deflate, br',
                                    'Referer': 'https://chapmanganato.to/',
                                  },
                                ),
                              );
                            },
                          );
                        },
                        child: Center(
                          child: CachedNetworkImage(
                            imageUrl: mangaImages[index],
                            fit: BoxFit.contain,
                            httpHeaders: const {
                              'User-Agent':
                                  'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:123.0) Gecko/20100101 Firefox/123.0',
                              'Accept': 'image/avif,image/webp,*/*',
                              'Accept-Language': 'en-US,en;q=0.5',
                              'Accept-Encoding': 'gzip, deflate, br',
                              'Referer': 'https://chapmanganato.to/',
                            },
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) =>
                                    CircularProgressIndicator(
                                        value: downloadProgress.progress),
                          ),
                        ),
                      );
                    },
                  ),
                )
              : SingleChildScrollView(
                  child: InteractiveViewer(
                    panEnabled: true,
                    panAxis: PanAxis.free,
                    child: Column(
                      children: <Widget>[
                        ListView.builder(
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
                                  onLongPress: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return PhotoView(
                                          imageProvider: NetworkImage(
                                            imageUrl,
                                            headers: const {
                                              'User-Agent':
                                                  'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:123.0) Gecko/20100101 Firefox/123.0',
                                              'Accept':
                                                  'image/avif,image/webp,*/*',
                                              'Accept-Language':
                                                  'en-US,en;q=0.5',
                                              'Accept-Encoding':
                                                  'gzip, deflate, br',
                                              'Referer':
                                                  'https://chapmanganato.to/',
                                            },
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CachedNetworkImage(
                                      imageUrl: imageUrl,
                                      fit: BoxFit.contain,
                                      httpHeaders: const {
                                        'User-Agent':
                                            'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:123.0) Gecko/20100101 Firefox/123.0',
                                        'Accept': 'image/avif,image/webp,*/*',
                                        'Accept-Language': 'en-US,en;q=0.5',
                                        'Accept-Encoding': 'gzip, deflate, br',
                                        'Referer': 'https://chapmanganato.to/',
                                      },
                                      progressIndicatorBuilder: (context, url,
                                              downloadProgress) =>
                                          CircularProgressIndicator(
                                              value: downloadProgress.progress),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (widget.chapterId > 0)
            FloatingActionButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReadChapter(
                      mangaDescription: widget.mangaDescription,
                      chapterName: widget.chapterName,
                      accessLink: widget
                          .mangaChapterList[widget.chapterId - 1].mangaLink,
                      chapterId: widget.chapterId - 1,
                      mangaChapterList: widget.mangaChapterList,
                    ),
                  ),
                );
              },
              child: const Icon(Icons.arrow_back),
            ),
          const SizedBox(width: 10),
          if (widget.chapterId < widget.mangaChapterList.length - 1)
            FloatingActionButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReadChapter(
                      mangaDescription: widget.mangaDescription,
                      chapterName: widget.chapterName,
                      accessLink: widget
                          .mangaChapterList[widget.chapterId + 1].mangaLink,
                      chapterId: widget.chapterId + 1,
                      mangaChapterList: widget.mangaChapterList,
                    ),
                  ),
                );
              },
              child: const Icon(Icons.arrow_forward),
            ),
        ],
      ),
    );
  }
}
