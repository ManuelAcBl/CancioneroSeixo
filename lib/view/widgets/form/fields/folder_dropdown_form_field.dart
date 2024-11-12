import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cancionero_seixo/model/providers/database/database_folders_notifier.dart';
import 'package:cancionero_seixo/model/providers/database/database_providers.dart';

class FolderDropdownFormField extends ConsumerWidget {
  final Folder? value;
  final Function(Folder? folder)? onSelect;
  final bool? disabled;

  const FolderDropdownFormField({super.key, this.onSelect, this.value, this.disabled});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Folder> folders = ref.read(DatabaseProviders.folders.notifier).getFolderList()!;

    return DropdownButtonFormField<Folder>(
      validator: (folder) {
        if (folder == null) return "Selecciona una carpeta";

        return null;
      },
      value: value,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: "Carpeta*",
      ),
      items: folders
          .map((Folder folder) => DropdownMenuItem<Folder>(
                value: folder,
                child: Text(folder.title),
              ))
          .toList(),
      onChanged: onSelect,
    );
  }
}
