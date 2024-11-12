import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cancionero_seixo/model/providers/database/database_providers.dart';
import 'package:cancionero_seixo/model/providers/providers.dart';

class SongLyricsAuthors extends ConsumerWidget {
  final String songId;

  const SongLyricsAuthors({super.key, required this.songId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String? authors = ref.watch(DatabaseProviders.songs.select((songs) => songs![songId]?.authors));

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Text(
        "Autor/es:${authors != null ? "\n$authors" : " Desconocido"}",
        style: const TextStyle(color: Colors.grey),
      ),
    );
  }
}
