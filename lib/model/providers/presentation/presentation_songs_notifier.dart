import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cancionero_seixo/controller/utils/local_save/local_save.dart';

class PresentationSongsNotifier extends Notifier<List<String>?> {
  final LocalSave saver = LocalSave<List<String>>(
    name: "presentation_songs",
    fromJson: (json) => (json as List<dynamic>).cast<String>(),
  );

  @override
  List<String>? build() {
    Future(() async {
      return state = (await saver.load()) ?? [];
    });

    return null;
  }

  @override
  bool updateShouldNotify(List<String>? previous, List<String>? next) {
    if (next != null) saver.save(next);

    return super.updateShouldNotify(previous, next);
  }

  void add(String referenceId) {
    if (state?.contains(referenceId) == true) return;

    state = [...state ?? [], referenceId];
  }

  void addAll(Iterable<String> referencesIds) {
    referencesIds = referencesIds.where((referenceId) => state?.contains(referenceId) == false);

    if (referencesIds.isEmpty) return;

    state = [...state ?? [], ...referencesIds];
  }

  void remove(String referenceId) {
    if (state?.contains(referenceId) == false) return;

    state = [...(state ?? [])..remove(referenceId)];
  }

  void clear() => state = [];

// Future<void> _save() async {
//   SharedPreferences local = await SharedPreferences.getInstance();
//   await local.setString('presentation_songs', jsonEncode(state));
// }
//
// Future<void> _load() async {
//   SharedPreferences local = await SharedPreferences.getInstance();
//   state = jsonDecode(local.getString('presentation_songs') ?? "[]");
// }
}
