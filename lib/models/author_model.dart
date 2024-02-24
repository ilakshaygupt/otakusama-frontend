
import 'dart:convert';

class Author {
  final String name;
  final String link;

  Author({
    required this.name,
    required this.link,
  });

  Author copyWith({
    String? name,
    String? link,
  }) {
    return Author(
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

  factory Author.fromMap(Map<String, dynamic> map) {
    return Author(
      name: map['name'] as String,
      link: map['link'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Author.fromJson(String source) =>
      Author.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Author(name: $name, link: $link)';

  @override
  bool operator ==(covariant Author other) {
    if (identical(this, other)) return true;

    return other.name == name && other.link == link;
  }

  @override
  int get hashCode => name.hashCode ^ link.hashCode;
}
