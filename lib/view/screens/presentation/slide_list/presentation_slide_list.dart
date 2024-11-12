import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cancionero_seixo/model/providers/presentation/presentation_providers.dart';
import 'package:cancionero_seixo/model/providers/presentation/presentation_slides_notifier.dart';
import 'package:cancionero_seixo/view/screens/presentation/slide_list/slides/presentation_space_slide.dart';
import 'package:cancionero_seixo/view/screens/presentation/slide_list/slides/presentation_title_slide.dart';
import 'package:cancionero_seixo/view/screens/presentation/slide_list/slides/presentation_verse_slide.dart';
import 'package:cancionero_seixo/view/widgets/text/info_message.dart';

class PresentationSlideList extends ConsumerWidget {
  const PresentationSlideList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<PresentationElement>? elements = ref.watch(PresentationProviders.slides.select((elements) => elements?.elements));

    if (elements == null || elements.isEmpty) {
      //return const InfoText(text: "La presentación está vacía.\nBusca y añade canciones con el botón '+'");
      return const InfoMessage(
        title: "Presentación vacía",
        text: "Añade canciones para comenzar",
      );
    }

    List<Widget> list = [];

    for (PresentationElement element in elements) {
      Type type = element.runtimeType;

      list.add(
        switch (type) {
          const (SpaceSlide) => PresentationSpaceSlide(spaceSlide: element as SpaceSlide),
          const (VerseSlide) => PresentationVerseSlide(slide: element as VerseSlide),
          const (SongTitle) => PresentationSongTitle(songTitle: element as SongTitle),
          _ => const Text("Error")
        },
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: list,
        ),
      ),
    );
  }
}
