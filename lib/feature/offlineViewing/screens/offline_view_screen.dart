import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:otakusama/feature/mangaOfflineFullPreview/manga_offline_full_preview.dart';
import 'package:otakusama/feature/manga_full_preview/manga_full_preview.dart';

class OfflineViewScreen extends StatefulWidget {
  const OfflineViewScreen({super.key});

  @override
  State<OfflineViewScreen> createState() => _OfflineViewScreenState();
}

class _OfflineViewScreenState extends State<OfflineViewScreen> {
  List<dynamic> mangaData = [];

  void initState() {
    super.initState();
    getMangaData();
  }

  void getMangaData() async {
    final Directory directory =
        Directory('/storage/emulated/0/Download/OtakuSama');
    final List<FileSystemEntity> files = directory.listSync();
    for (final FileSystemEntity file in files) {
      print(file.path);
      final String mangaDataPath = '${file.path}/manga_data.json';
      print(mangaDataPath);
      final File mangaDataFile = File(mangaDataPath);
      if (mangaDataFile.existsSync()) {
        // Check if the file exists
        final String mangaDataJson = await mangaDataFile.readAsString();
        final Map<String, dynamic> mangaDataMap = json.decode(mangaDataJson);
        print(mangaDataJson);

        File coverImage = File('${file.path}/cover.jpg');
        if (coverImage.existsSync()) {
          print('Cover image exists');
        } else {
          print('Cover image does not exist');
        }
        mangaDataMap['coverImage'] = coverImage;
        mangaData.add(mangaDataMap);
      } else {
        print('Manga data file does not exist: $mangaDataPath');
      }
    }
    setState(() {}); // Trigger a rebuild after fetching data
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
                                '/storage/emulated/0/Download/OtakuSama/${manga['title'].toString().replaceAll(' ', '_')}',
                          ),
                        ),
                      ).then((value) => setState(() {}));
                    },
                    child: Container(
                      decoration: BoxDecoration(
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
                            padding: const EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: Text(
                              manga['title'],
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                              style:
                                  TextStyle(fontSize: 20, color: Colors.black),
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
