import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cancionero_seixo/model/providers/database/database_folders_notifier.dart';
import 'package:cancionero_seixo/model/providers/database/database_providers.dart';
import 'package:cancionero_seixo/view/widgets/form/selection/bottom_sheet_selector.dart';

class FolderBottomSheetSelector extends ConsumerWidget {
  const FolderBottomSheetSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Map<String, Folder> folders = ref.read(DatabaseProviders.folders)!;

    return BottomSheetSelectorBuilder<Folder>(
      title: "Selecciona una carpeta:",
      elements: folders.values,
      builder: (folder) => BottomSheetSelectorOption(
        value: folder,
        name: folder.title,
        icon: Icons.folder,
      ),
    );
  }
}
