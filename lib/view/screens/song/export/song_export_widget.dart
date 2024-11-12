import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cancionero_seixo/model/providers/database/database_references_notifier.dart';

class SongExportWidget extends ConsumerWidget {
  final Reference reference;

  const SongExportWidget({super.key, required this.reference});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      children: [
        Text(reference.song.title),
        Text("${reference.data.number} ${reference.folder.title}"),
        Text(reference.song.lyrics),
      ],
    );
  }
}
