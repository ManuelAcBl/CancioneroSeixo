import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cancionero_seixo/model/data/song_edit_data.dart';
import 'package:cancionero_seixo/model/providers/database/database_providers.dart';
import 'package:cancionero_seixo/model/providers/database/database_references_notifier.dart';
import 'package:cancionero_seixo/view/screens/song/chords/song_chords_screen.dart';
import 'package:cancionero_seixo/view/screens/song/lyrics/song_lyrics_screen.dart';
import 'package:cancionero_seixo/view/screens/song/music/music_player_screen.dart';
import 'package:cancionero_seixo/view/screens/song/share/song_share.dart';
import 'package:cancionero_seixo/view/widgets/appbar/appbar_title_with_subtitle.dart';
import 'package:cancionero_seixo/view/widgets/text/centered_text.dart';

class SongScreen extends ConsumerWidget {
  final String referenceId;

  const SongScreen({super.key, required this.referenceId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Reference? reference = ref.watch(DatabaseProviders.references.select((references) => references![referenceId]));

    if (reference == null) return const CenteredText(text: "Error al cargar canción");

    // Settings
    //Settings? settings = ref.read(Providers.settings);
    //double fontSize = settings!.access.fontSize;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          leadingWidth: 45,
          actions: [
            PopupMenuButton(
              offset: const Offset(0, 60),
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: const Text("Compartir"),
                  onTap: () => showModalBottomSheet(
                    context: context,
                    builder: (context) => SongShareOptions(references: [reference]),
                  ),
                ),
                PopupMenuItem(
                  child: const Text("Editar"),
                  onTap: () => context.pushNamed('editor', extra: SongEditData(referenceId: reference.id)),
                ),
                PopupMenuItem(
                  child: const Text("Añadir a"),
                  onTap: () => context.pushNamed('add_to', extra: reference),
                ),
              ],
            ),
          ],
          title: AppBarTitleWithSubtitle(
            title: reference.song.title,
            subtitle: "${reference.data.number != null ? "${reference.data.number} " : ""}${reference.folder.title}",
          ),
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            SongLyrics(songId: reference.song.id),
            const MusicPlayer(),
            const SongChordsScreen(),
          ],
        ),
        bottomNavigationBar: const TabBar(
          tabs: [
            Tab(
              icon: Icon(Icons.format_align_left),
              child: Text("Letra"),
            ),
            Tab(
              icon: Icon(BootstrapIcons.youtube),
              child: Text("Reproductor"),
            ),
            Tab(
              icon: Icon(Icons.queue_music),
              child: Text("Acordes"),
            ),
          ],
        ),
      ),
    );
  }
}
