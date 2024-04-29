// ignore: file_names
// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';

import 'package:photo_view/photo_view.dart';

class ReadChapterOffline extends StatefulWidget {
  final String chapterPath;
  final String chapterName;
  const ReadChapterOffline({super.key, required this.chapterPath,required this.chapterName});

  @override
  State<ReadChapterOffline> createState() => _ReadChapterOfflineState();
}

class _ReadChapterOfflineState extends State<ReadChapterOffline> {
  List<String> imagePaths = [];

  @override
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
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chapterName),
      ),
      body: imagePaths.isNotEmpty
          ? Column(
              children: [

                Expanded(
                  child: ListView.builder(
                    itemCount: imagePaths.length,
                    itemBuilder: (context, index) {
                      return SizedBox(
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
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
