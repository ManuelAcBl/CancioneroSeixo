import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cancionero_seixo/model/providers/database/database_folders_notifier.dart';
import 'package:cancionero_seixo/model/providers/database/database_references_notifier.dart';
import 'package:cancionero_seixo/model/providers/database/database_songs_notifier.dart';

abstract class DatabaseProviders {
  static final songs = NotifierProvider<DatabaseSongsNotifier, Map<String, Song>?>(DatabaseSongsNotifier.new);
  static final folders = NotifierProvider<DatabaseFoldersNotifier, Map<String, Folder>?>(DatabaseFoldersNotifier.new);
  static final references = NotifierProvider<DatabaseReferencesNotifier, Map<String, Reference>?>(DatabaseReferencesNotifier.new);
}

// class SongFolderData {
//   final String songId, folderId;
//
//   SongFolderData({required this.songId, required this.folderId});
//
//   factory SongFolderData.fromJson(Map<String, dynamic> json) => SongFolderData(
//         songId: json['songId'],
//         folderId: json['folderId'],
//       );
//
//   Map<String, dynamic> toJson() => {
//         'songId': songId,
//         'folderId': folderId,
//       };
//
//   bool equals(SongFolderData? other) => songId == other?.songId && folderId == other?.folderId;
// }
