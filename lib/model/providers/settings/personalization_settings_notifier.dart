import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PersonalizationSettingsNotifier extends Notifier<PersonalizationSettings> {
  final PersonalizationSettings _default = PersonalizationSettings(themeMode: ThemeMode.system, fontSize: 18);

  @override
  PersonalizationSettings build() => _default;

  void reset() => state = _default;

  void update({ThemeMode? themeMode, double? fontSize}) => state = PersonalizationSettings(
        themeMode: themeMode ?? state.themeMode,
        fontSize: fontSize ?? state.fontSize,
      );
}

class PersonalizationSettings {
  static const double minFontSize = 16, maxFontSize = 25;

  final ThemeMode themeMode;
  final double fontSize;

  PersonalizationSettings({required this.themeMode, required this.fontSize});
}
