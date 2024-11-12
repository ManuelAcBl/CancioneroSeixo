import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cancionero_seixo/model/providers/database/database_providers.dart';
import 'package:cancionero_seixo/model/providers/database/database_references_notifier.dart';
import 'package:cancionero_seixo/model/providers/search/search_filter_notifier.dart';
import 'package:cancionero_seixo/model/providers/search/search_providers.dart';

class SongSearchDataNotifier extends Notifier<List<SongSearchData>?> {
  @override
  List<SongSearchData>? build() {
    Map<String, Reference>? references = ref.watch(DatabaseProviders.references);
    SearchFilter filter = ref.watch(SearchProviders.filter);

    if (references != null) _loadData(references, filter);

    return null;
  }

  void _loadData(Map<String, Reference> references, SearchFilter filter) async {
    Stopwatch stopwatch = Stopwatch()..start();

    List<SongSearchData> data = await compute(_getSearchSongs, {
      'references': references,
      'searchFor': filter.searchFor,
    }).catchError((error) => print("[GETSONGS_ERROR] $error"));

    ref.read(SearchProviders.metrics.notifier).set(ref.read(SearchProviders.metrics).copyWith(cache: stopwatch.elapsedMilliseconds));

    stopwatch = Stopwatch()..start();

    data = await compute(_checkBook, {
      'results': data,
      'references': references,
      'bookIds': filter.searchIn,
    }).catchError((error) => print("[FILTER ERROR] $error"));

    ref.read(SearchProviders.metrics.notifier).set(ref.read(SearchProviders.metrics).copyWith(filter: stopwatch.elapsedMilliseconds));

    stopwatch = Stopwatch()..start();

    data = await compute(_order, {
      'results': data,
      'references': references,
      'orderBy': filter.orderBy,
    }).catchError((error) => print("[SORT ERROR] $error"));

    ref.read(SearchProviders.metrics.notifier).set(ref.read(SearchProviders.metrics).copyWith(sort: stopwatch.elapsedMilliseconds));

    state = data;
  }

  static String? normalize(String? text) {
    if (text == null) return null;

    return text
        .toLowerCase()
        .replaceAll('.', ' ')
        .replaceAll('¡', ' ')
        .replaceAll('!', ' ')
        .replaceAll('¿', ' ')
        .replaceAll('?', ' ')
        .replaceAll('(', ' ')
        .replaceAll(')', ' ')
        .replaceAll('/', ' ')
        .replaceAll(',', ' ')
        .replaceAll("á", "a")
        .replaceAll("é", "e")
        .replaceAll("í", "i")
        .replaceAll("ó", "o")
        .replaceAll("ú", "u")
        .replaceAll("à", "a")
        .replaceAll("è", "e")
        .replaceAll("ì", "i")
        .replaceAll("ò", "o")
        .replaceAll("ù", "u");
  }
}

List<SongSearchData> _getSearchSongs(Map<String, dynamic> args) {
  Map<String, Reference> references = args['references'];
  List<SearchFor> searchForList = args['searchFor'];

  bool check(SearchFor searchFor) => searchForList.contains(searchFor);

  return references.values.map((reference) {
    return SongSearchData(
      referenceId: reference.id,
      title: check(SearchFor.title) ? SongSearchDataNotifier.normalize(reference.song.title)! : null,
      number: check(SearchFor.number) ? SongSearchDataNotifier.normalize(reference.data.number) : null,
      verses: check(SearchFor.lyrics)
          ? reference.song.getVerses().map((verse) => SongSearchDataNotifier.normalize(verse.text)!).toList()
          : null,
      authors: check(SearchFor.author) ? SongSearchDataNotifier.normalize(reference.song.authors) : null,
    );
  }).toList();
}

Future<List<SongSearchData>> _checkBook(Map<String, dynamic> args) async {
  List<SongSearchData> data = args['results'];
  Map<String, Reference> references = args['references'];
  List<String> bookIds = args['bookIds'];

  Iterable<Future<SongSearchData?>> filteredData = data.map((song) => Future(() {
        String bookId = references[song.referenceId]?.folder.id ?? "-1";
        return bookIds.contains(bookId) ? song : null;
      }));

  data = (await Future.wait(filteredData)).whereType<SongSearchData>().toList();

  return data;
}

Future<List<SongSearchData>> _order(Map<String, dynamic> args) async {
  List<SongSearchData> data = args['results'];
  Map<String, Reference> references = args['references'];
  OrderBy orderBy = args['orderBy'];

  final RegExp regex = RegExp(r'^\d+');

  data.sort((element1, element2) {
    Reference reference1 = references[element1.referenceId]!;
    Reference reference2 = references[element2.referenceId]!;

    switch (orderBy) {
      case OrderBy.number:
        {
          String? number1 = reference1.data.number, number2 = reference2.data.number;

          if (number1 == null) return -1;
          if (number2 == null) return 1;

          int match1 = int.parse(regex.stringMatch(number1) ?? '9999');
          int match2 = int.parse(regex.stringMatch(number2) ?? '9999');

          if (match1 == match2) return number1.compareTo(number2);

          return match1 - match2;
        }
      case OrderBy.title:
        return reference1.song.title.compareTo(reference2.song.title);
      case OrderBy.book:
        return reference1.folder.title.compareTo(reference2.folder.title);
    }
  });

  return data;
}

class SongSearchData {
  final String referenceId;
  final String? number, title, authors;
  final List<String>? verses;

  SongSearchData({required this.referenceId, required this.title, required this.number, required this.verses, required this.authors});
}
