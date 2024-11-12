import 'package:flutter/material.dart';
import 'package:cancionero_seixo/model/providers/database/database_songs_notifier.dart';
import 'package:cancionero_seixo/view/screens/presentation/cast/cast_text.dart';

class CastVerse extends StatelessWidget {
  final VerseData data;

  const CastVerse({super.key, required this.data});

  @override
  Widget build(BuildContext context) => FittedBox(
    child: Center(
      child: CastText(
        strokeWidth: 2,
        text: Text(
          data.text,
          style: TextStyle(
            color: Colors.white,
            height: 1.2,
            fontStyle: data.type != VerseType.verse ? FontStyle.italic : null,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    ),
  );
}