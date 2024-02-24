
// Model class for manga genres
import 'dart:convert';

class Genre {
  final String name;
  final String link;

  Genre({
    required this.name,
    required this.link,
  });

  Genre copyWith({
    String? name,
    String? link,
  }) {
    return Genre(
      name: name ?? this.name,
      link: link ?? this.link,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'link': link,
    };
  }

  factory Genre.fromMap(Map<String, dynamic> map) {
    return Genre(
      name: map['name'] as String,
      link: map['link'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Genre.fromJson(String source) =>
      Genre.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Genre(name: $name, link: $link)';

  @override
  bool operator ==(covariant Genre other) {
    if (identical(this, other)) return true;

    return other.name == name && other.link == link;
  }

  @override
  int get hashCode => name.hashCode ^ link.hashCode;
}
