class Manga {
  final String author;
  final String updatedTime;
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
      author: json['author'],
      updatedTime: json['updated_time'],
      image: json['image'],
      title: json['title'],
      lastChapter: json['last_chapter'],
      accessLink: json['access_link'],
    );
  }
}
