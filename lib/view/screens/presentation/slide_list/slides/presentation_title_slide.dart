import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cancionero_seixo/model/data/song_edit_data.dart';
import 'package:cancionero_seixo/model/providers/presentation/presentation_providers.dart';
import 'package:cancionero_seixo/model/providers/presentation/presentation_slides_notifier.dart';
import 'package:cancionero_seixo/model/providers/presentation/presentation_songs_notifier.dart';

class PresentationSongTitle extends ConsumerWidget {
  final SongTitle songTitle;

  const PresentationSongTitle({super.key, required this.songTitle});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    PresentationSongsNotifier notifier = ref.read(PresentationProviders.songs.notifier);

    SongData data = songTitle.songData;

    return Container(
      padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10),
      color: Theme.of(context).primaryColor.withAlpha(20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "${data.number != null ? "${data.number} " : ""}${data.book}",
                  style: const TextStyle(color: Colors.blueGrey, fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
          PopupMenuButton(
            offset: const Offset(0, 60),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: const Text("Quitar"),
                onTap: () => notifier.remove(data.referenceId),
              ),
              PopupMenuItem(
                child: const Text("Editar"),
                onTap: () => context.pushNamed("editor", extra: SongEditData(referenceId: data.referenceId)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
