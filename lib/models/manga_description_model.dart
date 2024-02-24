// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:otakusama/models/author_model.dart';
import 'package:otakusama/models/genre_model.dart';
import 'package:otakusama/models/manga_chapter_model.dart';


class MangaDescription {
  final String title;
  final dynamic alternative;
  final List<Author> authors;
  final String status;
  final List<Genre> genres;
  final String updatedTime;
  final String viewCount;
  final String rating;
  final String description;
  final String imageLink;
  final List<MangaChapter> mangaList;
  MangaDescription({
    required this.title,
    required this.alternative,
    required this.authors,
    required this.status,
    required this.genres,
    required this.updatedTime,
    required this.viewCount,
    required this.rating,
    required this.description,
    required this.imageLink,
    required this.mangaList,
  });

  MangaDescription copyWith({
    String? title,
    String? alternative,
    List<Author>? authors,
    String? status,
    List<Genre>? genres,
    String? updatedTime,
    String? viewCount,
    String? rating,
    String? description,
    String? imageLink,
    List<MangaChapter>? mangaList,
  }) {
    return MangaDescription(
      title: title ?? this.title,
      alternative: alternative ?? this.alternative,
      authors: authors ?? this.authors,
      status: status ?? this.status,
      genres: genres ?? this.genres,
      updatedTime: updatedTime ?? this.updatedTime,
      viewCount: viewCount ?? this.viewCount,
      rating: rating ?? this.rating,
      description: description ?? this.description,
      imageLink: imageLink ?? this.imageLink,
      mangaList: mangaList ?? this.mangaList,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'alternative': alternative,
      'authors': authors.map((x) => x.toMap()).toList(),
      'status': status,
      'genres': genres.map((x) => x.toMap()).toList(),
      'updatedTime': updatedTime,
      'viewCount': viewCount,
      'rating': rating,
      'description': description,
      'imageLink': imageLink,
      'mangaList': mangaList.map((x) => x.toMap()).toList(),
    };
  }

  factory MangaDescription.fromMap(Map<String, dynamic> map) {
  return MangaDescription(
    title: map['title'] as String,
    alternative: map['alternative'],
    authors: (map['authors'] as List<dynamic>).map((author) => Author.fromMap(author)).toList(),
    status: map['status'] as String,
    genres: (map['genres'] as List<dynamic>).map((genre) => Genre.fromMap(genre)).toList(),
    updatedTime: map['updatedTime'] as String,
    viewCount: map['viewCount'] as String,
    rating: map['rating'] as String,
    description: map['description'] as String,
    imageLink: map['imageLink'] as String,
    mangaList: (map['mangaList'] as List<dynamic>).map((chapter) => MangaChapter.fromMap(chapter)).toList(),
  );
}


  String toJson() => json.encode(toMap());

  factory MangaDescription.fromJson(String source) =>
      MangaDescription.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MangaDescription(title: $title, alternative: $alternative, authors: $authors, status: $status, genres: $genres, updatedTime: $updatedTime, viewCount: $viewCount, rating: $rating, description: $description, imageLink: $imageLink, mangaList: $mangaList)';
  }

  @override
  int get hashCode {
    return title.hashCode ^
        alternative.hashCode ^
        authors.hashCode ^
        status.hashCode ^
        genres.hashCode ^
        updatedTime.hashCode ^
        viewCount.hashCode ^
        rating.hashCode ^
        description.hashCode ^
        imageLink.hashCode ^
        mangaList.hashCode;
  }

  @override
  bool operator ==(covariant MangaDescription other) {
    if (identical(this, other)) return true;
  
    return 
      other.title == title &&
      other.alternative == alternative &&
      listEquals(other.authors, authors) &&
      other.status == status &&
      listEquals(other.genres, genres) &&
      other.updatedTime == updatedTime &&
      other.viewCount == viewCount &&
      other.rating == rating &&
      other.description == description &&
      other.imageLink == imageLink &&
      listEquals(other.mangaList, mangaList);
  }
}
