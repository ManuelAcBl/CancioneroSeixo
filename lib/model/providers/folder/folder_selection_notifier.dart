import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cancionero_seixo/model/providers/database/database_providers.dart';
import 'package:cancionero_seixo/model/providers/database/database_references_notifier.dart';

class FolderSelectionNotifier extends Notifier<List<String>> {
  @override
  List<String> build() => [];

  void add(String referenceId) => state = [...state, referenceId];

  void remove(String referenceId) => state = [...state..remove(referenceId)];

  void clear(String folderId) {
    Map<String, Reference>? references = ref.read(DatabaseProviders.references);

    if (references == null) return;

    state = [...state..removeWhere((referenceId) => references[referenceId]?.folder.id == folderId)];
  }

  void toggle(String referenceId) {
    if (state.contains(referenceId)) {
      remove(referenceId);
    } else {
      add(referenceId);
    }
  }
}
