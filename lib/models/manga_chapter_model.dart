// Model class for manga chapters
import 'dart:convert';

class MangaChapter {
  final String mangaLink;
  final String mangaText;
  MangaChapter({
    required this.mangaLink,
    required this.mangaText,
  });

  MangaChapter copyWith({
    String? mangaLink,
    String? mangaText,
  }) {
    return MangaChapter(
      mangaLink: mangaLink ?? this.mangaLink,
      mangaText: mangaText ?? this.mangaText,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'mangaLink': mangaLink,
      'mangaText': mangaText,
    };
  }

  factory MangaChapter.fromMap(Map<String, dynamic> map) {
    return MangaChapter(
      mangaLink: map['mangaLink'] as String,
      mangaText: map['mangaText'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory MangaChapter.fromJson(String source) =>
      MangaChapter.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'MangaChapter(mangaLink: $mangaLink, mangaText: $mangaText)';

  @override
  bool operator ==(covariant MangaChapter other) {
    if (identical(this, other)) return true;

    return other.mangaLink == mangaLink && other.mangaText == mangaText;
  }

  @override
  int get hashCode => mangaLink.hashCode ^ mangaText.hashCode;
}
