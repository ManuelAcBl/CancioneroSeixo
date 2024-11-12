import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cancionero_seixo/model/providers/database/database_songs_notifier.dart';

class SearchFilterNotifier extends Notifier<List<DatabaseChange>?> {
  static final DateTime importDate = DateTime(2024, 07, 10);

  @override
  List<DatabaseChange>? build() {
    Query<Map<String, dynamic>> query = FirebaseFirestore.instance.collection("Songs").where("timestamp", isGreaterThan: importDate);

    query.snapshots().listen((data) {
      List<DatabaseChange>? elements = List.of(state ?? []);

      List<DocumentChange<Map<String, dynamic>>> changes = data.docChanges;

      for (DocumentChange<Map<String, dynamic>> change in changes) {
        Map<String, dynamic>? data = change.doc.data();

        if (data != null && change.type == DocumentChangeType.added) {

        }
      }
    });

    return null;
  }
}

class DatabaseChange {
  final HistoricElementType type;
  final HistoricElementAction action;
  final DatabaseElement element, previousElement;

  DatabaseChange({required this.type, required this.action, required this.element, required this.previousElement});
}

enum HistoricElementAction {
  add,
  edit,
  remove,
}

enum HistoricElementType {
  folder,
  song,
}
