import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cancionero_seixo/model/providers/database/database_folders_notifier.dart';
import 'package:cancionero_seixo/model/providers/database/database_providers.dart';
import 'package:cancionero_seixo/view/widgets/text/section_title.dart';

class FolderInfoBottomSheet extends ConsumerWidget {
  final String folderId;

  const FolderInfoBottomSheet({super.key, required this.folderId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Folder folder = ref.watch(DatabaseProviders.folders.select((folders) => folders![folderId]!));

    return BottomSheet(
      onClosing: () => {},
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SectionTitle(text: "Información:"),
                  Text(
                    folder.title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                  Text(
                    folder.description,
                    style: const TextStyle(fontSize: 17),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
