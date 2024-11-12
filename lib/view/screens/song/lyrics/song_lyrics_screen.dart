import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:cancionero_seixo/model/providers/database/database_providers.dart';
import 'package:cancionero_seixo/model/providers/database/database_songs_notifier.dart';
import 'package:cancionero_seixo/model/providers/settings/settings_providers.dart';
import 'package:cancionero_seixo/view/screens/song/lyrics/song_lyrics_authors.dart';
import 'package:cancionero_seixo/view/screens/song/lyrics/song_lyrics_verse.dart';

class SongLyrics extends ConsumerStatefulWidget {
  final String songId;

  const SongLyrics({super.key, required this.songId});

  @override
  ConsumerState<SongLyrics> createState() => _SongLyricsState();
}

class _SongLyricsState extends ConsumerState<SongLyrics> with AutomaticKeepAliveClientMixin {
  //double _scaleFactor = 1.0;
  double? _startFontSize;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    List<VerseData> verses = ref.watch(DatabaseProviders.songs.select((songs) => songs![widget.songId]!.getVerses()));

    return GestureDetector(
      onDoubleTap: () => ref.read(SettingsProviders.personalization.notifier).update(fontSize: 18),
      onScaleStart: (details) {
        if (details.pointerCount != 2) return;

        //print("[SCALE] Start (${details.focalPoint})");
        _startFontSize = ref.read(SettingsProviders.personalization).fontSize;
        //_scaleFactor = 1.0;
      },
      onScaleUpdate: (details) {
        if (details.pointerCount != 2) return;

        //_scaleFactor *= details.scale;

        double fontSize = (_startFontSize! * details.scale).floor().toDouble().clamp(14, 27);

        //print("[SCALE] Update (${details.scale}) (${fontSize}px)");

        ref.read(SettingsProviders.personalization.notifier).update(fontSize: fontSize);
      },
      onScaleEnd: (details) {
        if (details.pointerCount != 1) return;

        //print("[SCALE] End");
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Gap(5),
              ...verses.map((verse) {
                return SongLyricsVerse(
                  name: verse.name,
                  text: verse.text,
                  isChorus: verse.type == VerseType.chorus || verse.type == VerseType.preChorus || verse.type == VerseType.bridge,
                );
              }),
              const Gap(10),
              SongLyricsAuthors(songId: widget.songId),
              const Gap(10),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
