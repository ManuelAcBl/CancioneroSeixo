import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:cancionero_seixo/model/providers/search/search_filter_notifier.dart';
import 'package:cancionero_seixo/model/providers/search/search_metrics_notifier.dart';
import 'package:cancionero_seixo/model/providers/search/search_providers.dart';
import 'package:cancionero_seixo/view/screens/search/filter/filter_selector_folder.dart';
import 'package:cancionero_seixo/view/screens/search/filter/filter_selector_orderby.dart';
import 'package:cancionero_seixo/view/screens/search/filter/filter_selector_searchfor.dart';
import 'package:cancionero_seixo/view/widgets/form/selection/chip_wrap_selector.dart';
import 'package:cancionero_seixo/view/widgets/form/selection/segmented_button_selector.dart';
import 'package:cancionero_seixo/view/widgets/text/section_title.dart';

class SearchFilterScreen extends ConsumerWidget {
  const SearchFilterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(SearchProviders.filter);

    GlobalKey<ChipWrapSelectorState<SearchFor>> searchForSelector = GlobalKey();
    GlobalKey<ChipWrapSelectorState<String>> searchInSelector = GlobalKey();
    GlobalKey<SegmentedButtonSelectorState<OrderBy>> orderBySelector = GlobalKey();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Filtros"),
        leading: IconButton(
          onPressed: context.pop,
          icon: const Icon(Icons.close),
        ),
        actions: [
          TextButton(
              onPressed: () {
                ref.read(SearchProviders.filter.notifier).set(
                      orderBy: orderBySelector.currentState?.selected(),
                      bookIds: searchInSelector.currentState?.selection(),
                      searchFor: searchForSelector.currentState?.selection(),
                    );

                context.pop();
              },
              child: const Text("Aplicar")),
          IconButton(
            onPressed: () => ref.read(SearchProviders.filter.notifier).reset(),
            icon: const Icon(Icons.restart_alt),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SearchFilterSection(
                title: "Ordenar por",
                child: OrderBySelector(
                  selector: orderBySelector,
                ),
              ),
              const Gap(30),
              SearchFilterSection(
                title: "Buscar",
                child: SearchForSelector(
                  selectorKey: searchForSelector,
                ),
              ),
              const Gap(30),
              SearchFilterSection(
                title: "Buscar en",
                child: SearchInSelector(
                  selectorKey: searchInSelector,
                ),
              ),
              const Gap(30),
            ],
          ),
        ),
      ),
    );
  }
}

class MetricsData extends ConsumerWidget {
  const MetricsData({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SearchMetrics metrics = ref.watch(SearchProviders.metrics);

    return Text("-- METRICS --\nBuild: ${metrics.build}ms\n"
        "Search: ${metrics.search}ms\n"
        "Filter: ${metrics.filter}ms\n"
        "Cache: ${metrics.cache}ms\n"
        "Sort: ${metrics.sort}ms");
  }
}

class SearchFilterSection extends StatelessWidget {
  final String title;
  final Widget child;

  const SearchFilterSection({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionTitle(text: title),
        const Gap(15),
        child,
      ],
    );
  }
}
