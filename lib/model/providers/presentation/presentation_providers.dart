import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cancionero_seixo/model/providers/database/database_providers.dart';
import 'package:cancionero_seixo/model/providers/presentation/presentation_cast_notifier.dart';
import 'package:cancionero_seixo/model/providers/presentation/presentation_controls_notifier.dart';
import 'package:cancionero_seixo/model/providers/presentation/presentation_index_notifier.dart';
import 'package:cancionero_seixo/model/providers/presentation/presentation_slides_notifier.dart';
import 'package:cancionero_seixo/model/providers/presentation/presentation_songs_notifier.dart';

abstract class PresentationProviders {
  static final songs = NotifierProvider<PresentationSongsNotifier, List<String>?>(PresentationSongsNotifier.new);
  static final slides = NotifierProvider<PresentationDataNotifier, PresentationData?>(PresentationDataNotifier.new);
  static final index = NotifierProvider<PresentationIndexNotifier, int?>(PresentationIndexNotifier.new);
  static final cast = NotifierProvider<PresentationCastNotifier, CastData>(PresentationCastNotifier.new);
  static final controls = NotifierProvider<PresentationControlsNotifier, Controls>(PresentationControlsNotifier.new);
}
