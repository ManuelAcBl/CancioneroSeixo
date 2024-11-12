import 'package:flutter/material.dart';

class SongOrderFormField extends StatelessWidget {
  final String? value;
  final Function(String value)? onEdit;
  final String? Function()? getLyrics;
  late final TextEditingController controller;

  SongOrderFormField({super.key, this.value, this.onEdit, this.getLyrics}) {
    controller = TextEditingController(text: value);
  }

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      validator: (data) {
        if (data == null || data.isEmpty) return null;

        String? lyrics = getLyrics?.call();
        RegExp regExp = RegExp(r'[VPCB]\d*');

        List<String> elements = data.split(" ");

        for (String element in elements) {
          RegExpMatch? match = regExp.firstMatch(element);

          if (match == null) return "El elemento '$element' es inválido";

          if (lyrics?.contains("[$element]") == false) return "La estrofa '$element' no existe";
        }

        if (lyrics != null) {
          regExp = RegExp(r'\[([VPCB]\d*)\]');

          Iterable<RegExpMatch> matches = regExp.allMatches(lyrics);

          for (RegExpMatch match in matches) {
            String? value = match.group(1);
            if (!elements.contains(value)) return "La estrofa '$value' no aparece";
          }
        }

        return null;
      },
      initialValue: value,
      builder: (state) => TextField(
        controller: controller,
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.characters,
        onChanged: (value) {
          state.didChange(value);
          onEdit?.call(value);
        },
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          errorText: state.errorText,
          labelText: "Orden",
          suffixIcon: const Icon(Icons.sort),
        ),
      ),
    );
  }
}