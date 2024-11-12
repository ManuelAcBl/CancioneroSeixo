import 'package:flutter/material.dart';

class SongLyricsFormField extends StatelessWidget {
  final String? value;
  final Function(String value)? onEdit;
  late final TextEditingController controller;

  SongLyricsFormField({super.key, this.value, this.onEdit}) {
    controller = TextEditingController(text: value);
  }

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      validator: (data) {
        if (data == null || data.isEmpty) return "Este campo no puede estar vacío";

        return null;
      },
      initialValue: value,
      builder: (state) => TextField(
        maxLines: null,
        controller: controller,
        keyboardType: TextInputType.multiline,
        textCapitalization: TextCapitalization.sentences,
        onChanged: (value) {
          state.didChange(value);
          onEdit?.call(value);
        },
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          errorText: state.errorText,
          labelText: "Letra*",
        ),
      ),
    );
  }
}