import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:cancionero_seixo/model/providers/database/database_folders_notifier.dart';
import 'package:cancionero_seixo/model/providers/database/database_providers.dart';
import 'package:cancionero_seixo/model/providers/database/database_references_notifier.dart';
import 'package:cancionero_seixo/model/providers/providers.dart';
import 'package:cancionero_seixo/view/screens/folder/folder_info.dart';
import 'package:cancionero_seixo/view/screens/folder/remove/folder_remove_alert.dart';
import 'package:cancionero_seixo/view/widgets/floating_button/custom_extended_floating_button.dart';
import 'package:cancionero_seixo/view/widgets/screens/error_screen.dart';
import 'package:cancionero_seixo/view/screens/song_list/song_list.dart';
import 'package:cancionero_seixo/view/widgets/screens/shell_screen.dart';
import 'package:cancionero_seixo/view/widgets/appbar/appbar_title_with_subtitle.dart';

class FolderShellScreen extends ConsumerWidget with ShellScreen {
  final String folderId;

  const FolderShellScreen({super.key, required this.folderId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    DatabaseFoldersNotifier notifier = ref.read(DatabaseProviders.folders.notifier);
    Folder? folder = ref.read(DatabaseProviders.folders)?[folderId];

    if (folder == null) return const ErrorScreen(message: "Error al cargar esta carpeta");

    return Scaffold(
      appBar: AppBar(
        leading: leading(context),
        title: BookAppBarTitle(bookId: folderId),
        actions: [
          IconButton(
            onPressed: () => showModalBottomSheet(
              context: context,
              builder: (context) => FolderInfoBottomSheet(folderId: folderId),
            ),
            icon: const Icon(BootstrapIcons.info_lg),
          ),
          PopupMenuButton(
              offset: const Offset(0, 60),
              itemBuilder: (context) => [
                    PopupMenuItem(
                      child: const Text("Editar"),
                      onTap: () => context.pushNamed("folder_editor", extra: ref.read(DatabaseProviders.folders)![folderId]!),
                    ),
                    PopupMenuItem(
                      child: const Text("Compartir"),
                      onTap: () {},
                    ),
                    PopupMenuItem(
                      child: const Text("Eliminar"),
                      onTap: () async {
                        bool? remove = await showDialog(
                          context: context,
                          builder: (context) => FolderRemoveAlert(folderId: folderId),
                        );

                        if (remove == true && context.mounted) {
                          notifier.remove(folder);
                          context.goNamed('home');
                        }
                      },
                    ),
                  ])
        ],
      ),
      floatingActionButton: SongSelectionFloatingControls(folderId: folderId),
      // floatingActionButton: CustomExtendedFloatingButton(
      //   text: "Añadir",
      //   icon: Icons.queue_music,
      //   onTap: () => context.pushNamed(
      //     'editor',
      //     extra: SongEditData(folderId: folderId),
      //   ),
      //   color: Colors.white,
      //   backgroundColor: Theme.of(context).primaryColor,
      // ),
      body: SongList(
        selection: true,
        folderId: folderId,
      ),
    );
  }
}

class SongSelectionFloatingControls extends ConsumerWidget {
  final String folderId;

  const SongSelectionFloatingControls({super.key, required this.folderId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Reference> references = ref.watch(Providers.selection.select((referenceIds) {
      List<Reference> references = [];

      for (String referenceId in referenceIds) {
        Reference? reference = ref.watch(DatabaseProviders.references.select((references) => references?[referenceId]));

        if (reference == null || reference.folder.id != folderId) continue;

        references.add(reference);
      }

      return references;
    }));

    if (references.isEmpty) return const SizedBox();

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CustomExtendedFloatingButton(
          text: "Mover a",
          icon: Icons.cut,
          onTap: () {},
          backgroundColor: Theme.of(context).primaryColor,
          color: Colors.white,
        ),
        const Gap(15),
        CustomExtendedFloatingButton(
          text: "Copiar a",
          icon: Icons.copy,
          onTap: () {},
          backgroundColor: Theme.of(context).primaryColor,
          color: Colors.white,
        ),
        const Gap(15),
        CustomExtendedFloatingButton(
          text: "Eliminar",
          icon: Icons.close,
          onTap: () {},
          backgroundColor: Theme.of(context).primaryColor,
          color: Colors.white,
        ),
      ],
    );
  }
}

class BookAppBarTitle extends ConsumerWidget {
  final String bookId;

  const BookAppBarTitle({super.key, required this.bookId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String? title = ref.watch(DatabaseProviders.folders.select((folders) => folders?[bookId]?.title));

    int length = ref.watch(
      DatabaseProviders.references.select((references) => references!.values.where((reference) => reference.folder.id == bookId).length),
    );

    return AppBarTitleWithSubtitle(
      title: title ?? "Sin nombre",
      subtitle: "$length canciones",
    );
  }
}
