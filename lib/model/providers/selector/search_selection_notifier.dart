import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cancionero_seixo/model/providers/database/database_references_notifier.dart';

class SearchSelectionNotifier extends Notifier<List<Reference>> {
  @override
  List<Reference> build() => [];

  void add(Reference reference) => state = [...state, reference];

  void addAll(List<Reference> references) => state = [...state, ...[...references]..removeWhere((reference) => state.contains(reference))];

  void remove(Reference reference) => state = [...state.where((ref) => reference != ref)];

  void removeAll(List<Reference> references) {
    Iterable<Reference> selected = references.where((reference) => state.contains(reference));

    state = [...state..removeWhere((reference) => selected.contains(reference))];
  }

  void clear() => state = [];


}
