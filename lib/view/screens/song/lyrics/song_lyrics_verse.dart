import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cancionero_seixo/model/providers/settings/settings_providers.dart';

class SongLyricsVerse extends ConsumerWidget {
  final bool isChorus;
  final String text;
  final String? name;

  const SongLyricsVerse({super.key, this.name, required this.text, required this.isChorus});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double fontSize = ref.watch(SettingsProviders.personalization.select((personalization) => personalization.fontSize));

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isChorus
              ? Text(
                  name!,
                  style: TextStyle(
                    fontSize: fontSize,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                    height: 1.2,
                  ),
                )
              : const SizedBox(),
          Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              height: 1.2,
              fontStyle: isChorus ? FontStyle.italic : null,
            ),
          )
        ],
      ),
    );
  }
}
