import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:cancionero_seixo/model/providers/settings/personalization_settings_notifier.dart';
import 'package:cancionero_seixo/model/providers/settings/settings_providers.dart';
import 'package:cancionero_seixo/view/screens/settings/settings_section_scaffold.dart';
import 'package:cancionero_seixo/view/widgets/bottom_sheet_menu.dart';
import 'package:cancionero_seixo/view/widgets/form/selection/bottom_sheet_selector.dart';

class PersonalizationSettingsScreen extends ConsumerWidget {
  const PersonalizationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SettingsSectionScaffold(
      title: "Personalización",
      onReset: ref.read(SettingsProviders.personalization.notifier).reset,
      children: const [
        ThemeModeSelectorSetting(),
        FontSizeSelectorSetting(),
      ],
    );
  }
}

class ThemeModeSelectorSetting extends ConsumerWidget {
  const ThemeModeSelectorSetting({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ThemeMode themeMode = ref.watch(SettingsProviders.personalization.select((personalization) => personalization.themeMode));

    return BottomSheetSelectorSetting(
      title: "Tema",
      selectorTitle: "Selecciona un tema:",
      options: const [
        BottomSheetSelectorOption(
          value: ThemeMode.dark,
          name: "Tema Oscuro",
          icon: Icons.dark_mode,
        ),
        BottomSheetSelectorOption(
          value: ThemeMode.light,
          name: "Tema Claro",
          icon: Icons.light_mode,
        ),
        BottomSheetSelectorOption(
          value: ThemeMode.system,
          name: "Tema del Sistema",
          icon: Icons.phone_android,
        ),
      ],
      value: themeMode,
      icon: Icons.light_mode,
      onSelect: (themeMode) => ref.read(SettingsProviders.personalization.notifier).update(themeMode: themeMode),
    );
  }
}

class FontSizeSelectorSetting extends ConsumerWidget {
  const FontSizeSelectorSetting({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double fontSize = ref.watch(SettingsProviders.personalization.select((personalization) => personalization.fontSize));

    return SettingsSectionElement(
      title: "Tamaño de Letra de Canción",
      subtitle: "${fontSize.truncate()} px",
      icon: Icons.format_size,
      onTap: () async {
        double? value = await showModalBottomSheet(
          context: context,
          builder: (context) {
            return BottomSheetMenu(
              title: "Selecciona un Tamaño:",
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: FontSizeSelectorSlider(
                  fontSize: fontSize,
                ),
              ),
            );
          },
        );

        if (value == null) return;

        ref.read(SettingsProviders.personalization.notifier).update(fontSize: value);
      },
    );
  }
}

class FontSizeSelectorSlider extends StatefulWidget {
  final double fontSize;

  const FontSizeSelectorSlider({super.key, required this.fontSize});

  @override
  State<FontSizeSelectorSlider> createState() => _FontSizeSelectorSliderState();
}

class _FontSizeSelectorSliderState extends State<FontSizeSelectorSlider> {
  late double fontSize;

  @override
  void initState() {
    super.initState();

    fontSize = widget.fontSize;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(

          decoration: BoxDecoration(
            color: Theme.of(context).highlightColor,
            borderRadius: BorderRadius.circular(10),
          ),
          height: 200,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Cristiano, alaba a tu Señor,\n"
              "Proclama sus bondades;\n"
              "Anuncia a todos su amor,\n"
              "Su gracia y sus verdades.",
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: fontSize,
              ),
            ),
          ),
        ),
        const Gap(10),
        Slider(
          min: PersonalizationSettings.minFontSize,
          max: PersonalizationSettings.maxFontSize,
          value: fontSize,
          label: "${fontSize.truncate()} px",
          divisions: (PersonalizationSettings.maxFontSize - PersonalizationSettings.minFontSize).truncate(),
          onChanged: (value) => setState(() => fontSize = value),
        ),
        const Gap(10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () => context.pop(fontSize),
              child: const Text("Aceptar"),
            ),
          ],
        )
      ],
    );
  }
}
