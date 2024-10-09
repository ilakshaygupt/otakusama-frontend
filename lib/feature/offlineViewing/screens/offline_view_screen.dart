// ignore_for_file: unused_import

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:otakusama/feature/mangaOfflineFullPreview/manga_offline_full_preview.dart';
import 'package:otakusama/feature/manga_full_preview/manga_full_preview.dart';
import 'package:path_provider/path_provider.dart';

class OfflineViewScreen extends StatefulWidget {
  const OfflineViewScreen({super.key});

  @override
  State<OfflineViewScreen> createState() => _OfflineViewScreenState();
}

class _OfflineViewScreenState extends State<OfflineViewScreen> {
  List<dynamic> mangaData = [];

  @override
  void initState() {
    super.initState();
    getMangaData();
  }

  void getMangaData() async {
   
    final Directory directory = Directory('/Internal storage/Download/OtakuSama');

    final List<FileSystemEntity> files = directory.listSync();
    for (final FileSystemEntity file in files) {
      final String mangaPhotoPath = '${file.path}/cover.jpg';
      final File mangaPhotoFile = File(mangaPhotoPath);
      final String mangaPhotoBase64 =
          base64Encode(mangaPhotoFile.readAsBytesSync());
      mangaData.add({
        'title': file.path.split('/').last,
        'photo': mangaPhotoBase64,
      });

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: mangaData.isNotEmpty
            ? ListView.builder(
                itemCount: mangaData.length,
                itemBuilder: (context, index) {
                  final manga = mangaData[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MangaOfflineFullPreview(
                            mangaPath:
                                '/storage/emulated/0/Download/OtakuSama/${manga['title'].toString().replaceAll(' ', '_').replaceAll(':', '_')}',
                          ),
                        ),
                      ).then((value) => setState(() {}));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      height: 500,
                      width: 200,
                      decoration: BoxDecoration(
                        image: manga['photo'] != null
                            ? DecorationImage(
                                image: MemoryImage(
                                  base64Decode(manga['photo']),
                                ),
                                fit: BoxFit.fill,
                              )
                            : null,
                        border: Border.all(color: Colors.black),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            height: 230,
                            width: 150,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                            ),
                            padding: const EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: Text(
                              manga['title'].toString().replaceAll('_', ' '),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                              style: const TextStyle(
                                  fontSize: 20, color: Colors.black),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              )
            : const Text('No manga in your list'),
      ),
    );
  }
}
