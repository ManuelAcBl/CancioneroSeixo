import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cancionero_seixo/model/providers/search/search_filter_notifier.dart';
import 'package:cancionero_seixo/model/providers/search/search_providers.dart';
import 'package:cancionero_seixo/view/widgets/form/selection/chip_wrap_selector.dart';

class SearchForSelector extends ConsumerWidget {
  final GlobalKey<ChipWrapSelectorState<SearchFor>> selectorKey;

  const SearchForSelector({super.key, required this.selectorKey});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SearchFilter filter = ref.watch(SearchProviders.filter);

    return ChipWrapSelector(
      key: selectorKey,
      allText: "Todos",
      elements: const {
        SearchFor.number: "Número",
        SearchFor.title: "Título",
        SearchFor.lyrics: "Letra",
        SearchFor.author: "Autor",
      },
      selected: filter.searchFor,
    );
  }
}
