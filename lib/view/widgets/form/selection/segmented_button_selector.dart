import 'package:flutter/material.dart';

class SegmentedButtonSelector<T> extends StatefulWidget {
  final List<ButtonSegment<T>> elements;
  final T selected;

  const SegmentedButtonSelector({super.key, required this.elements, required this.selected});

  @override
  State<SegmentedButtonSelector> createState() => SegmentedButtonSelectorState<T>();
}

class SegmentedButtonSelectorState<T> extends State<SegmentedButtonSelector> {
  late T _selected;

  @override
  void initState() {
    super.initState();

    _selected = widget.selected;
  }

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<T>(
      style: const ButtonStyle(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity(
          horizontal: -1,
          vertical: -1,
        ),
      ),
      onSelectionChanged: (selected) => setState(() => _selected = selected.first),
      segments: (widget.elements as List<ButtonSegment<T>>),
      selected: <T>{
        _selected,
      },
    );
  }

  T selected() => _selected;
}
