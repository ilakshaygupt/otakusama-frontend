// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class MangaApiModel {
  final String title;
  final String imageLink;
  final String accessLink;
  MangaApiModel({
    required this.title,
    required this.imageLink,
    required this.accessLink,
  });

  MangaApiModel copyWith({
    String? title,
    String? imageLink,
    String? accessLink,
  }) {
    return MangaApiModel(
      title: title ?? this.title,
      imageLink: imageLink ?? this.imageLink,
      accessLink: accessLink ?? this.accessLink,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'imageLink': imageLink,
      'accessLink': accessLink,
    };
  }

  factory MangaApiModel.fromMap(Map<String, dynamic> map) {
    return MangaApiModel(
      title: map['title'] as String,
      imageLink: map['imageLink'] as String,
      accessLink: map['accessLink'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory MangaApiModel.fromJson(String source) => MangaApiModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'MangaApiModel(title: $title, imageLink: $imageLink, accessLink: $accessLink)';

  @override
  bool operator ==(covariant MangaApiModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.title == title &&
      other.imageLink == imageLink &&
      other.accessLink == accessLink;
  }

  @override
  int get hashCode => title.hashCode ^ imageLink.hashCode ^ accessLink.hashCode;
}
