import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cancionero_seixo/model/providers/database/database_providers.dart';
import 'package:cancionero_seixo/model/providers/database/database_references_notifier.dart';
import 'package:cancionero_seixo/model/providers/database/database_songs_notifier.dart';
import 'package:cancionero_seixo/model/providers/presentation/presentation_providers.dart';
import 'package:cancionero_seixo/model/providers/search/search_result_notifier.dart';
import 'package:cancionero_seixo/model/providers/selector/search_selection_notifier.dart';
import 'package:cancionero_seixo/model/providers/selector/selection_providers.dart';
import 'package:cancionero_seixo/view/screens/search/result_list/result_song_tile_verse.dart';

class SearchSongTile extends ConsumerWidget {
  static const TextStyle decoratorsStyle = TextStyle(fontStyle: FontStyle.italic, color: Colors.grey);

  final SongSearchResult result;
  final TextStyle highlightStyle;
  final bool presentation;

  const SearchSongTile({super.key, required this.result, required this.highlightStyle, required this.presentation});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String referenceId = result.referenceId;

    Reference reference = ref.watch(DatabaseProviders.references.select((references) => references![referenceId]!));
    VerseData verse = reference.song.getVerses()[result.verse?.index ?? 0];

    bool selected = ref.watch(SelectionProviders.selection.select((references) => references.contains(reference)));

    return InkWell(
      onTap: () {
        if (presentation) {
          ref.read(PresentationProviders.songs.notifier).add(referenceId);
          context.go("/presentation");
          return;
        }

        context.pushNamed("song", extra: referenceId);
      },
      onDoubleTap: presentation
          ? () {
              ref.read(PresentationProviders.songs.notifier).add(referenceId);
              ref.read(PresentationProviders.index.notifier).setToSong(referenceId);
              context.go("/presentation");
            }
          : null,
      onLongPress: () {
        SearchSelectionNotifier notifier = ref.read(SelectionProviders.selection.notifier);

        if (selected) {
          notifier.remove(reference);
          return;
        }

        notifier.add(reference);
      },
      child: Container(
        color: selected ? Theme.of(context).primaryColorLight.withOpacity(1) : null,
        child: SearchSongElement(
          title: _highlight(reference.song.title, match: result.title) ?? TextSpan(text: reference.song.title),
          number: _highlight(reference.data.number, match: result.number) ?? TextSpan(text: reference.data.number),
          folder: reference.folder.title,
          authors: _highlight(reference.song.authors, match: result.authors),
          verseName: verse.name,
          verse: _highlightVerses(
            verse.text,
            match: result.verse?.match,
            contextMatch: result.verse?.contextMatch,
          ),
        ),
      ),
    );
  }

  TextSpan _highlightVerses(String text, {required SearchMatch? match, required SearchMatch? contextMatch}) {
    if (match == null || contextMatch == null) {
      match = SearchMatch(start: 0, end: 0);

      RegExpMatch? m = RegExp("(?:^.*\n)?.*.*(?:\n.*)?", multiLine: true).firstMatch(text);
      contextMatch = SearchMatch(start: m!.start, end: m.end);
    }

    return TextSpan(children: [
      TextSpan(text: "\"${contextMatch.start == 0 ? '' : '…'} ", style: decoratorsStyle),
      TextSpan(text: text.substring(contextMatch.start, match.start)),
      TextSpan(text: text.substring(match.start, match.end), style: highlightStyle),
      TextSpan(text: text.substring(match.end, contextMatch.end)),
      TextSpan(text: " ${contextMatch.end == text.length ? '' : '…'}\"", style: decoratorsStyle)
    ]);
  }

  TextSpan? _highlight(String? text, {required SearchMatch? match}) {
    if (text == null || match == null) return null;

    return TextSpan(children: [
      TextSpan(text: text.substring(0, match.start)),
      TextSpan(text: text.substring(match.start, match.end), style: highlightStyle),
      TextSpan(text: text.substring(match.end, text.length)),
    ]);
  }
}

class SearchSongElement extends StatelessWidget {
  final TextSpan title;
  final TextSpan? number, verse, authors;
  final String folder;
  final String? verseName;

  const SearchSongElement({super.key, required this.title, required this.folder, this.number, this.authors, this.verse, this.verseName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text.rich(
                  title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 3),
                child: Text.rich(
                  number ?? const TextSpan(),
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                  textAlign: TextAlign.end,
                ),
              ),
              Text(
                folder,
                textAlign: TextAlign.end,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              )
            ],
          ),
          ResultAuthors(authors: authors),
          verse == null || verseName == null
              ? const SizedBox()
              : SearchSongTileVerse(name: verseName ?? "", text: verse ?? const TextSpan()),
        ],
      ),
    );
  }
}

class ResultAuthors extends StatelessWidget {
  final TextSpan? authors;

  const ResultAuthors({super.key, required this.authors});

  @override
  Widget build(BuildContext context) {
    if (authors == null) return const SizedBox();

    return Row(
      children: [
        Text(
          "Autor/es: ",
          style: TextStyle(color: Theme.of(context).iconTheme.color),
        ),
        Expanded(
          child: Text.rich(
            authors!,
            style: const TextStyle(color: Colors.grey, fontSize: 14),
            textAlign: TextAlign.start,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );
  }
}
