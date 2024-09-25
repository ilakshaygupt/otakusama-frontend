import 'package:flutter/material.dart';

class AllChaptersSection extends StatelessWidget {
  Function filterMangaChapters;
  AllChaptersSection({super.key, required this.filterMangaChapters});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Chapters',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color.fromARGB(255, 96, 97, 98),
            ),
          ),
          child: Row(
            children: [
              IconButton(icon: const Icon(Icons.search), onPressed: () {}),
              Container(
                width: MediaQuery.of(context).size.width * 0.3,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.zero,
                ),
                child: TextField(
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Search...',
                    hintStyle: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onChanged: (value) {
                    filterMangaChapters(value);
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
