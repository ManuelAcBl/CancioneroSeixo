import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cancionero_seixo/controller/utils/local_save/local_save.dart';
import 'package:cancionero_seixo/model/providers/presentation/presentation_providers.dart';
import 'package:cancionero_seixo/model/providers/presentation/presentation_slides_notifier.dart';

class PresentationIndexNotifier extends Notifier<int?> {
  final LocalSave saver = LocalSave(name: "presentation_index");

  int? _max, previous;

  @override
  int? build() {
    Future(() async => state = await saver.load());

    int? length = ref.watch(PresentationProviders.slides.select((slides) => slides?.getSlides().length));

    if (length == null || length == 0) return null;

    _max = length - 1;

    return clamp(previous ?? 0);
  }

  @override
  bool updateShouldNotify(int? previous, int? next) {
    this.previous = next;

    saver.save(state);

    return super.updateShouldNotify(previous, next);
  }

  bool set(int index) {
    if (state == null) return false;

    int previous = state!;

    int next = clamp(index);

    if (previous == next) return false;

    state = next;
    return true;
  }

  bool up() {
    if (state == null) return false;

    return set(state! - 1);
  }

  bool down() {
    if (state == null) return false;

    return set(state! + 1);
  }

  void setToSong(String referenceId) {
    Iterable<Slide>? slides = ref.watch(PresentationProviders.slides.select((slides) => slides?.getSlides()));

    if (slides == null) return;

    for (int index = 0; index < slides.length; index++) {
      Slide slide = slides.elementAt(index);

      if (slide.runtimeType == VerseSlide) {
        if ((slide as VerseSlide).song.referenceId == referenceId) {
          set(index);
          return;
        }
      }
    }
  }

  int clamp(int index) {
    final int max = _max ?? 0;
    const int min = 0;

    if (index < min) return min;

    if (index > max) return max;

    return index;
  }
}
