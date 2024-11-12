import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cancionero_seixo/controller/utils/local_save/local_save.dart';

abstract class FirestoreCollectionNotifier<T> extends Notifier<Map<String, T>?> {
  late final LocalSave<List<T>?> saver;
  final String name;

  FirestoreCollectionNotifier({required this.name}) {
    saver = LocalSave<List<T>>(
      name: name,
      fromJson: (json) => (json as List<dynamic>).map((json) => fromJson(json)).toList(),
      toJson: (data) => List<Map<String, dynamic>>.from(data.map((element) => toJson(element))),
    );
  }

  @override
  Map<String, T>? build() {
    Stopwatch stopwatch = Stopwatch()..start();

    Future(() async {
      List<T>? elements = await saver.load();

      if (elements == null || state != null) return;

      print("[LOCAL_SAVE] $name local data loaded! (${stopwatch.elapsedMilliseconds}ms)");

      state = Map.fromEntries(elements.map((element) => MapEntry(elementId(element), element)));
    });

    Future(() {
      _collection().snapshots().listen((event) {
        Stopwatch stopwatch = Stopwatch()..start();
        Map<String, T>? elements = Map.of(state ?? {});

        List<DocumentChange<Map<String, dynamic>>> changes = event.docChanges;

        changes.sort((change1, change2) => change1.doc.data()?['timestamp'].compareTo(change2.doc.data()?['timestamp']));

        print("[DATABASE] Updating $name (${changes.length} elements)...");

        for (DocumentChange<Map<String, dynamic>> change in changes) {
          DocumentSnapshot<Map<String, dynamic>> document = change.doc;

          switch (change.type) {
            case DocumentChangeType.added:
              elements[document.data()!['id']] = fromJson(document.data()!);

            case DocumentChangeType.modified:
            case DocumentChangeType.removed:
          }
        }

        state = elements;
        localSave();
        print("[DATABASE] $name updated! (${event.docChanges.length} elements) (${stopwatch.elapsedMilliseconds}ms)");
      });
    });

    return null;
  }

  @override
  bool updateShouldNotify(Map<String, T>? previous, Map<String, T>? next) {
    super.updateShouldNotify(previous, next);

    bool update = notify(previous, next);

    return update;
  }

  Future<void> localSave() async {
    Stopwatch stopwatch = Stopwatch()..start();

    await saver.save(state?.values.toList());

    print("[LOCAL_SAVE] $name data local saved! (${stopwatch.elapsedMilliseconds}ms)");
  }

  bool notify(Map<String, T>? previous, Map<String, T>? next);

  Future<void> remove(T element) async => await _collection().add(
        toJson(element)
          ..['removed'] = true
          ..['timestamp'] = FieldValue.serverTimestamp(),
      );

  Future<void> edit(T element) async => await _collection().add(
        toJson(element)..['timestamp'] = FieldValue.serverTimestamp(),
      );

  Future<String> documentAdd(Map<String, dynamic> data) async {
    late String id;

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      id = (await _collection().add(data..removeWhere((_, value) => value == null))).id;

      await documentSet(id, data..['id'] = id);
    });

    return id;
  }

  Future<void> documentSet(String id, Map<String, dynamic> data) async {
    await _collection().doc(id).set(data..['timestamp'] = FieldValue.serverTimestamp());
  }

  String elementId(T element);

  T? get(String id) => state?[id];

  CollectionReference<Map<String, dynamic>> _collection() => FirebaseFirestore.instance.collection(name);

  T fromJson(Map<String, dynamic> json);

  Map<String, dynamic> toJson(T element);
}
