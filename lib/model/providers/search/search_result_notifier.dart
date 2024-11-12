import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cancionero_seixo/model/providers/search/search_data_notifier.dart';
import 'package:cancionero_seixo/model/providers/search/search_providers.dart';

class SongSearchResultNotifier extends AutoDisposeNotifier<Iterable<SongSearchResult>?> {
  List<SongSearchData>? data;
  String query = "";

  @override
  Iterable<SongSearchResult>? build() {
    data = ref.watch(SearchProviders.data);

    if (data != null) search(query);

    return null;
  }

  late DateTime lastDateTime;

  void search(String query) async {
    Stopwatch stopwatch = Stopwatch()..start();

    DateTime thisDateTime = lastDateTime = DateTime.now();

    // if (query.isEmpty) {
    //   state = null;
    //   ref.read(SearchProviders.metrics.notifier).clear();
    //   return;
    // }

    this.query = query = SongSearchDataNotifier.normalize(query.replaceAll(" ", r"\s+"))!;

    Iterable<SongSearchResult> results = await compute(_searchSongs, {
      'data': data,
      "query": query,
    }).catchError((error) => print(error));

    if (thisDateTime == lastDateTime) {
      state = results;

      ref.read(SearchProviders.metrics.notifier).set(ref.read(SearchProviders.metrics).copyWith(
            search: stopwatch.elapsedMilliseconds,
            results: results.length,
          ));
    }
  }
}

final RegExp regExp = RegExp("(?:^.*\n)?.*().*(?:\n.*)?");

Future<Iterable<SongSearchResult>> _searchSongs(Map<String, dynamic> args) async {
  Iterable<SongSearchData> data = args['data'];
  String query = args['query'];

  RegExp regExp = RegExp(query);
  RegExp contextRegExp = RegExp("(?:^.*\n)?.*($query).*(?:\n.*)?", multiLine: true);

  Iterable<Future<SongSearchResult?>> results = data.map((song) => Future(() async {
        SearchMatch? titleMatch = _search(song.title, regExp);
        SearchMatch? numberMatch = _search(song.number, regExp);
        SearchMatch? authorsMatch = _search(song.authors, regExp);
        VerseSearchResult? verseSearchResult = _searchVerse(song.verses, regExp, contextRegExp);

        if (titleMatch == null && numberMatch == null && verseSearchResult == null && authorsMatch == null) return null;

        return SongSearchResult(
          referenceId: song.referenceId,
          title: titleMatch,
          number: numberMatch,
          authors: authorsMatch,
          verse: verseSearchResult,
        );
      }));

  Iterable<SongSearchResult> result = (await Future.wait(results)).whereType<SongSearchResult>();

  return result;
}

VerseSearchResult? _searchVerse(List<String>? verses, RegExp regExp, RegExp contextRegExp) {
  if (verses == null) return null;

  VerseSearchResult? searchVerse;

  for (int index = 0; index < verses.length; index++) {
    SearchMatch? match = _search(verses[index], regExp);

    if (match == null) continue;

    SearchMatch? contextMatch = _search(verses[index], contextRegExp);

    searchVerse = VerseSearchResult(index: index, match: match, contextMatch: contextMatch);
    break;
  }

  // searchVerse = VerseSearchResult(index: 0, contextMatch: _search(verses.first, regExp));

  return searchVerse;
}

SearchMatch? _search(String? text, RegExp regExp) {
  if (text == null) return null;

  RegExpMatch? match = regExp.firstMatch(text);

  if (match == null) return null;

  return SearchMatch(start: match.start, end: match.end);
}

class SearchMatch {
  final int start, end;

  SearchMatch({required this.start, required this.end});
}

class SongSearchResult {
  final String referenceId;
  final SearchMatch? title, number, authors;
  final VerseSearchResult? verse;

  SongSearchResult({required this.referenceId, required this.title, required this.number, required this.authors, required this.verse});
}

class VerseSearchResult {
  final int index;
  final SearchMatch? match, contextMatch;

  VerseSearchResult({required this.index, this.match, required this.contextMatch});
}
