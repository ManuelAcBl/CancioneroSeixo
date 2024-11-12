import 'package:cancionero_seixo/model/providers/database/database_songs_notifier.dart';
import 'package:cancionero_seixo/model/providers/database/firestore_collection_notifier.dart';

class DatabaseFoldersNotifier extends FirestoreCollectionNotifier<Folder> {
  static final Folder _defaultFolder =
      Folder(id: "-1", title: "Otras", description: "Canciones sin carpeta", inHomePage: false, type: FolderType.other);

  DatabaseFoldersNotifier() : super(name: "Folders");

  @override
  Folder fromJson(Map<String, dynamic> json) => Folder.fromJson(json);

  @override
  Map<String, dynamic> toJson(Folder element) => element.toJson();

  @override
  bool notify(Map<String, Folder>? previous, Map<String, Folder>? next) {
    if (next != null && next[_defaultFolder.id] == null) {
      state = state!..[_defaultFolder.id] = _defaultFolder;
      return false;
    }

    return true;
  }

  @override
  String elementId(Folder element) => element.id;

  Future<String> add({required String title, required String description, bool homepage = false}) async {
    String id = await super.documentAdd({
      'title': title,
      'description': description,
      'homepage': homepage,
    });

    return id;
  }

  List<Folder>? getFolderList() => state?.values.toList();
}

class Folder extends DatabaseElement {
  final String id;
  final bool inHomePage;
  final String title, description;
  final FolderType type;

  Folder({
    required this.id,
    required this.title,
    required this.description,
    required this.inHomePage,
    this.type = FolderType.normal,
  });

  factory Folder.fromJson(Map<String, dynamic> json) => Folder(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        inHomePage: json['homepage'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'homepage': inHomePage,
      }..removeWhere((_, value) => value == null);

  Folder copyWith({bool? inHomePage, String? title, String? description}) => Folder(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      inHomePage: inHomePage ?? this.inHomePage,
      type: type);
}

enum FolderType {
  other,
  normal,
  personal;
}
