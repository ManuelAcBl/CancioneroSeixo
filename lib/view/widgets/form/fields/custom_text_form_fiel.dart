import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String label;
  final String? value;
  final bool? required, focus;
  final TextCapitalization? capitalization;
  final Function(String value)? onEdit;
  final IconData? icon;
  late final TextEditingController controller;

  CustomTextFormField(
      {super.key, required this.label, this.value, this.onEdit, this.required, this.capitalization, this.focus, this.icon}) {
    controller = TextEditingController(text: value);
  }

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      validator: (data) {
        if (required == true && (data == null || data.isEmpty)) return "Este campo no puede estar vacío";

        return null;
      },
      initialValue: value,
      builder: (state) => TextField(
        autofocus: focus ?? false,
        controller: controller,
        keyboardType: TextInputType.text,
        textCapitalization: capitalization ?? TextCapitalization.none,
        onChanged: (value) {
          state.didChange(value);
          onEdit?.call(value);
        },
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          errorText: state.errorText,
          labelText: "$label${required == true ? "*" : ""}",
          suffixIcon: Icon(icon),
        ),
      ),
    );
  }
}