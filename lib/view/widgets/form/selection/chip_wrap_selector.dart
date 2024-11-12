import 'package:flutter/material.dart';

class ChipWrapSelector<T> extends StatefulWidget {
  final Map<T, String> elements;
  final List<T> selected;
  final String allText;

  const ChipWrapSelector({super.key, required this.elements, required this.selected, required this.allText});

  @override
  State<ChipWrapSelector> createState() => ChipWrapSelectorState<T>();
}

class ChipWrapSelectorState<T> extends State<ChipWrapSelector> {
  late List<T> _selected;

  @override
  void initState() {
    super.initState();

    _selected = [...widget.selected];
  }

  @override
  Widget build(BuildContext context) {
    bool allSelected = _selected.length == widget.elements.length;

    return Wrap(
      spacing: 5,
      children: [
        FilterChip.elevated(
          label: Text(widget.allText),
          selected: allSelected,
          onSelected: (selected) {
            setState(
              () {
                if (selected) {
                  _selected = [...widget.elements.keys];
                } else {
                  _selected = [];
                }
              },
            );
          },
        ),
        ...widget.elements.keys.map((key) {
          String value = widget.elements[key]!;

          return FilterChip.elevated(
            label: Text(value),
            selected: _selected.contains(key),
            onSelected: (selected) {
              setState(
                () {
                  if (selected) {
                    _selected.add(key);
                  } else {
                    _selected.remove(key);
                  }
                },
              );
            },
          );
        }),
      ],
    );
  }

  List<T> selection() => _selected;
}
