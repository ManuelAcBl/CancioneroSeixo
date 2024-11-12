import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cancionero_seixo/model/providers/settings/personalization_settings_notifier.dart';
import 'package:cancionero_seixo/model/providers/settings/presentation_settings_notifier.dart';

abstract class SettingsProviders {
  static final presentation = NotifierProvider<PresentationSettingsNotifier, PresentationSettings>(PresentationSettingsNotifier.new);
  static final personalization =
      NotifierProvider<PersonalizationSettingsNotifier, PersonalizationSettings>(PersonalizationSettingsNotifier.new);
}
