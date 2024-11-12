import 'package:cancionero_seixo/model/providers/database/database_folders_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cancionero_seixo/model/providers/database/database_providers.dart';
import 'package:cancionero_seixo/model/providers/database/database_references_notifier.dart';
import 'package:cancionero_seixo/model/providers/selector/selection_providers.dart';
import 'package:cancionero_seixo/view/screens/selection/song_selection_appbar.dart';
import 'package:cancionero_seixo/view/screens/song_list/song_list_element.dart';
import 'package:cancionero_seixo/view/widgets/text/centered_text.dart';
import 'package:cancionero_seixo/view/widgets/scrollbar/custom_scrollbar.dart';
import 'package:cancionero_seixo/view/widgets/text/info_message.dart';

class SongList extends ConsumerStatefulWidget {
  final String folderId;
  final bool selection;

  const SongList({super.key, required this.folderId, required this.selection});

  @override
  ConsumerState<SongList> createState() => _SongListState();
}

class _SongListState extends ConsumerState<SongList> with AutomaticKeepAliveClientMixin {
  late final ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    Stopwatch stopwatch = Stopwatch()..start();

    Folder folder = ref.read(DatabaseProviders.folders.select((folders) => folders![widget.folderId]!));

    print("SongList '${folder.title}' building...");
    List<Reference>? references = ref.watch(
      DatabaseProviders.references.select(
        (references) => references?.values.where((reference) => reference.folder.id == folder.id).toList(),
      ),
    );

    if (references == null) return const CenteredText(text: "Cargando canciones...");

    if (references.isEmpty) {
      return const InfoMessage(
        title: "Carpeta Vacía",
        text: "No has añadido ninguna canción",
      );
    }

    bool numbered = references.any((reference) => reference.data.number != null);

    print("SongList built! (${references.length} elements) (${stopwatch.elapsedMilliseconds}ms)");

    return Column(
      children: [
        Expanded(
          child: CustomScrollbar(
            controller: _controller,
            child: ListView.builder(
              controller: _controller,
              itemCount: references.length,
              itemBuilder: (_, index) {
                return SongListElement(
                  reference: references.elementAt(index),
                  numbered: numbered,
                  selection: widget.selection,
                );
              },
            ),
          ),
        ),
        BottomSongSelectionAppBar(
          action: IconButton(
            onPressed: () {
              List<Reference> selection = ref.read(SelectionProviders.selection);

              bool allSelected = references.any((reference) => !selection.contains(reference));

              if (allSelected) {
                ref.read(SelectionProviders.selection.notifier).addAll(references);
              } else {
                ref.read(SelectionProviders.selection.notifier).removeAll(references);
              }
            },
            icon: const Icon(
              Icons.done_all,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
