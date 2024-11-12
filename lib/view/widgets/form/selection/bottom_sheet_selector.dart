import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cancionero_seixo/view/widgets/bottom_sheet_menu.dart';

class BottomSheetSelector<T> extends StatelessWidget {
  final String title;
  final List<BottomSheetSelectorOption<T>> elements;

  const BottomSheetSelector({super.key, required this.title, required this.elements});

  @override
  Widget build(BuildContext context) {
    return BottomSheetMenu(
      title: title,
      child: Column(
        children: elements,
      ),
    );
  }
}

class BottomSheetSelectorBuilder<T> extends StatelessWidget {
  final String title;
  final Iterable<T> elements;
  final BottomSheetSelectorOption<T> Function(T value) builder;

  const BottomSheetSelectorBuilder({super.key, required this.title, required this.elements, required this.builder});

  @override
  Widget build(BuildContext context) {
    return BottomSheetSelector(
      title: title,
      elements: elements.map((element) => builder(element)).toList(),
    );
  }
}

class BottomSheetSelectorOption<T> extends StatelessWidget {
  final T value;
  final String name;
  final IconData icon;

  const BottomSheetSelectorOption({super.key, required this.value, required this.name, required this.icon});

  @override
  Widget build(BuildContext context) {
    return BottomSheetElement(
      name: name,
      icon: icon,
      onTap: () => context.pop(value),
    );
  }
}
