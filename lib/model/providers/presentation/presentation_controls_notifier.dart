import 'package:flutter_riverpod/flutter_riverpod.dart';

class PresentationControlsNotifier extends Notifier<Controls> {
  static final Controls _default = Controls(preview: true, visibility: true);

  @override
  Controls build() => _default;

  void preview(bool visible) => state = state.cloneWith(preview: visible);

  void visibility(bool visible) => state = state.cloneWith(visibility: visible);
}

class Controls {
  final bool preview, visibility;

  Controls({required this.preview, required this.visibility});

  Controls cloneWith({bool? preview, bool? visibility}) => Controls(
        preview: preview ?? this.preview,
        visibility: visibility ?? this.visibility,
      );
}
