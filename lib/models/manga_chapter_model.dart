
class MangaChapter {
  final String chapter;
  final String chapterLink;

  MangaChapter({
    required this.chapter,
    required this.chapterLink,
  });

  factory MangaChapter.fromJson(Map<String, dynamic> json) {
    return MangaChapter(
      chapter: json['manga_text'],
      chapterLink: json['manga_link'],
    );
  }
}
