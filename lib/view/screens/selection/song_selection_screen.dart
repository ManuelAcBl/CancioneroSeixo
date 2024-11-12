import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:cancionero_seixo/model/providers/database/database_folders_notifier.dart';
import 'package:cancionero_seixo/model/providers/database/database_references_notifier.dart';
import 'package:cancionero_seixo/model/providers/selector/selection_providers.dart';
import 'package:cancionero_seixo/view/screens/selection/song_selection_appbar.dart';
import 'package:cancionero_seixo/view/screens/song/share/song_share.dart';
import 'package:cancionero_seixo/view/widgets/floating_button/custom_extended_floating_button.dart';
import 'package:cancionero_seixo/view/widgets/form/selection/folder_bottom_sheet_selector.dart';

class SongSelectionScreen extends ConsumerWidget {
  final bool? presentation;

  const SongSelectionScreen({super.key, required this.presentation});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Reference> selection = ref.read(SelectionProviders.selection);

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: ScreenSongSelectionAppbar(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: selection.map((reference) => SongSelectionElement(reference: reference)).toList(),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: presentation == true
            ? [
                CustomExtendedFloatingButton(
                  color: Colors.white,
                  backgroundColor: Theme.of(context).primaryColor,
                  text: "Presentar",
                  icon: Icons.cast_connected,
                  onTap: () => showModalBottomSheet(
                    context: context,
                    builder: (context) => SongShareOptions(references: selection),
                  ),
                ),
              ]
            : [
                CustomExtendedFloatingButton(
                  color: Colors.white,
                  backgroundColor: Theme.of(context).primaryColor,
                  text: "Compartir",
                  icon: Icons.share,
                  onTap: () => showModalBottomSheet(
                    context: context,
                    builder: (context) => SongShareOptions(references: selection),
                  ),
                ),
                const Gap(10),
                CustomExtendedFloatingButton(
                  color: Colors.white,
                  backgroundColor: Theme.of(context).primaryColor,
                  text: "Mover a",
                  icon: Icons.drive_file_move,
                  onTap: () async {
                    Folder? folder = await showModalBottomSheet(
                      context: context,
                      builder: (context) => const FolderBottomSheetSelector(),
                    );
                  },
                ),
                const Gap(10),
                CustomExtendedFloatingButton(
                  color: Colors.white,
                  backgroundColor: Theme.of(context).primaryColor,
                  text: "Copiar a",
                  icon: Icons.file_copy,
                  onTap: () async {
                    Folder? folder = await showModalBottomSheet(
                      context: context,
                      builder: (context) => const FolderBottomSheetSelector(),
                    );
                  },
                ),
                const Gap(10),
                CustomExtendedFloatingButton(
                  color: Colors.white,
                  backgroundColor: Theme.of(context).primaryColor,
                  text: "Eliminar",
                  icon: Icons.delete,
                  onTap: () => showModalBottomSheet(
                    context: context,
                    builder: (context) => SongShareOptions(references: selection),
                  ),
                ),
                const Gap(10),
                CustomExtendedFloatingButton(
                  color: Colors.white,
                  backgroundColor: Theme.of(context).primaryColor,
                  text: "Presentar",
                  icon: Icons.cast_connected,
                  onTap: () => showModalBottomSheet(
                    context: context,
                    builder: (context) => SongShareOptions(references: selection),
                  ),
                ),
              ],
      ),
    );
  }
}

class SongSelectionElement extends ConsumerWidget {
  final Reference reference;

  const SongSelectionElement({super.key, required this.reference});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      onTap: () => context.push("/song", extra: reference.id),
      title: Text(
        reference.song.title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        "${reference.data.number ?? ""} ${reference.folder.title}",
        style: const TextStyle(fontStyle: FontStyle.italic),
      ),
      trailing: IconButton(
        onPressed: () => ref.read(SelectionProviders.selection.notifier).remove(reference),
        icon: const Icon(Icons.close),
      ),
    );
  }
}
