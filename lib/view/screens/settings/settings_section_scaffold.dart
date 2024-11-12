import 'package:flutter/material.dart';
import 'package:cancionero_seixo/view/widgets/form/selection/bottom_sheet_selector.dart';

class SettingsSectionScaffold extends StatelessWidget {
  final String title;
  final VoidCallback onReset;
  final List<Widget> children;

  const SettingsSectionScaffold({super.key, required this.title, required this.onReset, required this.children});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          PopupMenuButton(
            offset: const Offset(0, 60),
            itemBuilder: (context) => [
              PopupMenuItem(
                onTap: onReset,
                child: const Text("Restaurar"),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: children,
      ),
    );
  }
}

class SettingsSectionElement extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const SettingsSectionElement({super.key, required this.title, required this.subtitle, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      leading: Icon(icon),
      onTap: onTap,
    );
  }
}

class BottomSheetSelectorSetting<T> extends StatelessWidget {
  final String title, selectorTitle;
  final IconData icon;
  final List<BottomSheetSelectorOption<T>> options;
  final T value;
  final Function(T value) onSelect;

  const BottomSheetSelectorSetting({
    super.key,
    required this.title,
    required this.selectorTitle,
    required this.options,
    required this.value,
    required this.icon,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    String subtitle = options.firstWhere((option) => option.value == value).name;

    return SettingsSectionElement(
      title: title,
      subtitle: subtitle,
      icon: icon,
      onTap: () async {
        T? value = await showModalBottomSheet(
          context: context,
          builder: (context) => BottomSheetSelector(
            title: selectorTitle,
            elements: options,
          ),
        );

        if (value == null) return;

        onSelect(value);
      },
    );
  }
}
