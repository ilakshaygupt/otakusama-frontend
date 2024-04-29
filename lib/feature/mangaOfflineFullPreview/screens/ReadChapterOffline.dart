// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:otakusama/feature/downloadManager/downloadManager.dart';
import 'package:otakusama/models/manga_chapter_model.dart';
import 'package:otakusama/models/manga_description_model.dart';
import 'package:otakusama/models/manga_offline_model.dart';
import 'dart:convert';

import 'package:photo_view/photo_view.dart';

class ReadChapterOffline extends StatefulWidget {
  final String chapterPath;
  const ReadChapterOffline({super.key, required this.chapterPath});

  @override
  State<ReadChapterOffline> createState() => _ReadChapterOfflineState();
}

class _ReadChapterOfflineState extends State<ReadChapterOffline> {
  List<String> imagePaths = [];

  void initState() {
    super.initState();
    getChapterImages();
  }

  void getChapterImages() async {
    File baseImagePath = File('${widget.chapterPath}/image_0.jpg');

    for (int i = 0; baseImagePath.existsSync(); i++) {
      imagePaths.add('${widget.chapterPath}/image_$i.jpg');
      baseImagePath = File('${widget.chapterPath}/image_$i.jpg');
    }
    print(imagePaths);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: imagePaths.isNotEmpty
          ? Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: imagePaths.length,
                    itemBuilder: (context, index) {
                      return Container(
                        height: 300,
                        width: 300,
                        child: PhotoView(
                          imageProvider: FileImage(File(imagePaths[index])),
                        ),
                      );
                    },
                  ),
                ),
              ],
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
