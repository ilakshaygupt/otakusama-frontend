import 'dart:async';

import 'package:flutter/material.dart';
import 'package:otakusama/feature/MyList/Screens/MyListScreen.dart';
import 'package:otakusama/feature/homepage/services/homepage_service.dart';
import 'package:otakusama/feature/manga_full_preview/manga_full_preview.dart';
import 'package:otakusama/feature/profile/screens/profileScreen.dart';
import 'package:otakusama/feature/search/screens/search_screen.dart';
import 'package:otakusama/feature/viewallmanga/screens/viewallscreens.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late HomeViewModel _viewModel;
  late PageController _pageController;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _viewModel = HomeViewModel();
    _viewModel.addListener(_onViewModelChanged);
    _pageController = PageController();
    _startAutoPageChange();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    super.dispose();
  }

  void _startAutoPageChange() {
    const Duration duration = Duration(seconds: 2);
    _timer = Timer.periodic(duration, (Timer timer) {
      if (_pageController.page == _viewModel.topAiring.length - 1) {
        _pageController.animateToPage(
          0,
          duration: const Duration(milliseconds: 700),
          curve: Curves.ease,
        );
      } else {
        _pageController.nextPage(
            duration: const Duration(milliseconds: 700), curve: Curves.ease);
      }
    });
  }

  void _onViewModelChanged() {
    setState(() {});
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
          style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.white),
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
      case 1:
        return const MyListScreen();
      case 2:
        return const ProfilePage();
      default:
        return Container();
    }
  }

  Widget _buildHomeScreen() {
    return _viewModel.isLoading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 600,
                  child: PageView.builder(
                    scrollDirection: Axis.horizontal,
                    controller: _pageController,
                    itemCount: _viewModel.topAiring.length,
                    itemBuilder: (context, index) {
                      final manga = _viewModel.topAiring[index];
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
                          placeholder: 'assets/OfflineAsset.jpg',
                          image: manga.image,
                          height: 360,
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
                        backgroundColor:
                            WidgetStateProperty.all(Colors.transparent),
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
                        style:
                            TextStyle(color: Color(0xffc6303c), fontSize: 15),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 230,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _viewModel.topAiring.length,
                    itemBuilder: (context, index) {
                      final manga = _viewModel.topAiring[index];
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
                            placeholder: 'assets/OfflineAsset.jpg',
                            image: manga.image,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Row(
                  children: [
                    const SizedBox(width: 8),
                    const Text(
                      "UPDATED RECENTLY",
                      style: TextStyle(
                          fontSize: 20,
                          color: Color(0xfff6f7f8),
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Core Sans AR'),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all(Colors.transparent),
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
                        style:
                            TextStyle(color: Color(0xffc6303c), fontSize: 15),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 230,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _viewModel.topLatest.length,
                    itemBuilder: (context, index) {
                      final manga = _viewModel.topLatest[index];
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
                            placeholder: 'assets/OfflineAsset.jpg',
                            image: manga.image,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
  }
}
