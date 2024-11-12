import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:cancionero_seixo/model/providers/database/database_folders_notifier.dart';
import 'package:cancionero_seixo/model/providers/database/database_providers.dart';
import 'package:cancionero_seixo/view/widgets/form/custom_form_screen.dart';
import 'package:cancionero_seixo/view/widgets/form/fields/custom_text_form_fiel.dart';
import 'package:cancionero_seixo/view/widgets/text/section_title.dart';

class FolderEditScreen extends ConsumerWidget {
  final Folder? folder;

  const FolderEditScreen({super.key, this.folder});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    DatabaseFoldersNotifier notifier = ref.read(DatabaseProviders.folders.notifier);

    bool creating = folder == null;

    String title = folder?.title ?? "", description = folder?.description ?? "";

    return CustomFormScreen(
      title: creating ? "Nueva Carpeta" : "Editar Carpeta",
      saveText: creating ? "Crear" : "Guardar",
      showHelp: () {},
      onSubmit: () async {
        if (folder == null) {
          await notifier.add(title: title, description: description);

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Carpeta '$title' creada"),
              ),
            );
          }
        } else {
          await notifier.edit(folder!.copyWith(title: title, description: description));

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Carpeta '$title' editada"),
              ),
            );
          }
        }

        if (context.mounted) context.pop();
      },
      children: [
        const SectionTitle(text: "Datos Carpeta"),
        const Gap(15),
        CustomTextFormField(
          label: "Título",
          required: true,
          focus: true,
          capitalization: TextCapitalization.sentences,
          value: folder?.title,
          onEdit: (value) => title = value,
        ),
        const Gap(15),
        CustomTextFormField(
          label: "Descripción",
          required: true,
          capitalization: TextCapitalization.sentences,
          value: folder?.description,
          onEdit: (value) => description = value,
        ),
      ],
    );

    // return Scaffold(
    //   appBar: AppBar(
    //     leading: IconButton(
    //       onPressed: context.pop,
    //       icon: const Icon(Icons.close),
    //     ),
    //     title: const Text("Carpeta"),
    //     actions: [
    //       TextButton(
    //         child: Text(folderId != null ? "Guardar" : "Añadir"),
    //         onPressed: () {
    //           if (folder?.type == FolderType.other) return;
    //
    //           CustomTextFieldState title = titleState.currentState!;
    //           CustomTextFieldState description = descriptionState.currentState!;
    //
    //           if (!title.validate() || !description.validate()) return;
    //
    //           if (folder != null) {
    //             ref.read(DatabaseProviders.folders.notifier).edit(folder.copyWith(title: title.text(), description: description.text()));
    //           }
    //
    //           context.pop();
    //
    //           // Guardar
    //         },
    //       ),
    //       CustomPopupMenuButton(
    //         itemBuilder: (context) => [
    //           PopupMenuItem(
    //             child: const Text("Deshacer cambios"),
    //             onTap: () {
    //               CustomTextFieldState title = titleState.currentState!;
    //               CustomTextFieldState description = descriptionState.currentState!;
    //
    //               title.reset();
    //               description.reset();
    //             },
    //           ),
    //         ],
    //       ),
    //     ],
    //   ),
    //   body: Container(
    //     padding: const EdgeInsets.symmetric(horizontal: 20),
    //     child: SingleChildScrollView(
    //       child: Column(
    //         children: [
    //           const SizedBox(
    //             height: 10,
    //           ),
    //           CustomTextField(
    //             key: titleState,
    //             label: "Título",
    //             type: TextInputType.text,
    //             value: folder?.title,
    //           ),
    //           // CustomTextField(
    //           //   label: 'Título',
    //           //   controller: titleCtrl,
    //           // ),
    //           const SizedBox(
    //             height: 30,
    //           ),
    //           CustomTextField(
    //             key: descriptionState,
    //             label: "Descripción",
    //             type: TextInputType.text,
    //             value: folder?.description,
    //           ),
    //           // CustomTextField(
    //           //   label: 'Descripción',
    //           //   controller: descriptionCtrl,
    //           // ),
    //           // TextField(
    //           //   maxLines: null,
    //           //   keyboardType: TextInputType.multiline,
    //           //   decoration: InputDecoration(
    //           //       border: const OutlineInputBorder(),
    //           //       labelText: 'Descripción',
    //           //       suffixIcon: IconButton(
    //           //           onPressed: () => {},
    //           //           icon: Icon(
    //           //             Icons.help_outline,
    //           //             color: Theme.of(context).primaryColor,
    //           //           ))),
    //           //   controller: descriptionCtrl,
    //           // ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}
