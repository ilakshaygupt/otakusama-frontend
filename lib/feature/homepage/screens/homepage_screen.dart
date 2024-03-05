// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:otakusama/feature/manga_full_preview/manga_full_preview.dart';
import 'package:otakusama/models/manga_model.dart';
import 'package:otakusama/feature/search/screens/search_screen.dart';
import 'package:otakusama/feature/viewallmanga/screens/viewallscreens.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  List<Manga> mangaList = [];
  TextEditingController searchController = TextEditingController();
  late PageController _pageController;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    fetchData();
    _pageController = PageController();
    _startAutoPageChange();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  void _startAutoPageChange() {
    const Duration duration = Duration(seconds: 4);
    _timer = Timer.periodic(duration, (Timer timer) {
      if (_pageController.page == mangaList.length - 1) {
        _pageController.animateToPage(0,
            duration: const Duration(milliseconds: 700), curve: Curves.ease);
      } else {
        _pageController.nextPage(
            duration: const Duration(milliseconds: 700), curve: Curves.ease);
      }
    });
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(0, 0, 0, 0),
        title: const Text(
          'OTAKUSAMA',
          style: TextStyle(fontFamily: 'Outfit'),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchScreen(),
                ),
              );
            },
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color(0xFFc2313c),
        backgroundColor: const Color(0x0ff191a1),
        unselectedItemColor: const Color(0xFF8f9094),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.home, color: Color(0xFFc2313c)),
            icon: Icon(
              Icons.home,
              color: Color(0xFF8f9094),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.list, color: Color(0xFFc2313c)),
            icon: Icon(Icons.list, color: Color(0xFF8f9094)),
            label: 'My List',
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.person, color: Color(0xFFc2313c)),
            icon: Icon(Icons.person, color: Color(0xFF8f9094)),
            label: 'Profile',
          ),
        ],
      ),
      body: _getBodyWidget(_selectedIndex),
    );
  }

  Widget _getBodyWidget(int index) {
    switch (index) {
      case 0:
        return _buildHomeScreen();
      default:
        return Container();
    }
  }

  Widget _buildHomeScreen() {
    return mangaList.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              SizedBox(
                height: 380,
                child: PageView.builder(
                  scrollDirection: Axis.horizontal,
                  controller: _pageController,
                  itemCount: mangaList.length,
                  itemBuilder: (context, index) {
                    final manga = mangaList[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MangaFullPreview(
                              accessLink: manga.accessLink,
                            ),
                          ),
                        );
                      },
                      child: FadeInImage.assetNetwork(
                        placeholder: 'assets/downloaded_image.jpg',
                        image: manga.image,
                        height: 380,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.fitWidth,
                      ),
                    );
                  },
                ),
              ),
              Row(
                children: [
                  const SizedBox(width: 8),
                  const Text(
                    "TOP AIRING",
                    style: TextStyle(
                        fontSize: 20,
                        color: Color(0xfff6f7f8),
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Core Sans AR'),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateColor.resolveWith(
                          (states) => const Color.fromARGB(0, 240, 0, 0)),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewAllMangaScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'View All',
                      style: TextStyle(color: Color(0xffc6303c), fontSize: 15),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 230,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: mangaList.length,
                  itemBuilder: (context, index) {
                    final manga = mangaList[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MangaFullPreview(
                              accessLink: manga.accessLink,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        height: 230,
                        width: 150,
                        child: FadeInImage.assetNetwork(
                          placeholder: 'assets/downloaded_image.jpg',
                          image: manga.image,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
  }
}
