import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cancionero_seixo/model/providers/database/database_references_notifier.dart';
import 'package:cancionero_seixo/model/providers/selector/selection_providers.dart';

class SongListElement extends ConsumerWidget {
  final Reference reference;
  final bool selection, numbered;

  const SongListElement({super.key, required this.reference, required this.numbered, required this.selection});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool selected =
        ref.watch(SelectionProviders.selection.select((selection) => selection.any((reference) => this.reference.id == reference.id)));

    return ListTile(
      onTap: () => context.pushNamed('song', extra: reference.id),
      onLongPress: selection
          ? () {
              if (selected) {
                ref.read(SelectionProviders.selection.notifier).remove(reference);
              } else {
                ref.read(SelectionProviders.selection.notifier).add(reference);
              }
            }
          : null,
      selected: selected,
      selectedColor: Colors.black,
      selectedTileColor: Theme.of(context).highlightColor.withAlpha(50),
      leading: numbered
          ? Text(
              reference.data.number ?? "",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            )
          : null,
      title: Text(
        reference.song.title,
        style: const TextStyle(
          fontSize: 17,
        ),
      ),
    );
  }
}
