import 'package:cancionero_seixo/model/providers/database/firestore_collection_notifier.dart';

class DatabaseSongsNotifier extends FirestoreCollectionNotifier<Song> {
  DatabaseSongsNotifier() : super(name: "Songs");

  @override
  Song fromJson(Map<String, dynamic> json) => Song.fromJson(json);

  @override
  Map<String, dynamic> toJson(Song element) => element.toJson();

  Future<String> add(
      {required String title, required String lyrics, String? authors, String? order, List<DatabaseReference>? references}) async {
    String id = await documentAdd({
      'title': title,
      'authors': authors,
      'order': order,
      'lyrics': lyrics,
      'references': references?.map((reference) => reference.toJson()),
    });

    return id;
  }

  @override
  bool notify(Map<String, Song>? previous, Map<String, Song>? next) => true;

  @override
  String elementId(Song element) => element.id;
}

abstract class DatabaseElement {}

class Song extends DatabaseElement {
  final String id;
  final String? authors, order;
  final String title, lyrics;
  final List<Video>? videos = [
    Video(
      author: "IBGD Quilicura",
      youtubeId: "s01CBhmaCqA",
      type: VideoType.both,
    ),
    Video(
      author: "SovereignGraceMusic",
      youtubeId: "RSAsPD3DN2A",
      type: VideoType.both,
    ),
  ];
  final List<DatabaseReference>? references;

  Song({
    required this.id,
    required this.title,
    this.authors,
    this.order,
    required this.lyrics,
    required this.references,
  });

  factory Song.fromJson(Map<String, dynamic> json) => Song(
        id: json['id'],
        title: json['title'],
        order: json['order'],
        authors: json['authors'],
        lyrics: json['lyrics'],
        references: (json['references'] as List<dynamic>?)?.map((reference) => DatabaseReference.fromJson(reference)).toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'authors': authors,
        'order': order,
        'lyrics': lyrics,
        'references': references?.map((reference) => reference.toJson()).toList(),
      }..removeWhere((_, value) => value == null);

  Song copyWith({String? title, String? authors, String? order, String? lyrics, List<DatabaseReference>? references}) => Song(
        id: id,
        title: title ?? this.title,
        authors: authors ?? this.authors,
        order: order ?? this.order,
        lyrics: lyrics ?? this.lyrics,
        references: references ?? this.references,
      );

  DatabaseReference? reference(String folderId) => references?.firstWhere((reference) => reference.folder == folderId);

  List<VerseData> getVerses({bool? ordered}) {
    RegExp exp = RegExp(r'\[((\w)(\d*))\]\n\s*([\s\S]+?)(?=\n\[|\n\n|$)', dotAll: true);
    Iterable<RegExpMatch> matches = exp.allMatches(lyrics);

    if (matches.isEmpty) return [VerseData(name: "Estrofa 1", text: lyrics, type: VerseType.verse)];

    List<VerseData> verses = [];

    if (ordered == true && order != null) {
      for (String verseId in order!.split(" ")) {
        RegExpMatch match = matches.firstWhere((match) => match.group(1)! == verseId);

        String letter = match.group(2)!;
        String? position = match.group(3);

        for (String text in match.group(4)!.split("||")) {
          verses.add(VerseData(
            name: _getVerseName(letter, position),
            text: text,
            type: _getVerseType(letter),
          ));
        }
      }
    } else {
      for (int index = 0; index < matches.length; index++) {
        RegExpMatch match = matches.elementAt(index);

        String letter = match.group(2)!;
        String? position = match.group(3);

        verses.add(VerseData(
          name: _getVerseName(letter, position),
          text: match.group(4)!.split("||").reduce((value, element) => "$value\n$element"),
          type: _getVerseType(letter),
        ));
      }
    }

    return verses;
  }

  _getVerseType(String letter) =>
      {
        'V': VerseType.verse,
        'C': VerseType.chorus,
        'P': VerseType.preChorus,
        'B': VerseType.bridge,
      }[letter] ??
      VerseType.verse;

  _getVerseName(String letter, String? position) {
    String name = {
          'V': 'Estrofa',
          'C': 'Coro',
          'P': 'Pre coro',
          'B': 'Puente',
        }[letter] ??
        "Estrofa";

    return "$name${position != null ? " $position" : ""}";
  }
}

class DatabaseReference {
  final String folder;
  final String? number;

  DatabaseReference({required this.folder, this.number});

  factory DatabaseReference.fromJson(Map<String, dynamic> json) => DatabaseReference(
        folder: json['folder'],
        number: json['number'],
      );

  Map<String, dynamic> toJson() => {
        'folder': folder,
        'number': number,
      };

  DatabaseReference copyWith({String? folder, String? number}) =>
      DatabaseReference(folder: folder ?? this.folder, number: number ?? this.number);
}

class VerseData {
  final String name, text;
  final VerseType type;

  VerseData({required this.name, required this.text, required this.type});

  VerseData copyWith({String? name, String? text, VerseType? type}) => VerseData(
        name: name ?? this.name,
        text: text ?? this.text,
        type: type ?? this.type,
      );

  factory VerseData.fromJson(Map<String, dynamic> json) => VerseData(
        name: json['name'],
        text: json['text'],
        type: VerseType.values.byName(json['type']),
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'text': text,
        'type': type.name,
      };
}

enum VerseType { verse, chorus, bridge, preChorus }

class Video {
  final String author, youtubeId;
  final VideoType type;

  Video({required this.author, required this.youtubeId, required this.type});
}

enum VideoType {
  music,
  voice,
  both;
}
