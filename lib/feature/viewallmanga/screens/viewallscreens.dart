// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:otakusama/feature/manga_short_preview/manga_short_preview_screen.dart';
import 'package:otakusama/feature/viewallmanga/services/viewall_service.dart';
import 'package:otakusama/models/manga_model.dart';

class ViewAllMangaScreen extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _ViewAllMangaScreenState createState() => _ViewAllMangaScreenState();
}

class _ViewAllMangaScreenState extends State<ViewAllMangaScreen> {
  List<Manga> mangaList = [];
  TextEditingController searchController = TextEditingController();
  final ViewAllService _viewAllService = ViewAllService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final results = await _viewAllService.fetchTopManga();
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

  Future<void> searchManga(String searchText) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final results = await _viewAllService.searchManga(searchText);
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        shadowColor: Colors.white,
        backgroundColor: Colors.black,
        title: const Text(
          'View All Manga',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: mangaList.length,
                    itemBuilder: (context, index) {
                      final manga = mangaList[index];
                      return MangaShortPreview(manga: manga);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
