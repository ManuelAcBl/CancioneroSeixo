import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cancionero_seixo/model/providers/database/database_songs_notifier.dart';
import 'package:cancionero_seixo/model/providers/presentation/presentation_slides_notifier.dart';
import 'package:cancionero_seixo/view/screens/presentation/slide_list/slides/presentation_slide.dart';

class PresentationVerseSlide extends ConsumerWidget {
  final VerseSlide slide;

  const PresentationVerseSlide({super.key, required this.slide});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    VerseData verse = slide.verse;

    return PresentationSlide(
        color: Theme.of(context).primaryColor.withAlpha(10),
        index: slide.index,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              verse.name,
              style: const TextStyle(color: Colors.grey),
            ),
            Container(
              margin: const EdgeInsets.only(left: 5),
              child: Text(
                verse.text,
                style: TextStyle(
                  height: 1.3,
                  fontStyle: verse.type != VerseType.verse ? FontStyle.italic : null,
                ),
              ),
            )
          ],
        ));
  }
}
