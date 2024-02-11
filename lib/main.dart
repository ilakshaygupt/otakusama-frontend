import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Manga Viewer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MangaGridPage(),
    );
  }
}

class MangaGridPage extends StatefulWidget {
  @override
  _MangaGridPageState createState() => _MangaGridPageState();
}

class _MangaGridPageState extends State<MangaGridPage> {
  List<Manga> mangaList = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http
        .get(Uri.parse('https://mangaka.onrender.com/manga/top_manga/'));

    if (response.statusCode == 200) {
      setState(() {
        mangaList = (jsonDecode(response.body) as List)
            .map((item) => Manga.fromJson(item))
            .toList();
      });
    } else {
      throw Exception('Failed to load manga');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Manga List'),
      ),
      body: ListView(
        children: List.generate(mangaList.length, (index) {
          final manga = mangaList[index];
          return AnimeContainer(manga: manga);
        }),
      ),
    );
  }
}

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

class AnimeContainer extends StatelessWidget {
  final Manga manga;

  const AnimeContainer({Key? key, required this.manga}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MangaListPage(accessLink: manga.accessLink),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 86, 21, 17),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              child: Column(
                children: [
                  Image.network(
                    manga.image,
                    height: 180,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),
            Flexible(
              child: Container(
                child: Column(children: [
                  Container(
                    padding: EdgeInsets.all(10),
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
                                style: TextStyle(color: Colors.white),
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
                                style: TextStyle(color: Colors.white),
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
                                style: TextStyle(color: Colors.white),
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
                                style: TextStyle(color: Colors.white),
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

class MangaListPage extends StatefulWidget {
  final String accessLink;

  const MangaListPage({Key? key, required this.accessLink}) : super(key: key);

  @override
  _MangaListPageState createState() => _MangaListPageState();
}

class _MangaListPageState extends State<MangaListPage> {
  List<MangaChapter> mangaList = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.post(
        Uri.parse('https://mangaka.onrender.com/manga/manga_list/'),
        body: jsonEncode({'url': widget.accessLink}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print(response.body);
        setState(() {
          mangaList = (jsonDecode(response.body) as List)
              .map((item) => MangaChapter.fromJson(item))
              .toList();
        });
      } else {
        print(response.body);
        throw Exception('Failed to load manga: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching manga: $error');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to load manga. Please try again later.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Manga List'),
      ),
      body: ListView(
        children: List.generate(mangaList.length, (index) {
          final manga = mangaList[index];
          return Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 86, 21, 17),
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListTile(
                title: Text(
                  manga.chapter,
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          MangaReadPage(accessLink: manga.chapterLink),
                    ),
                  );
                },
              ));
        }),
      ),
    );
  }
}

class MangaReadPage extends StatefulWidget {
  final String accessLink;

  const MangaReadPage({Key? key, required this.accessLink}) : super(key: key);

  @override
  _MangaReadPageState createState() => _MangaReadPageState();
}

class _MangaReadPageState extends State<MangaReadPage> {
  List<String> mangaImages = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.post(
        Uri.parse('https://mangaka.onrender.com/manga/manga_detail/'),
        body: jsonEncode({'url': widget.accessLink}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print(response.body);
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;
        final data = responseData['data'] as List<dynamic>;
        setState(() {
          mangaImages = data.cast<String>().toList();
        });
      } else {
        print(widget.accessLink);
        throw Exception('Failed to load manga: ${response.statusCode}');
      }
    } catch (error) {
      print(widget.accessLink);
      print('Error fetching manga: $error');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to load manga. Please try again later.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Manga Read'),
      ),
      body: ListView.builder(
        itemCount: mangaImages.length,
        itemBuilder: (context, index) {
          final imageUrl = mangaImages[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.network(
              headers: {
                'User-Agent':
                    'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:123.0) Gecko/20100101 Firefox/123.0',
                'Accept': 'image/avif,image/webp,*/*',
                'Accept-Language': 'en-US,en;q=0.5',
                'Accept-Encoding': 'gzip, deflate, br',
                'Referer': 'https://chapmanganato.to/',
              },
              imageUrl,
              fit: BoxFit.contain,
            ),
          );
        },
      ),
    );
  }
}

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
