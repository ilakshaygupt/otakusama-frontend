import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otakusama/feature/MyList/service/MyListService.dart';

class MyListScreen extends ConsumerStatefulWidget {
  const MyListScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MyListScreen> createState() => _MyListScreenState();
}

class _MyListScreenState extends ConsumerState<MyListScreen> {
  @override
  Widget build(BuildContext context) {
    final favManga  = ref.watch(FavMangaProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('My List'),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text('Favourite Manga: ${favManga!.length}'),
            const SizedBox(height: 20),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
