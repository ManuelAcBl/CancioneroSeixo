import 'package:flutter/material.dart';

class SearchSongTileVerse extends StatelessWidget {
  final String name;
  final TextSpan text;

  const SearchSongTileVerse({super.key, required this.name, required this.text});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 5),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          constraints: const BoxConstraints(minWidth: 50),
          margin: const EdgeInsets.only(right: 5),
          child: Text(
            "$name:",
            style: const TextStyle(fontSize: 14, color: Colors.grey, fontStyle: FontStyle.italic),
            textAlign: TextAlign.end,
          ),
        ),
        Expanded(
            child: Text.rich(
              text,
              style: const TextStyle(fontSize: 15, height: 1.2),
              softWrap: true,
            ))
      ],
    ),
  );
}