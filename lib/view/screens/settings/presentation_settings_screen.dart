import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cancionero_seixo/model/providers/settings/settings_providers.dart';
import 'package:cancionero_seixo/view/screens/settings/settings_section_scaffold.dart';
import 'package:cancionero_seixo/view/widgets/form/selection/bottom_sheet_selector.dart';

class PresentationSettingsScreen extends ConsumerWidget {
  const PresentationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SettingsSectionScaffold(
      title: "Presentación",
      onReset: ref.read(SettingsProviders.presentation.notifier).reset,
      children: const [
        PreviewAspectRatioSetting(),
        PresentationWallpaperSetting(),
      ],
    );
  }
}

class PresentationWallpaperSetting extends ConsumerWidget {
  const PresentationWallpaperSetting({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BottomSheetSelectorSetting(
      title: "Fondo de la Presentación",
      selectorTitle: "Seleciona un Fondo:",
      options: const [
        BottomSheetSelectorOption(
          value: "assets/images/presentation_wallpaper.jpg",
          name: "Por Defecto",
          icon: Icons.wallpaper,
        ),
        BottomSheetSelectorOption(
          value: "",
          name: "Escoger de la Galería",
          icon: Icons.photo,
        ),
        BottomSheetSelectorOption(
          value: "",
          name: "Color Sólido",
          icon: Icons.color_lens,
        ),
      ],
      value: "assets/images/presentation_wallpaper.jpg",
      icon: Icons.wallpaper,
      onSelect: (value) => ref.read(SettingsProviders.presentation.notifier).update(background: value),
    );
  }
}

class PreviewAspectRatioSetting extends ConsumerWidget {
  const PreviewAspectRatioSetting({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BottomSheetSelectorSetting(
      title: "Formato de Previsualización",
      selectorTitle: "Seleciona una Relación de Aspecto:",
      options: const [
        BottomSheetSelectorOption(
          value: 16 / 9,
          name: "16/9",
          icon: Icons.aspect_ratio,
        ),
        BottomSheetSelectorOption(
          value: 4 / 3,
          name: "4/3",
          icon: Icons.aspect_ratio,
        ),
      ],
      value: 4 / 3,
      icon: Icons.aspect_ratio,
      onSelect: (value) => ref.read(SettingsProviders.presentation.notifier).update(previewAspectRatio: value),
    );
  }
}
