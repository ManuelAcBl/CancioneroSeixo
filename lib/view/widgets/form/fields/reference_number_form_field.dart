import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cancionero_seixo/model/providers/database/database_folders_notifier.dart';
import 'package:cancionero_seixo/model/providers/database/database_providers.dart';
import 'package:cancionero_seixo/model/providers/database/database_references_notifier.dart';

class ReferenceNumberFormField extends ConsumerWidget {
  final Folder folder;
  final String? value, reservedValue;
  final Function(String number)? onEdit;
  late final TextEditingController controller;
  final bool? focus;

  ReferenceNumberFormField({super.key, required this.folder, this.value, this.onEdit, this.reservedValue, this.focus}) {
    controller = TextEditingController(text: value);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Iterable<Reference>? references = ref.read(DatabaseProviders.references)?.values.where((reference) => reference.folder == folder);
    Iterable<String?>? numbers = references?.map((reference) => reference.data.number);

    GlobalKey<FormFieldState> formKey = GlobalKey<FormFieldState>();

    bool first = true;
    return FormField<String>(
      key: formKey,
      validator: (value) {
        print("Validation");
        if (numbers != null && value != reservedValue && numbers.contains(value)) return "Ya hay una canción con este número";

        return null;
      },
      initialValue: value,
      builder: (state) {
        TextStyle errorStyle = TextStyle(color: state.hasError ? Colors.amber : null);
        OutlineInputBorder errorBorder = const OutlineInputBorder(borderSide: BorderSide(color: Colors.amber));

        if (first) {
          Future(() => state.validate());
          first = false;
        }

        print("VALUE: ${controller.value}");

        return TextField(
          controller: controller,
          keyboardType: TextInputType.text,
          autofocus: focus == true,
          decoration: InputDecoration(
            errorBorder: errorBorder,
            border: const OutlineInputBorder(),
            focusedErrorBorder: errorBorder.copyWith(borderSide: errorBorder.borderSide.copyWith(width: 2)),
            labelText: "Número*",
            labelStyle: errorStyle,
            errorStyle: errorStyle,
            errorText: state.errorText,
            suffixText: folder.title,
            suffixIcon: const Icon(Icons.folder),
            suffixIconColor: Theme.of(context).iconTheme.color,
          ),
          onChanged: (value) {
            state.didChange(value);
            onEdit?.call(value);
            formKey.currentState!.validate();
          },
        );
      },
    );
  }
}