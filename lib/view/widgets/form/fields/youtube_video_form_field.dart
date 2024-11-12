import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';

class YouTubeVideoFormField extends StatelessWidget {
  final Function(String? youtubeId)? onEdit;

  const YouTubeVideoFormField({super.key, this.onEdit});

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      validator: (data) {
        if (data == null || data.isEmpty) return "Este campo no puede estar vacío";

        // ID de YouTube
        bool match = RegExp(r'^[a-zA-Z0-9_-]{11}$').hasMatch(data);

        if (match) return null;

        // URL de YouTube
        match =
            RegExp(r'^(https?:\/\/)?(www\.)?(youtube\.com\/(watch\?v=|embed\/|v\/)|youtu\.be\/)([a-zA-Z0-9_-]{11})(\?.*)?$').hasMatch(data);

        if (match) return null;

        return "Formato incorrecto";
      },
      builder: (state) => TextField(
        keyboardType: TextInputType.text,
        onChanged: (value) {
          state.didChange(value);

          String? youtubeId = RegExp(r'[a-zA-Z0-9_-]{11}').stringMatch(value);

          onEdit?.call(youtubeId);
        },
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          errorText: state.errorText,
          labelText: "YouTube URL/ID",
          suffixIcon: const Icon(BootstrapIcons.youtube),
        ),
      ),
    );
  }
}
