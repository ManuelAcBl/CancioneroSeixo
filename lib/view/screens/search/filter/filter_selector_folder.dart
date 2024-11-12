import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cancionero_seixo/model/providers/database/database_folders_notifier.dart';
import 'package:cancionero_seixo/model/providers/database/database_providers.dart';
import 'package:cancionero_seixo/model/providers/search/search_providers.dart';
import 'package:cancionero_seixo/view/widgets/form/selection/chip_wrap_selector.dart';

class SearchInSelector extends ConsumerWidget {
  final GlobalKey<ChipWrapSelectorState<String>> selectorKey;

  const SearchInSelector({super.key, required this.selectorKey});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Folder> folders = ref.watch(DatabaseProviders.folders.select((folders) => folders!.values.toList()));
    List<String> selected = ref.watch(SearchProviders.filter.select((filter) => filter.searchIn));

    return ChipWrapSelector(
      key: selectorKey,
      elements: Map.fromEntries(folders.map((folder) => MapEntry(folder.id, folder.title))),
      selected: selected,
      allText: "Todas",
    );
  }
}
