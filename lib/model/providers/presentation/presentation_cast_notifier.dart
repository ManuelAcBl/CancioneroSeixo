import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cancionero_seixo/controller/presentation/presenation_server.dart';
import 'package:cancionero_seixo/model/providers/presentation/presentation_providers.dart';
import 'package:cancionero_seixo/model/providers/presentation/presentation_slides_notifier.dart';

class PresentationCastNotifier extends Notifier<CastData> {
  static final CastDecoration decoration = CastDecoration(
    color: Colors.black,
    background: 'assets/images/presentation_wallpaper.jpg',
  );

  PresentationServer server = PresentationServer()..start((id) {}, (id) {});

  @override
  CastData build() {
    bool visibility = ref.watch(PresentationProviders.controls.select((controls) => controls.visibility));

    if (!visibility) return CastData(decoration: decoration);

    int? index = ref.watch(PresentationProviders.index);
    Iterable<PresentationElement>? slides = ref.watch(PresentationProviders.slides.select((presentation) => presentation?.getSlides()));

    if (index == null || slides == null) return CastData(decoration: decoration);

    PresentationElement element = slides.elementAt(index);

    VerseSlide? slide = element.runtimeType == VerseSlide ? element as VerseSlide : null;

    return CastData(
      decoration: decoration,
      slide: slide,
    );
  }

  @override
  bool updateShouldNotify(CastData previous, CastData next) {
    server.broadcastSlideData(next);

    return super.updateShouldNotify(previous, next);
  }
}

class CastData {
  final CastDecoration? decoration;
  final VerseSlide? slide;

  CastData({this.decoration, this.slide});

  factory CastData.fromJson(Map<String, dynamic> json) => CastData(
        decoration: json['decoration'] != null ? CastDecoration.fromJson(json['decoration']) : null,
        slide: json['slide'] != null ? VerseSlide.fromJson(json['slide']) : null,
      );

  Map<String, dynamic> toJson() => {
        'decoration': decoration?.toJson(),
        'slide': slide?.toJson(),
      };
}

// class SlideData {
//   final VerseType type;
//   final String text, title;
//   final String? authors;
//
//   SlideData({required this.type, required this.text, required this.title, required this.authors});
//
//   factory SlideData.fromJson(Map<String, dynamic> json) => SlideData(
//     type: VerseType.values.byName(json['type']),
//     text: json['text'],
//     title: json['title'],
//     authors: json['authors'],
//   );
//
//   Map<String, dynamic> toJson() => {
//     'type': type.name,
//     'text': text,
//     'title': title,
//     'authors': authors,
//   };
// }

class CastDecoration {
  final Color? color;
  final String? background;

  CastDecoration({required this.color, required this.background});

  factory CastDecoration.fromJson(Map<String, dynamic> json) => CastDecoration(
        color: json['color'] != null ? Color(int.parse(json['color'])) : null,
        background: json['background'],
      );

  Map<String, dynamic> toJson() => {
        'color': color?.value.toString(),
        'background': background,
      };
}
