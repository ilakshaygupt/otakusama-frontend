import 'dart:typed_data';

class Manga {
  final String? author;
  final String? updatedTime;
  final String image;
  final String title;
  final String lastChapter;
  final String accessLink;

  Manga({
    required this.author,
    required this.updatedTime,
    required this.image,
    required this.title,
    required this.lastChapter,
    required this.accessLink,
  });

  factory Manga.fromJson(Map<String, dynamic> json) {
    return Manga(
      title: json['title'] ?? '',
      image: json['image'] ?? '',
      accessLink: json['access_link'] ?? '',
      lastChapter: json['last_chapter'] ?? '',
      author: json['author'] ?? '',
      updatedTime: json['updated_time'] ?? '',
    );
  }
}

class Chapter {
  final String chapter;
  final String chapterLink;
  final Manga manga;
  final List<Uint8List>? images;
  final List<String> imageLinks;

  Chapter({
    required this.chapter,
    required this.chapterLink,
    required this.manga,
    required this.images,
    required this.imageLinks,
  });
}
