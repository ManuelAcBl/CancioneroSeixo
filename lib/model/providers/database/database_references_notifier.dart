import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cancionero_seixo/model/providers/database/database_folders_notifier.dart';
import 'package:cancionero_seixo/model/providers/database/database_providers.dart';
import 'package:cancionero_seixo/model/providers/database/database_songs_notifier.dart';

class DatabaseReferencesNotifier extends Notifier<Map<String, Reference>?> {
  static final DatabaseReference _defaultReference = DatabaseReference(folder: "-1");

  @override
  Map<String, Reference>? build() {
    Map<String, Song>? songs = ref.watch(DatabaseProviders.songs);
    Map<String, Folder>? folders = ref.watch(DatabaseProviders.folders);

    if (songs == null || folders == null) return null;

    Map<String, Reference> references = {};

    for (Song song in songs.values) {
      for (DatabaseReference reference in song.references ?? [_defaultReference]) {
        String id = "${song.id}-${reference.folder}";
        references[id] = Reference(id: id, song: song, folder: folders[reference.folder]!, data: reference);
      }
    }

    RegExp regex = RegExp(r'^\d+');
    List<MapEntry<String, Reference>> entries = references.entries.toList();

    entries.sort((reference1, reference2) {
      String? number1 = reference1.value.data.number, number2 = reference2.value.data.number;

      if (number1 == null) return -1;
      if (number2 == null) return 1;

      int match1 = int.parse(regex.stringMatch(number1) ?? '9999');
      int match2 = int.parse(regex.stringMatch(number2) ?? '9999');

      if (match1 == match2) return number1.compareTo(number2);

      return match1 - match2;
    });

    return Map.fromEntries(entries);
  }
}

class Reference {
  final String id;
  final Song song;
  final Folder folder;
  final DatabaseReference data;

  Reference({required this.id, required this.song, required this.folder, required this.data});
}
