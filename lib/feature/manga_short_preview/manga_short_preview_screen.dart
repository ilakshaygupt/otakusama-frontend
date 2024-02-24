// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:otakusama/feature/manga_full_preview/manga_full_preview.dart';
import 'package:otakusama/models/manga_model.dart';

class MangaShortPreview extends StatelessWidget {
  final Manga manga;

  const MangaShortPreview({Key? key, required this.manga}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                MangaFullPreview(accessLink: manga.accessLink),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 86, 21, 17),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              child: Column(
                children: [
                  Stack(
                    children: [
                      FadeInImage.assetNetwork(
                        placeholder: "assets/downloaded_image.jpg",
                        image: manga.image,
                        fit: BoxFit.cover,
                        height: 180,
                        width: 140,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Flexible(
              child: Container(
                child: Column(children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(
                                text: 'Title : ',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: manga.title,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                          overflow: TextOverflow.visible,
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(
                                text: 'Author : ',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: manga.author,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                          overflow: TextOverflow.visible,
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(
                                text: 'Last Chapter : ',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: manga.lastChapter,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                          overflow: TextOverflow.visible,
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(
                                text: 'Updated Time : ',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: manga.updatedTime,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                          overflow: TextOverflow.visible,
                        ),
                      ],
                    ),
                  )
                ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}
