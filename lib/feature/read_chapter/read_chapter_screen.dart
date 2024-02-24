// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:photo_view/photo_view.dart';

class ReadChapter extends StatefulWidget {
  final String accessLink;

  const ReadChapter({Key? key, required this.accessLink}) : super(key: key);

  @override
  _ReadChapterState createState() => _ReadChapterState();
}

class _ReadChapterState extends State<ReadChapter> {
  List<String> mangaImages = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.post(
        Uri.parse('https://mangaka.onrender.com/manga/manga_detail/'),
        body: jsonEncode({'url': widget.accessLink}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;
        final data = responseData['data'] as List<dynamic>;
        setState(() {
          mangaImages = data.cast<String>().toList();
        });
      } else {
        throw Exception('Failed to load manga: ${response.statusCode}');
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
      ),
      body: ListView.builder(
        itemCount: mangaImages.length,
        itemBuilder: (context, index) {
          final imageUrl = mangaImages[index];
          return Column(
            children: [
              Text(
                'Page : $index',
                style: const TextStyle(fontSize: 30, color: Colors.white),
              ),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        child: PhotoView(
                          imageProvider: NetworkImage(imageUrl),
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
                      Image.network(
                        imageUrl,
                        fit: BoxFit.contain,
                        headers: const {
                          'User-Agent':
                              'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:123.0) Gecko/20100101 Firefox/123.0',
                          'Accept': 'image/avif,image/webp,*/*',
                          'Accept-Language': 'en-US,en;q=0.5',
                          'Accept-Encoding': 'gzip, deflate, br',
                          'Referer': 'https://chapmanganato.to/',
                        },
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }
                          return CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
