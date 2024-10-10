import 'package:flutter/material.dart';
import 'package:otakusama/feature/manga_full_preview/manga_full_preview.dart';
import 'package:otakusama/feature/search/services/search_service.dart';
import 'package:otakusama/models/manga_model.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Manga> mangaList = [];
  final SearchService _searchService = SearchService();
  bool _isLoading = false;

  Future<void> fetchData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final results = await _searchService.fetchTopManga();
      setState(() {
        mangaList = results;
      });
    } catch (e) {
      // Handle error - could show a snackbar
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> searchManga(String searchText) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final results = await _searchService.searchManga(searchText);
      setState(() {
        mangaList = results;
      });
    } catch (e) {
      // Handle error
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0x0ff91a1f),
      appBar: AppBar(
        title: TextField(
          decoration: const InputDecoration(
            hintText: 'Search Manga',
          ),
          onChanged: (value) {
            searchManga(value);
          },
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.7,
              ),
              itemCount: mangaList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MangaFullPreview(
                            accessLink: mangaList[index].accessLink,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                              image: NetworkImage(mangaList[index].image),
                              fit: BoxFit.cover)),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
