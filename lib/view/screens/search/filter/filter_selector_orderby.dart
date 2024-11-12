import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cancionero_seixo/model/providers/search/search_filter_notifier.dart';
import 'package:cancionero_seixo/model/providers/search/search_providers.dart';
import 'package:cancionero_seixo/view/widgets/form/selection/segmented_button_selector.dart';

class OrderBySelector extends ConsumerWidget {
  final GlobalKey<SegmentedButtonSelectorState<OrderBy>> selector;

  const OrderBySelector({super.key, required this.selector});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    OrderBy selected = ref.watch(SearchProviders.filter.select((filter) => filter.orderBy));

    return SegmentedButtonSelector(
      key: selector,
      elements: const [
        ButtonSegment<OrderBy>(
          value: OrderBy.number,
          label: Text("Número"),
          icon: Icon(Icons.numbers),
        ),
        ButtonSegment<OrderBy>(
          value: OrderBy.title,
          label: Text("Nombre"),
          icon: Icon(Icons.text_fields),
        ),
        ButtonSegment<OrderBy>(
          value: OrderBy.book,
          label: Text("Libro"),
          icon: Icon(Icons.folder_outlined),
        ),
      ],
      selected: selected,
    );
  }
}
