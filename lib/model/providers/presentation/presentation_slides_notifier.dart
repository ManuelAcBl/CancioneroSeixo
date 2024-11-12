import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cancionero_seixo/model/providers/database/database_providers.dart';
import 'package:cancionero_seixo/model/providers/database/database_references_notifier.dart';
import 'package:cancionero_seixo/model/providers/database/database_songs_notifier.dart';
import 'package:cancionero_seixo/model/providers/presentation/presentation_providers.dart';

class PresentationDataNotifier extends Notifier<PresentationData?> {
  @override
  PresentationData? build() {
    Map<String, Reference>? references = ref.watch(DatabaseProviders.references);
    List<String>? referencesIds = ref.watch(PresentationProviders.songs);

    if (references == null || referencesIds == null) return null;

    if (referencesIds.isEmpty) return PresentationData(elements: []);

    int index = 0;
    List<PresentationElement> elements = [SpaceSlide(index: index++)];
    for (String referenceId in referencesIds) {
      Reference reference = ref.watch(DatabaseProviders.references.select((references) => references![referenceId]!));

      SongData songData = SongData(
        referenceId: referenceId,
        title: reference.song.title,
        book: reference.folder.title,
        number: reference.data.number,
        authors: reference.song.authors,
      );

      List<VerseData>? verses =
          ref.watch(DatabaseProviders.references.select((songs) => songs?[referenceId]?.song.getVerses(ordered: true)));

      elements.add(SongTitle(songData: songData));

      for (VerseData verse in verses!) {
        elements.add(VerseSlide(
          song: songData,
          index: index++,
          verse: verse,
        ));
      }

      elements.add(SpaceSlide(index: index++));
    }

    return PresentationData(elements: elements);
  }
}

class PresentationData {
  final List<PresentationElement> elements;

  PresentationData({required this.elements});

  Iterable<Slide> getSlides() => elements.whereType<Slide>();
}

class SpaceSlide extends Slide {
  SpaceSlide({required super.index});
}

class VerseSlide extends Slide {
  final VerseData verse;
  final SongData song;

  VerseSlide({
    required super.index,
    required this.verse,
    required this.song,
  });

  factory VerseSlide.fromJson(Map<String, dynamic> json) => VerseSlide(
        index: json['index'],
        verse: VerseData.fromJson(json['verse']),
        song: SongData.fromJson(json['song']),
      );

  Map<String, dynamic> toJson() => {
        'index': index,
        'verse': verse.toJson(),
        'song': song.toJson(),
      };
}

class SongTitle extends PresentationElement {
  final SongData songData;

  SongTitle({required this.songData});
}

abstract class PresentationElement {}

abstract class Slide extends PresentationElement {
  final int index;

  Slide({required this.index});
}

class SongData {
  final String referenceId, title, book;
  final String? number, authors;

  SongData({required this.referenceId, required this.title, required this.book, this.number, this.authors});

  factory SongData.fromJson(Map<String, dynamic> json) => SongData(
        referenceId: json['referenceId'],
        title: json['title'],
        book: json['book'],
        number: json['number'],
        authors: json['authors'],
      );

  Map<String, dynamic> toJson() => {
        'referenceId': referenceId,
        'title': title,
        'book': book,
        'number': number,
        'authors': authors,
      };
}
