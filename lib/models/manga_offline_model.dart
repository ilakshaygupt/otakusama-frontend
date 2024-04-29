// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:otakusama/models/manga_model.dart';

class MangaOfflineModel {
  String title;
  String author;
  String views;
  String rating;
  List<String> genres;
  String description;
  MangaOfflineModel({
    required this.title,
    required this.author,
    required this.views,
    required this.rating,
    required this.genres,
    required this.description,
  });

  MangaOfflineModel copyWith({
    String? title,
    String? author,
    String? views,
    String? rating,
    List<String>? genres,
    String? description,
  }) {
    return MangaOfflineModel(
      title: title ?? this.title,
      author: author ?? this.author,
      views: views ?? this.views,
      rating: rating ?? this.rating,
      genres: genres ?? this.genres,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'author': author,
      'views': views,
      'rating': rating,
      'genres': genres,
      'description': description,
    };
  }

  factory MangaOfflineModel.fromMap(Map<String, dynamic> map) {
    return MangaOfflineModel(
      title: map['title'] as String,
      author: map['author'] as String,
      views: map['views'] as String,
      rating: map['rating'] as String,
      genres: List<String>.from(map['genres'] as List<dynamic>),
      description: map['description'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory MangaOfflineModel.fromJson(String source) =>
      MangaOfflineModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MangaOfflineModel(title: $title, author: $author, views: $views, rating: $rating, genres: $genres, description: $description)';
  }

  @override
  bool operator ==(covariant MangaOfflineModel other) {
    if (identical(this, other)) return true;

    return other.title == title &&
        other.author == author &&
        other.views == views &&
        other.rating == rating &&
        listEquals(other.genres, genres) &&
        other.description == description;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        author.hashCode ^
        views.hashCode ^
        rating.hashCode ^
        genres.hashCode ^
        description.hashCode;
  }
}
