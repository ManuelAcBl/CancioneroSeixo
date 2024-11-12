import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PresentationSettingsNotifier extends Notifier<PresentationSettings> {
  final PresentationSettings _default = PresentationSettings(
    previewAspectRatio: 4 / 3,
    background: "",
    content: ContentSettings(
      verse: ContentElementSettings(
        visibility: true,
        font: FontSettings(
          color: Colors.white,
          family: "",
        ),
      ),
      title: ContentElementSettings(
        visibility: true,
        font: FontSettings(
          color: Colors.deepOrangeAccent,
          family: "",
        ),
      ),
      authors: ContentElementSettings(
        visibility: true,
        font: FontSettings(
          color: Colors.white,
          family: "",
        ),
      ),
    ),
  );

  @override
  PresentationSettings build() => _default;

  void reset() => state = _default;

  void update({double? previewAspectRatio, String? background, ContentSettings? content}) => state = PresentationSettings(
        previewAspectRatio: previewAspectRatio ?? state.previewAspectRatio,
        background: background ?? state.background,
        content: content ?? state.content,
      );
}

class PresentationSettings {
  final double previewAspectRatio;
  final String background;
  final ContentSettings content;

  PresentationSettings({required this.previewAspectRatio, required this.background, required this.content});
}

class ContentSettings {
  final ContentElementSettings verse, title, authors;

  ContentSettings({required this.verse, required this.title, required this.authors});
}

class ContentElementSettings {
  final bool visibility;
  final FontSettings font;

  ContentElementSettings({required this.visibility, required this.font});
}

class FontSettings {
  final Color color;
  final String family;

  FontSettings({required this.color, required this.family});
}
