import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:cancionero_seixo/model/providers/database/database_folders_notifier.dart';
import 'package:cancionero_seixo/model/providers/database/database_references_notifier.dart';
import 'package:cancionero_seixo/view/widgets/form/custom_form_screen.dart';
import 'package:cancionero_seixo/view/widgets/form/fields/folder_dropdown_form_field.dart';
import 'package:cancionero_seixo/view/widgets/form/fields/reference_number_form_field.dart';

class AddSongToScreen extends StatelessWidget {
  final Reference reference;

  const AddSongToScreen({super.key, required this.reference});

  @override
  Widget build(BuildContext context) {
    Folder? folder;
    String number = "";

    return CustomFormScreen(
      title: "Añadir a",
      saveText: "Añadir",
      showHelp: () {},
      onSubmit: () {
        print("$number ${folder?.title}");
      },
      children: [
        FolderDropdownFormField(
          onSelect: (value) => folder = value,
        ),
        const Gap(15),
        ReferenceNumberFormField(
          folder: folder!,
          onEdit: (value) => number = value,
        ),
      ],
    );
  }
}
